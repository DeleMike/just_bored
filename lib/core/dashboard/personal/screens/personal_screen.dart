import 'package:flutter/material.dart';
import 'package:just_bored/core/dashboard/personal/providers/personal_controller.dart';
import 'package:provider/provider.dart';

import '../../../../configs/constants.dart';
import '../../../../widgets/jb_app_bar.dart';

/// Personal Screen View
class PersonalScreen extends StatefulWidget {
  /// Personal Screen View
  const PersonalScreen({super.key});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  @override
  Widget build(BuildContext context) {
    final personalControllerReader = context.read<PersonalController>();
    return Scaffold(
      appBar: const JBAppbar(
        headerText: 'Just Bored',
        needsABackButton: false,
        color: kPrimaryColor,
        iconColor: kWhite,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Category(
              name: 'Settings',
              imagePath: AssetsImages.settingsGear,
              onPressed: () {
                personalControllerReader.controlSelectedPersonalCategory(categoryCode: 1);
              },
            ),
            _Category(
              name: 'View Mood logs',
              imagePath: AssetsImages.moodLogIcon,
              onPressed: () {
                personalControllerReader.controlSelectedPersonalCategory(categoryCode: 2);
              },
            ),
            _Category(
              name: 'View Reflections',
              imagePath: AssetsImages.reflectionIcon,
              onPressed: () {
                personalControllerReader.controlSelectedPersonalCategory(categoryCode: 3);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Each Personal Function category
class _Category extends StatelessWidget {
  /// Each Personal Function category
  const _Category({required this.name, required this.imagePath, required this.onPressed});

  final String name;
  final String imagePath;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: kPaddingS, vertical: kPaddingS - 5),
        width: kScreenWidth(context),
        decoration: BoxDecoration(
          color: kWhite,
          border: Border.all(color: kLightPrimaryColor),
          
        ),
        padding: const EdgeInsets.all(kPaddingS),
        child: Row(
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Image.asset(imagePath),
            ),
            SizedBox(width: kScreenWidth(context) * 0.03),
            Text(
              name,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward)
          ],
        ),
      ),
    );
  }
}
