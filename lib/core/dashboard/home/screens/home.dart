import 'package:flutter/material.dart';
import 'package:just_bored/configs/constants.dart';
import 'package:just_bored/core/auth/providers/auth_controller.dart';
import 'package:just_bored/core/dashboard/home/providers/home_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../configs/debug_fns.dart';
import '../../../../local/profile_prefs.dart';
import '../../../../widgets/jb_app_bar.dart';

/// Home screen view
class HomeScreen extends StatefulWidget {
  /// Home screen view
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _init() {
    context.read<HomeController>().fetchRandomTagLines();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final homeReader = context.read<HomeController>();
    final homeWatcher = context.watch<HomeController>();
    return Scaffold(
        backgroundColor: kWhite,
        appBar: const JBAppbar(
          headerText: kAppName,
          needsABackButton: false,
          color: kPrimaryColor,
          iconColor: kWhite,
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: kScreenHeight(context) * 0.8,
                width: kScreenWidth(context),
                decoration: const BoxDecoration(color: kPrimaryColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kPaddingM),
                      child: Text(
                        'Welcome back, ',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.w900, color: kWhite),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kPaddingM),
                      child: Text(
                        context.watch<ProfilePrefs>().userProfile['display_name'] ??
                            (context.watch<AuthController>().fullname.isEmpty
                                ? 'Default'
                                : context.watch<AuthController>().fullname),
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 26, color: kWhite),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: kPaddingS, left: kPaddingM, right: kPaddingM),
                      child: Text(
                        homeWatcher.tagLine,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhite),
                      ),
                    ),
                    SizedBox(height: kScreenHeight(context) * 0.05),
                    Center(
                      child: Lottie.asset(AssetsAnimations.relaxAnim),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Container(
                  height: kScreenHeight(context) * 0.45,
                  width: kScreenWidth(context),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(kMediumRadius),
                      topEnd: Radius.circular(kMediumRadius),
                    ),
                    color: kCanvasColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: kPaddingS),
                          width: kScreenWidth(context) * 0.15,
                          height: 5,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(kMediumRadius),
                            ),
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(kPaddingM),
                        child: Text(
                          'Mood Log',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 18, fontWeight: FontWeight.w900, color: kPrimaryColor),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: _Mood(
                              emojiImgPath: AssetsImages.loveEmoji,
                              emojiName: 'Love',
                              width: kScreenWidth(context) * 0.1,
                              selected: homeWatcher.selectedMood == 'Love',
                              onSelected: () async => await homeReader.selectMood(context, 'Love'),
                            ),
                          ),
                          Expanded(
                            child: _Mood(
                              emojiImgPath: AssetsImages.happyEmoji,
                              emojiName: 'Happy',
                              width: kScreenWidth(context) * 0.1,
                              selected: homeWatcher.selectedMood == 'Happy',
                              onSelected: () async  => await homeReader.selectMood(context, 'Happy'),
                            ),
                          ),
                          Expanded(
                            child: _Mood(
                              emojiImgPath: AssetsImages.sadEmoji,
                              emojiName: 'Sad',
                              width: kScreenWidth(context) * 0.1,
                              selected: homeWatcher.selectedMood == 'Sad',
                              onSelected: () async => await homeReader.selectMood(context, 'Sad'),
                            ),
                          ),
                          Expanded(
                            child: _Mood(
                              emojiImgPath: AssetsImages.depressedEmoji,
                              emojiName: 'Depress',
                              width: kScreenWidth(context) * 0.1,
                              selected: homeWatcher.selectedMood == 'Depress',
                              onSelected: () async => await homeReader.selectMood(context, 'Depress'),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: kPaddingM, right: kPaddingM, top: kPaddingM),
                        child: Text(
                          'Daily Reflection',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 18, fontWeight: FontWeight.w900, color: kPrimaryColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: kPaddingM),
                        child: Text(
                          'How do you feel about your current emotions?',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: 14, color: kBlueThreeVariantColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: kPaddingM, right: kPaddingM, top: kPaddingM),
                        child: _ReflectionInput(
                          controller: homeReader,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

/// Displays component to represent user's mood
class _Mood extends StatelessWidget {
  /// Displays component to represent user's mood
  const _Mood(
      {required this.emojiImgPath,
      required this.emojiName,
      required this.width,
      required this.selected,
      required this.onSelected});

  final String emojiImgPath;
  final String emojiName;
  final double width;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.all(kPaddingS - 5),
        margin: const EdgeInsets.symmetric(horizontal: kPaddingS),
        width: width,
        decoration: BoxDecoration(
          color: selected ? kPrimaryColor : kTransparent,
          borderRadius: const BorderRadius.all(Radius.circular(kSmallRadius)),
          border: Border.all(color: kLightPrimaryColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.asset(
                emojiImgPath,
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(height: kPaddingS),
            Text(
              emojiName,
              style: TextStyle(
                color: selected ? kWhite : null,
                fontWeight: selected ? FontWeight.bold : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// Displays component where users can send their reflections
class _ReflectionInput extends StatelessWidget {
  /// Displays component where users can send their reflections
  _ReflectionInput({required this.controller});
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _userReflection = {};
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: SizedBox(
              //width: kScreenWidth(context) * 0.7,
              child: SingleChildScrollView(
                child: TextFormField(
                  key: const ValueKey('reflection'),
                  keyboardType: TextInputType.text,
                  minLines: 1,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 15.0),
                    labelText: 'Reflection today?',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: kBlueThreeVariantColor, fontWeight: FontWeight.w800),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor)),
                    filled: false,
                    fillColor: kGrey.withOpacity(0.3),
                  ),
                  cursorColor: kPrimaryColor,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You cannot send an empty reflection';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) {
                      _userReflection['reflection'] = value;
                    } else {
                      printOut('Tried saving a null reflection');
                    }
                  },
                ),
              ),
            ),
          ),
          SizedBox(width: kScreenWidth(context) * 0.05),
          SizedBox(
            height: 60,
            width: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: const CircleBorder(),
              ),
              onPressed: () {
                controller.setUserReflection(
                    context: context, formKey: _formKey, userReflection: _userReflection);
              },
              child: const Icon(
                Icons.send_outlined,
                color: kWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
