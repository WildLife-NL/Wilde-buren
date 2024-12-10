import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wilde_buren/config/theme/asset_icons.dart';
import 'package:wilde_buren/config/theme/custom_colors.dart';
import 'package:wilde_buren/config/theme/size_setter.dart';
import 'package:wilde_buren/services/interaction_type.dart';
import 'package:wilde_buren/views/home/widgets/bottom_navigation_bar_indicator.dart';
import 'package:wilde_buren/views/interaction/interaction_view.dart';
import 'package:wilde_buren/views/profile/profile_view.dart';
import 'package:wilde_buren/views/map/map_view.dart';
import 'package:wilde_buren/views/reporting/reporting.dart';
import 'package:wilde_buren/views/reporting/widgets/manager/location.dart';
import 'package:wilde_buren/views/reporting/widgets/snackbar_with_progress_bar.dart';
import 'package:wilde_buren/views/species/species_view.dart';
import 'package:wildlife_api_connection/models/interaction.dart';
import 'package:wildlife_api_connection/models/interaction_type.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    this.interaction,
  });

  final Interaction? interaction;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedIndex = 0;
  List<InteractionType> _interactionTypes = [];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    LocationManager().requestLocationAccess(context);
    _getInteractionTypes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (widget.interaction != null &&
          widget.interaction!.questionnaire != null) {
        SnackBarWithProgress.show(
          context: context,
          interaction: widget.interaction!,
          questionnaire: widget.interaction!.questionnaire!,
        );
      }
    });
  }

  Future<void> _getInteractionTypes() async {
    try {
      var interactionTypesData =
          await InteractionTypeService().getAllInteractionTypes();
      setState(() {
        _interactionTypes = interactionTypesData;
      });
    } catch (e) {
      debugPrint("Error fetching interaction types: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: selectedIndex,
            children: const [
              InteractionView(),
              MapView(),
              SpeciesView(),
              ProfileView(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Stack(
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              splashFactory: NoSplash.splashFactory,
            ),
            child: BottomAppBar(
              color: CustomColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 0),
              height: SizeSetter.getBottomNavigationBarHeight(),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildNavItem(Icons.home, "Home", 0),
                  _buildNavItem(Icons.location_on, "Map", 1),
                  _buildNavItem(Icons.add_box_outlined, "", -1, isCenter: true),
                  _buildNavItem(Icons.info, "Wiki", 2),
                  _buildNavItem(Icons.person, "Account", 3),
                ],
              ),
            ),
          ),
          BottomNavigationBarIndicator(
            selectedIndex:
                selectedIndex >= 2 ? selectedIndex + 1 : selectedIndex,
            indicatorWidth: MediaQuery.of(context).size.width / 5,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index,
      {bool isCenter = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isCenter) {
            onItemTapped(index);
          } else {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              backgroundColor: CustomColors.light700,
              builder: (context) => Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Maak rapportage:",
                          style: TextStyle(
                            fontSize: 20,
                            color: CustomColors.primary,
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
                    const SizedBox(height: 20),
                    if (_interactionTypes.isNotEmpty)
                      _buildInteractionTypes(_interactionTypes)
                    else
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            );
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isCenter ? 42 : 28,
              color: Colors.white,
            ),
            if (label.isNotEmpty)
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionTypes(List<InteractionType> interactionTypes) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
        childAspectRatio: 0.8,
      ),
      itemCount: interactionTypes.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            ReportingView.show(
              context: context,
              interactionType: interactionTypes[index],
              initialPage: 0,
            );
          },
          child: Column(
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
                  padding: const EdgeInsets.all(20),
                  child: SvgPicture.asset(
                    AssetIcons.getInteractionIcon(interactionTypes[index].name),
                    fit: BoxFit.cover,
                    placeholderBuilder: (BuildContext context) => Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                interactionTypes[index].name,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
