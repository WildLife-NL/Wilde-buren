import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wilde_buren/config/theme/custom_colors.dart';
import 'package:wilde_buren/services/interaction.dart';
import 'package:wilde_buren/views/home/home_view.dart';
import 'package:wilde_buren/views/reporting/reporting_card.dart';
import 'package:wilde_buren/views/reporting/widgets/manager/location.dart';
import 'package:wildlife_api_connection/models/interaction.dart';
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

  static void show({
    required BuildContext context,
    required InteractionType interactionType,
    int initialPage = 0,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: CustomColors.light700,
      builder: (BuildContext context) {
        return ReportingView(
          interactionType: interactionType,
          initialPage: initialPage,
        );
      },
    );
  }

  @override
  ReportingViewState createState() => ReportingViewState();
}

class ReportingViewState extends State<ReportingView> {
  final PageController _pageController = PageController();
  String? _description;
  String? _selectedAnimalSpecies;
  Species? _selectedSpecies;
  LatLng? _reportLocation;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    final location = await LocationManager().getUserLocation(context);

    setState(() {
      _reportLocation = location;
    });
  }

  void _updateInteractionData(
    String? description,
    Species? species,
    String? animalSpecies,
  ) async {
    setState(() {
      _description = description;
      _selectedSpecies = species;
      _selectedAnimalSpecies = animalSpecies;
    });
  }

  Future<Interaction?> _submitReport() async {
    if (_selectedSpecies != null && _reportLocation != null) {
      return InteractionService().createInteraction(
        _description ?? "",
        Location(
          latitude: _reportLocation?.latitude ?? 0,
          longitude: _reportLocation?.longitude ?? 0,
        ),
        _selectedSpecies?.id ?? "",
        widget.interactionType.id,
      );
    }
    return null;
  }

  List<Widget> _buildReportingPages() {
    return [
      ReportingCardView(
        question: "Diersoort rapportage:",
        step: 1,
        buttonText: "Volgende",
        goToPreviousPage: _pageController.previousPage,
        onPressed: () {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );
        },
        onDataChanged: _updateInteractionData,
        interactionType: widget.interactionType,
      ),
      ReportingCardView(
        question: "Dier rapportage:",
        step: 2,
        buttonText: "Volgende",
        animalSpecies: _selectedAnimalSpecies,
        goToPreviousPage: _pageController.previousPage,
        onPressed: () {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );
        },
        onDataChanged: _updateInteractionData,
        interactionType: widget.interactionType,
      ),
      ReportingCardView(
        question: "Heb je nog opmerkingen?",
        step: 3,
        buttonText: "Volgende",
        goToPreviousPage: _pageController.previousPage,
        onPressed: () {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.linear,
          );
        },
        location: _reportLocation,
        animalSpecies: _selectedAnimalSpecies,
        species: _selectedSpecies,
        interactionType: widget.interactionType,
        onDataChanged: _updateInteractionData,
      ),
      ReportingCardView(
        question: "Overzicht rapportage:",
        step: 4,
        buttonText: "Rapporteer",
        goToPreviousPage: _pageController.previousPage,
        onPressed: () async {
          final interaction = await _submitReport();
          if (interaction != null && interaction.questionnaire != null) {
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeView(
                    interaction: interaction,
                  ),
                ),
                (route) => false,
              );
            }
          }
        },
        location: _reportLocation,
        species: _selectedSpecies,
        animalSpecies: _selectedAnimalSpecies,
        interactionType: widget.interactionType,
        description: _description,
        onDataChanged: _updateInteractionData,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.60,
            ),
            child: PageView(
              controller: _pageController,
              children: _buildReportingPages(),
            ),
          ),
          const SizedBox(height: 20),
          SmoothPageIndicator(
            controller: _pageController,
            count: _buildReportingPages().length,
            effect: const WormEffect(
              activeDotColor: CustomColors.primary,
            ),
            onDotClicked: (index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
    );
  }
}
