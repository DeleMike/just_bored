import 'package:flutter/material.dart';
import 'package:just_bored/configs/constants.dart';

import '../../../../widgets/jb_app_bar.dart';

/// Home screen view
class HomeScreen extends StatefulWidget {
  /// Home screen view
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedMood = '';

  /// for mood change
  ///
  /// if the user selects an already selected mood, it clears away
  ///
  /// else it sets that selected mood as the current mood
  void _selectMood(String mood) {
    if (_selectedMood == mood) {
      _selectedMood = '';
    } else {
      _selectedMood = mood;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                child: const FlutterLogo(
                  size: 300,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Expanded(
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
                            'Daily Mood Log',
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
                                selected: _selectedMood == 'Love',
                                onSelected: () => _selectMood('Love'),
                              ),
                            ),
                            Expanded(
                              child: _Mood(
                                emojiImgPath: AssetsImages.happyEmoji,
                                emojiName: 'Happy',
                                width: kScreenWidth(context) * 0.1,
                                selected: _selectedMood == 'Happy',
                                onSelected: () => _selectMood('Happy'),
                              ),
                            ),
                            Expanded(
                              child: _Mood(
                                emojiImgPath: AssetsImages.sadEmoji,
                                emojiName: 'Sad',
                                width: kScreenWidth(context) * 0.1,
                                selected: _selectedMood == 'Sad',
                                onSelected: () => _selectMood('Sad'),
                              ),
                            ),
                            Expanded(
                              child: _Mood(
                                emojiImgPath: AssetsImages.depressedEmoji,
                                emojiName: 'Depress',
                                width: kScreenWidth(context) * 0.1,
                                selected: _selectedMood == 'Depress',
                                onSelected: () => _selectMood('Depress'),
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
                          child: _ReflectionInput(),
                        ),
                        
              
                      ],
                    ),
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
  _ReflectionInput();
  final _formKey = GlobalKey<FormState>();

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
                      return 'You cannot send reflection';
                    }
                        
                    return null;
                  },
                  onSaved: (value) {},
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
              onPressed: () {},
              child: const Icon(Icons.send_outlined, color: kWhite,),
            ),
           ),
        ],
      ),
    );
  }
}
