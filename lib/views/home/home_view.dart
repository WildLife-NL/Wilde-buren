import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wilde_buren/config/theme/asset_icons.dart';
import 'package:wilde_buren/config/theme/custom_colors.dart';
import 'package:wilde_buren/config/theme/size_setter.dart';
import 'package:wilde_buren/services/interaction_type.dart';
import 'package:wilde_buren/views/interaction/interaction_view.dart';
import 'package:wilde_buren/views/profile/profile_view.dart';
import 'package:wilde_buren/views/map/map_view.dart';
import 'package:wilde_buren/views/reporting/reporting.dart';
import 'package:wilde_buren/views/reporting/widgets/manager/location.dart';
import 'package:wilde_buren/views/reporting/widgets/snackbar_with_progress_bar.dart';
import 'package:wilde_buren/views/wiki/wiki_view.dart';
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
              MapView(),
              InteractionView(),
              SpeciesView(),
              ProfileView(),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColors.primary,
        shape: const CircleBorder(),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            backgroundColor: CustomColors.light700,
            builder: (context) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
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
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32.0,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: SizeSetter.getBottomNavigationBarHeight(),
        color: CustomColors.light700,
        shape: const CircularNotchedRectangle(),
        notchMargin: 15,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildNavItem(Icons.home_outlined, "Home", 0),
            _buildNavItem(Icons.notification_add_outlined, "Meldingen", 1),
            const Spacer(),
            _buildNavItem(Icons.info_outline, "Wiki", 2),
            _buildNavItem(Icons.person_outline, "Account", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onItemTapped(index);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: selectedIndex == index ? 32 : 28,
              color:
                  selectedIndex == index ? CustomColors.primary : Colors.black,
            ),
            if (label.isNotEmpty)
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: selectedIndex == index
                      ? CustomColors.primary
                      : Colors.black,
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
