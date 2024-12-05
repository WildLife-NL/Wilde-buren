import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:wilde_buren/config/theme/asset_icons.dart';
import 'package:wilde_buren/config/theme/custom_colors.dart';
import 'package:wilde_buren/services/species.dart';
import 'package:wilde_buren/views/reporting/widgets/manager/location.dart';
import 'package:wildlife_api_connection/models/interaction_type.dart';
import 'package:wildlife_api_connection/models/species.dart';

class ReportingCardView extends StatefulWidget {
  final String question;
  final int step;
  final String buttonText;
  final Function onPressed;
  final Function(
    String? description,
    Species? species,
    LatLng? location,
    String? animalSpecies,
  ) onDataChanged;
  final String? animalSpecies;
  final Species? species;
  final InteractionType? interactionType;
  final LatLng? location;
  final String? description;

  final Function goToPreviousPage;

  const ReportingCardView({
    super.key,
    required this.question,
    required this.step,
    required this.buttonText,
    required this.onPressed,
    required this.onDataChanged,
    required this.goToPreviousPage,
    this.animalSpecies,
    this.species,
    this.interactionType,
    this.location,
    this.description,
  });

  @override
  ReportingCardViewState createState() => ReportingCardViewState();
}

class ReportingCardViewState extends State<ReportingCardView> {
  List<Species> _species = [];

  String? _description;
  LatLng? _currentLocation;
  String? _animalSpecies;
  Species? _selectedSpecies;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  bool _descriptionIsEmpty = true;

  List<String> animalSpecies = [
    "Evenhoevigen",
    "Roofdieren",
    "Knaagdieren",
  ];

  @override
  void initState() {
    super.initState();
    _getSpecies();

    if (widget.step == 3 || widget.step == 4) {
      _getLocation();
    }

    _descriptionController.addListener(() {
      setState(() {
        _descriptionIsEmpty = _descriptionController.text.isEmpty;
      });
    });
  }

  void _getLocation() async {
    _currentLocation = await LocationManager().getUserLocation(context);
  }

  void _getSpecies() async {
    var speciesData = await SpeciesService().getAllSpecies();
    if (mounted) {
      setState(() {
        _species = speciesData;
      });
    }
  }

  Future<void> _updateDescription(String? description) async {
    if (mounted) {
      setState(() {
        _description = description;
      });
    }
    widget.onDataChanged(
      _description,
      _selectedSpecies,
      LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
      _animalSpecies,
    );
  }

  Future<void> _updateLocation() async {
    widget.onDataChanged(
      null,
      _selectedSpecies,
      _currentLocation,
      _animalSpecies,
    );
  }

  void _selectSpecies(Species species) {
    if (mounted) {
      setState(() {
        _selectedSpecies = species;
      });
    }
    widget.onDataChanged(
      null,
      _selectedSpecies,
      null,
      _animalSpecies,
    );
  }

  void _selectAnimalSpecies(String animalSpecies) {
    if (mounted) {
      setState(() {
        _animalSpecies = animalSpecies;
      });
    }
    widget.onDataChanged(
      null,
      null,
      null,
      _animalSpecies,
    );
  }

  @override
  Widget build(BuildContext context) {
    _animalSpecies = widget.animalSpecies;
    _selectedSpecies = widget.species;
    _description = widget.description ?? _descriptionController.text;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 28,
                color: CustomColors.primary,
              ),
              onPressed: () {
                if (widget.step != 1) {
                  widget.goToPreviousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            Text(
              widget.question,
              style: const TextStyle(
                color: CustomColors.primary,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.cancel,
                color: Colors.grey,
                size: 28,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        Text(
            "Je bent nu een '${widget.interactionType!.name.toLowerCase()}' aan het rapporteren."),
        const SizedBox(height: 10),
        if (widget.step == 1 || widget.step == 2) ...[
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.step == 1 ? 3 : 2,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: widget.step == 1 ? 0.75 : 0.8,
              ),
              itemCount:
                  widget.step == 1 ? animalSpecies.length : _species.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    if (widget.step == 1) {
                      _selectAnimalSpecies(animalSpecies[index]);
                    } else if (widget.step == 2) {
                      _selectSpecies(_species[index]);
                    }
                    widget.onPressed();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.step == 1) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(0, 4),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AspectRatio(
                                aspectRatio: 1,
                                child: SvgPicture.asset(
                                  AssetIcons.getAnimalSpeciesIcon(
                                    animalSpecies[index].toLowerCase(),
                                  ),
                                )),
                          ),
                        ),
                      ] else ...[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                offset: const Offset(0, 4),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'assets/images/${_species[index].commonName.toLowerCase().replaceAll(' ', '-')}.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Text(
                        widget.step == 1
                            ? animalSpecies[index]
                            : _species[index].commonName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ] else if (widget.step == 3) ...[
          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: Column(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText: 'Beschrijving (Optioneel)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _updateDescription(_descriptionController.text);
                              widget.onPressed();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 24,
                            ),
                          ),
                          child: Text(
                            _descriptionIsEmpty
                                ? "Overslaan"
                                : widget.buttonText,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ] else if (widget.step == 4) ...[
          SizedBox(
            height: 150,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                childAspectRatio: 0.70,
              ),
              itemCount: widget.interactionType!.id != 2 ? 3 : 1,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 4),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: index == 0
                            ? const EdgeInsets.all(15.0)
                            : index == 1
                                ? const EdgeInsets.all(10.0)
                                : const EdgeInsets.all(0),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: index == 0
                                ? SvgPicture.asset(
                                    AssetIcons.getInteractionIcon(
                                        widget.interactionType!.name),
                                  )
                                : index == 1
                                    ? SvgPicture.asset(
                                        AssetIcons.getAnimalSpeciesIcon(
                                          widget.animalSpecies!.toLowerCase(),
                                        ),
                                      )
                                    : Image.asset(
                                        'assets/images/${widget.species!.commonName.toLowerCase().replaceAll(' ', '-')}.jpg',
                                        fit: BoxFit.cover,
                                      ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.interactionType!.id != 2
                          ? index == 0
                              ? widget.interactionType!.name
                              : index == 1
                                  ? widget.animalSpecies ?? ""
                                  : widget.species!.commonName
                          : widget.interactionType!.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.description != null &&
                        widget.description!.isNotEmpty) ...[
                      const Text(
                        "Beschrijving:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: CustomColors.primary,
                        ),
                      ),
                      Text("${widget.description!.substring(0, 40)} ..."),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SizedBox(
              child: FlutterMap(
                mapController: MapController(),
                options: MapOptions(
                  initialCenter: _currentLocation ??
                      const LatLng(51.25851739912562, 5.622422796819703),
                  initialZoom: 11,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.wildlifenl.wildgids',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _currentLocation ??
                            const LatLng(51.25851739912562, 5.622422796819703),
                        width: 30,
                        height: 30,
                        child: SvgPicture.asset(AssetIcons.location),
                        rotate: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: CustomColors.error,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Annuleren"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: CustomColors.primary,
                ),
                onPressed: () {
                  _updateLocation();
                  widget.onPressed();
                },
                child: Text(widget.buttonText),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
