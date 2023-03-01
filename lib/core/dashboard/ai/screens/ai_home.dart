import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_bored/configs/constants.dart';
import 'package:just_bored/core/dashboard/ai/providers/ai_category_controller.dart';
import 'package:just_bored/widgets/jb_app_bar.dart';

/// AI Home Screen
class AIHomeScreen extends StatefulWidget {
  /// AI Home Screen
  const AIHomeScreen({super.key});

  @override
  State<AIHomeScreen> createState() => _AIHomeScreenState();
}

class _AIHomeScreenState extends State<AIHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final aiControllerReader = context.read<AICategoryController>();
    return Scaffold(
      appBar: const JBAppbar(
        headerText: 'Just Bored',
        needsABackButton: false,
        color: kPrimaryColor,
        iconColor: kWhite,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: kPaddingS),
                child: _Category(
                  name: 'Ask me anything',
                  imagePath: AssetsImages.manChatting,
                  onPressed: () {
                    aiControllerReader.controlSelectedAICategory(context, categoryCode: 1);
                  },
                ),
              ),
              _Category(
                name: 'Did you know?',
                imagePath: AssetsImages.womanHearingFacts,
                onPressed: () {
                  aiControllerReader.controlSelectedAICategory(context, categoryCode: 2);
                },
              ),
              _Category(
                name: 'Jokes & Riddles',
                imagePath: AssetsImages.babyLaughing,
                onPressed: () {
                  aiControllerReader.controlSelectedAICategory(context, categoryCode: 3);
                },
              ),
              _Category(
                name: 'Image Gen',
                imagePath: AssetsImages.shareViews,
                onPressed: () {
                  aiControllerReader.controlSelectedAICategory(context, categoryCode: 4);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Each AI Function category
class _Category extends StatelessWidget {
  /// Each AI Function category
  const _Category({required this.name, required this.imagePath, required this.onPressed});

  final String name;
  final String imagePath;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: kScreenWidth(context),
        height: kScreenHeight(context) * 0.2,
        margin: const EdgeInsets.all(kPaddingS),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(kMediumRadius)),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(kPaddingS),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: kWhite, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Icon(Icons.arrow_forward, color: kWhite)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
