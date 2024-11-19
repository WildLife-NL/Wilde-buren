import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wilde_buren/services/interaction.dart';
import 'package:wilde_buren/config/theme/custom_colors.dart';
import 'package:wilde_buren/views/reporting/reviewing_card.dart';
import 'package:wilde_buren/widgets/custom_scaffold.dart';
import 'package:wildlife_api_connection/models/interaction_type.dart';
import 'package:wildlife_api_connection/models/location.dart';
import 'package:wildlife_api_connection/models/species.dart';

class ReportingView extends StatefulWidget {
  final int initialPage;
  final InteractionType interactionType;

  const ReportingView({
    super.key,
    required this.initialPage,
    required this.interactionType,
  });

  @override
  ReportingViewState createState() => ReportingViewState();
}

class ReportingViewState extends State<ReportingView> {
  final PageController _pageController = PageController();
  String? _description;
  String? _selectedAnimalSpecies;
  Species? _selectedSpecies;
  LatLng? _reportLocation;

  void _updateInteractionData(
    String? description,
    Species? species,
    LatLng? location,
    String? animalSpecies,
  ) {
    setState(() {
      _description = description;
      _selectedSpecies = species;
      _selectedAnimalSpecies = animalSpecies;
      _reportLocation = location;
    });
  }

  void _submitReport() {
    if (_selectedSpecies != null && _reportLocation != null) {
      InteractionService().createInteraction(
        _description ?? "",
        Location(
            latitude: _reportLocation!.latitude.toInt(),
            longitude: _reportLocation!.longitude.toInt()),
        _selectedSpecies!.id,
        widget.interactionType.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> reportingPages = [
      if (widget.interactionType.id != 2) ...[
        ReportingCardView(
          question:
              "Welk diersoort hoort bij de ${widget.interactionType.name.toLowerCase()}?",
          step: 1,
          buttonText: "Volgende",
          onPressed: () {
            _pageController.nextPage(
              duration: Durations.long1,
              curve: Curves.linear,
            );
          },
          onDataChanged: _updateInteractionData,
        ),
        ReportingCardView(
          question:
              "Welk ${_selectedAnimalSpecies != null ? _selectedAnimalSpecies!.substring(0, _selectedAnimalSpecies!.length - 2).toLowerCase() : "diersoort"} hoort bij de ${widget.interactionType.name.toLowerCase()}?",
          step: 2,
          buttonText: "Volgende",
          animalSpecies: _selectedAnimalSpecies,
          onPressed: () {
            _pageController.nextPage(
              duration: Durations.long1,
              curve: Curves.linear,
            );
          },
          onDataChanged: _updateInteractionData,
        ),
      ],
      ReportingCardView(
        question:
            "Dit is de locatie van je ${widget.interactionType.name.toLowerCase()}.",
        step: 3,
        buttonText: "Volgende",
        species: _selectedSpecies,
        onPressed: () {
          _pageController.nextPage(
            duration: Durations.long1,
            curve: Curves.linear,
          );
        },
        onDataChanged: _updateInteractionData,
      ),
      if (widget.interactionType.id == 2) ...[
        ReportingCardView(
          question: "Heb je nog opmerkingen?",
          step: 4,
          buttonText: "Overslaan",
          onPressed: () {
            _pageController.nextPage(
              duration: Durations.long1,
              curve: Curves.linear,
            );
          },
          location: _reportLocation,
          species: _selectedSpecies,
          interactionType: widget.interactionType,
          onDataChanged: _updateInteractionData,
        ),
      ],
      ReportingCardView(
        question: "Klopt je rapportage?",
        step: 5,
        buttonText: "Rapporteer",
        onPressed: () {
          _submitReport();
          Navigator.pop(context);
        },
        location: _reportLocation,
        species: _selectedSpecies,
        interactionType: widget.interactionType,
        description: _description,
        onDataChanged: _updateInteractionData,
      ),
    ];

    return CustomScaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: CustomColors.primary,
          ),
          onPressed: () async {
            if (_pageController.page == 0) {
              Navigator.of(context).pop();
            } else {
              await _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          },
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: reportingPages,
            ),
          ),
          const SizedBox(height: 10),
          SmoothPageIndicator(
            controller: _pageController,
            count: reportingPages.length,
            effect: const WormEffect(
              activeDotColor: CustomColors.primary,
            ),
            onDotClicked: (index) {
              _pageController.animateToPage(
                index,
                duration: Durations.long1,
                curve: Curves.bounceInOut,
              );
            },
          )
        ],
      ),
    );
  }
}
