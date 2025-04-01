import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tradly_app/extensions/context_extensions.dart';
import 'package:tradly_app/resources/l10n_generated/l10n.dart';
import 'package:tradly_app/routes/app_router.dart';
import 'package:tradly_app/widgets/assets.dart';
import 'package:tradly_app/widgets/button.dart';
import 'package:tradly_app/widgets/text.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class OnboardingItem {
  final Widget image;
  final String description;

  OnboardingItem({
    required this.image,
    required this.description,
  });
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController pageController = PageController();

  final int numPages = 3;
  int currentPage = 0;

  final List<OnboardingItem> onboardingData = [
    OnboardingItem(
      image: TAAssets.onboardingBusiness(),
      description: S.current.onBoardingBusinessDescription,
    ),
    OnboardingItem(
      image: TAAssets.onboardingSocial(),
      description: S.current.onBoardingSocialDescription,
    ),
    OnboardingItem(
      image: TAAssets.onboardingSupport(),
      description: S.current.onBoardingsupportDescription,
    ),
  ];

  List<Widget> _buildPageIndicator() {
    return List.generate(numPages, (index) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        height: 12,
        width: currentPage == index ? 12 : 12,
        decoration: BoxDecoration(
          color: currentPage == index
              ? context.colorScheme.primary
              : context.colorScheme.primaryContainer,
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      );
    });
  }

  Widget _buildActionButton() {
    final isLastPage = currentPage == numPages - 1;
    return TAElevatedButton(
      padding: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 30,
      ),
      fontWeight: FontWeight.w600,
      text: isLastPage
          ? S.current.onBoardingFinishButton
          : S.current.onBoardingNextButton,
      backgroundColor: context.colorScheme.primary,
      onPressed: () {
        if (isLastPage) {
          context.pushNamed(TAPaths.signIn.name);
        } else {
          pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.onPrimary,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                height: 358,
                color: context.colorScheme.primary,
              ),
              Container(
                height: 454,
                color: context.colorScheme.onPrimary,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: PageView.builder(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) {
                    final item = onboardingData[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 334,
                          width: 304,
                          decoration: BoxDecoration(
                            color: context.colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: item.image,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 46),
                          child: TaHeadlineLargeText(
                            text: item.description,
                            fontWeight: FontWeight.w500,
                            textAlign: TextAlign.center,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
              const SizedBox(height: 25),
              _buildActionButton(),
            ],
          ),
        ],
      ),
    );
  }
}
