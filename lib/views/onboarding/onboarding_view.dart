import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wilde_buren/config/theme/asset_icons.dart';
import 'package:wilde_buren/config/theme/custom_colors.dart';
import 'package:wilde_buren/utils/extensions/fade_route.dart';
import 'package:wilde_buren/views/home/home_view.dart';
import 'package:wilde_buren/views/onboarding/widgets/start_page.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  PageController pageController = PageController();
  int currentPage = 0;
  List<String> pages = [
    'start',
    // 'done',
  ];

  @override
  void initState() {
    super.initState();
  }

  /// Return the page based on the index of the page in the onboarding
  Widget getPage(int index) {
    String type = pages[index];
    switch (type) {
      case 'start':
        return StartPage(
          onNext: nextPage,
          onPrev: previousPage,
        );
      // case 'done':
      //   return DonePage(
      //     onNext: nextPage,
      //     onPrev: previousPage,
      //   );
      default:
        return Container();
    }
  }

  /// Navigates to the next page and ends the onboarding if the last page is reached
  void nextPage() {
    if (currentPage < (pages.length - 1)) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 200), curve: Curves.ease);
      return;
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      FadeRoute(const HomeView()),
    );
  }

  /// Navigates to the previous page
  void previousPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (currentPage == 0) {
      prefs.clear();
      return;
    }

    pageController.previousPage(
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        previousPage();
      },
      child: Scaffold(
          backgroundColor: CustomColors.light100,
          appBar: AppBar(
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            // title: Text(
            //   '${currentPage + 1} / ${pages.length}',
            //   style: Theme.of(context).textTheme.titleMedium?.copyWith(color: CustomColors.dark500),
            // ),
            elevation: 0,
            leading: currentPage > 0
                ? IconButton(
                    icon: SvgPicture.asset(
                      AssetIcons.chevronLeft,
                      width: 12,
                      colorFilter: const ColorFilter.mode(
                        CustomColors.dark700,
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: previousPage,
                  )
                : null,
          ),
          body: SafeArea(
            bottom: false,
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pages.length,
              controller: pageController,
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return getPage(index);
              },
            ),
          )),
    );
  }
}
