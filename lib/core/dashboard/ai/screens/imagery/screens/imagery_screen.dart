import 'package:bubble/bubble.dart';
import 'package:dart_openai/openai.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:just_bored/core/dashboard/ai/screens/imagery/providers/imagery_controller.dart';
import 'package:provider/provider.dart';

import '../../../../../../configs/constants.dart';
import '../../../../../../configs/debug_fns.dart';
import '../../../../../../widgets/close_dialog.dart';
import '../../../../../../widgets/jb_app_bar.dart';
import '../models/imagery.dart';

/// Display screen for image genration functions
class ImageryScreen extends StatefulWidget {
  /// Display screen for image genration functions
  const ImageryScreen({super.key});

  @override
  State<ImageryScreen> createState() => _ImageryScreenState();
}

class _ImageryScreenState extends State<ImageryScreen> {
  OpenAI? openAI;

  _init() async {
    openAI = context.read<ImageryController>().initAIEngine();
    printOut('OpenAI Object = $openAI', 'AmaScreen');
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final imgReader = context.read<ImageryController>();
    final imgWatcher = context.watch<ImageryController>();
    return Scaffold(
      appBar: JBAppbar(
        headerText: 'Just Bored',
        needsABackButton: true,
        needsLogoutButton: false,
        handleBackButtonPress: () async {
          final wantsToLeave = await closeDialog(context);
          if (wantsToLeave) {
            imgReader.reset();
            if (context.mounted) {
              Navigator.of(context).pop();
            } else {
              return;
            }
          }
        },
        color: kPrimaryColor,
        iconColor: kWhite,
      ),
      body: WillPopScope(
        onWillPop: () async {
          final wantsToLeave = await closeDialog(context);
          if (wantsToLeave) {
            imgReader.reset();
            return true;
          } else {
            return false;
          }
        },
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: kPaddingS, right: kPaddingS, bottom: kPaddingS),
                child: _ImageGenSpace(controller: imgWatcher),
              ),
            ),
            if (imgWatcher.isLoading) const Center(child: CircularProgressIndicator()),
            Padding(
              padding: const EdgeInsets.all(kPaddingS),
              child: _PromptInput(
                controller: imgReader,
                openAI: openAI,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// displays component for replying user with image
class _ImageGenSpace extends StatelessWidget {
  /// displays component for replying user with image
  const _ImageGenSpace({required this.controller});

  final ImageryController controller;

  @override
  Widget build(BuildContext context) {
    return GroupedListView<Imagery, DateTime>(
      reverse: true,
      elements: controller.promptsAndImages.reversed.toList(),
      groupBy: (Imagery imagery) =>
          DateTime.now(), // to group all the chats at once, since the chat room is a one time thing
      groupHeaderBuilder: (Imagery imagery) => SizedBox(height: kScreenHeight(context) * 0.02),
      itemBuilder: (context, Imagery imagery) => Align(
        alignment: imagery.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: imagery.isUser
            ? Bubble(
                nipWidth: kPaddingS,
                nipHeight: kPaddingS - 4,
                nip: BubbleNip.rightBottom,
                color: imagery.isUser ? kLightPrimaryColor : kPrimaryColor,
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(kPaddingS),
                  child: SelectableText(
                    imagery.prompt,
                    style: Theme.of(context).textTheme.bodyMedium,
                    scrollPhysics: const ClampingScrollPhysics(),
                  ),
                ),
              )
            : Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kSmallRadius)),
                color: kCanvasColor,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(kSmallRadius),
                        topRight: Radius.circular(kSmallRadius),
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: kScreenHeight(context) * 0.1, minWidth: kScreenWidth(context)),
                        child: Image.network(
                          imagery.imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: ((context, error, stackTrace) {
                            return Image.asset(AssetsImages.babyLaughing);
                          }),
                        ),
                      ),
                    ),
                    const _ImageActionBar(),
                  ],
                ),
              ),
      ),
    );
  }
}

/// contains functions the user can do with the generated image
class _ImageActionBar extends StatelessWidget {
  /// contains functions the user can do with the generated image

  const _ImageActionBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(kPaddingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: kWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kSmallRadius)),
            ),
            onPressed: () {},
            label: Text('Save', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhite)),
            icon: const Icon(
              Icons.favorite_border_outlined,
            ),
          ),
          SizedBox(width: kScreenWidth(context) * 0.03),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: kWhite,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kSmallRadius)),
            ),
            onPressed: () {},
            label: Text('Share', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhite)),
            icon: const Icon(
              Icons.share_outlined,
            ),
          ),
        ],
      ),
    );
  }
}

// Displays component where users can send their prompts
class _PromptInput extends StatelessWidget {
  /// Displays component where users can send their prompts
  _PromptInput({
    required this.controller,
    required this.openAI,
  });
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _userMessage = {};
  final TextEditingController textEditingController = TextEditingController();
  final ImageryController controller;
  final OpenAI? openAI;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: SizedBox(
              child: SingleChildScrollView(
                child: TextFormField(
                  key: const ValueKey('img_gen'),
                  keyboardType: TextInputType.text,
                  minLines: 1,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 12),
                  controller: textEditingController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 15.0),
                    labelText: 'What imagery is on your mind?',
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
                      return 'You cannot send an empty prompt';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) {
                      _userMessage['prompt'] = value;
                    } else {
                      printOut('Tried saving a null prompt');
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
              onPressed: () async {
                await controller.sendPrompt(
                  context: context,
                  formKey: _formKey,
                  promptData: _userMessage,
                  controller: textEditingController,
                  openAiInstance: openAI,
                );
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
