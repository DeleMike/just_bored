import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../configs/constants.dart';
import '../../configs/routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: PageView(
          controller: _controller,
          children: const [
            // first page
            _View(
              imgPath: AssetsImages.onboardingImgOne,
              viewName: 'Peace.',
              tagLine: '"Peace begins with a smile." - Mother Teresa',
            ),

            //second page
            _View(
              imgPath: AssetsImages.onboardingImgTwo,
              viewName: 'Calm.',
              tagLine: 'Find peace in the calm.',
            ),

            //third page
            _View(
              imgPath: AssetsImages.onboardingImgThree,
              viewName: 'Bored.',
              tagLine: 'Embrace the boredom, find inspiration.',
            ),
          ],
        ),
        bottomSheet: Container(
          height: kScreenHeight(context) * 0.10,
          color: kLightPrimaryColor,
          padding: const EdgeInsets.all(kPaddingS),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: ExpandingDotsEffect(
                  spacing: 16,
                  radius: 16,
                  dotHeight: 8,
                  dotWidth: 8,
                  dotColor: kPrimaryColor.withOpacity(0.3),
                  activeDotColor: kPrimaryColor,
                ),
              ),
              SizedBox(
                height: 60,
                width: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(Routes.auth);
                  },
                  child: const Icon(Icons.arrow_forward),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// General Top View for Onboarding
class _View extends StatelessWidget {
  final String imgPath;
  final String viewName;
  final String tagLine;

  /// General Top View for Onboarding
  const _View({Key? key, required this.imgPath, required this.viewName, required this.tagLine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryColor,
      child: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage(imgPath),
              backgroundColor: kTransparent,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                  left: kPaddingS + 2, right: kPaddingM + 2, top: 2, bottom: kPaddingS - 5),
              child: Text(
                viewName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: kFontFamily, fontWeight: FontWeight.w600, fontSize: 33, color: kWhite),
              ),
            ),
            const Spacer(),
            Text(tagLine,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kWhite)),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
