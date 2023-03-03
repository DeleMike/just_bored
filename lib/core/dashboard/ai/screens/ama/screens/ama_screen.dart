import 'package:flutter/material.dart';
import 'package:dart_openai/openai.dart';
import 'package:bubble/bubble.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

import '../models/ama.dart';
import '../providers/ama_controller.dart';

import '../../../../../../configs/constants.dart';
import '../../../../../../widgets/close_dialog.dart';
import '../../../../../../configs/debug_fns.dart';
import '../../../../../../widgets/jb_app_bar.dart';

/// contains the UI screen for the AMA session
class AmaScreen extends StatefulWidget {
  /// contains the UI screen for the AMA session
  const AmaScreen({super.key});

  @override
  State<AmaScreen> createState() => _AmaScreenState();
}

class _AmaScreenState extends State<AmaScreen> {
  OpenAI? openAI;

  _init() async {
    openAI = context.read<AmaController>().initAIEngine();
    printOut('OpenAI Object = $openAI', 'AmaScreen');
    context.read<AmaController>().initChat(openAI);
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amaReader = context.read<AmaController>();
    final amaWatcher = context.watch<AmaController>();
    return Scaffold(
      appBar: JBAppbar(
        headerText: 'Just Bored',
        needsABackButton: true,
        needsLogoutButton: false,
        handleBackButtonPress: () async {
          final wantsToLeave = await closeDialog(context);
          if (wantsToLeave) {
            amaReader.reset();
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
          amaReader.reset();
          return true;
        },
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: kPaddingS, right: kPaddingS, bottom: kPaddingS),
                child: _ChatSpace(controller: amaWatcher),
              ),
            ),
            if (amaWatcher.isLoading) const Center(child: CircularProgressIndicator()),
            Padding(
              padding: const EdgeInsets.all(kPaddingS),
              child: _ChatInput(
                controller: amaReader,
                openAI: openAI,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// displays component for chatting space
class _ChatSpace extends StatelessWidget {
  /// displays component for chatting space
  const _ChatSpace({required this.controller});

  final AmaController controller;

  @override
  Widget build(BuildContext context) {
    return GroupedListView<Ama, DateTime>(
      reverse: true,
      elements: controller.chats.reversed.toList(),
      groupBy: (Ama ama) =>
          DateTime.now(), // to group all the chats at once, since the chat room is a one time thing
      groupHeaderBuilder: (Ama ama) => SizedBox(height: kScreenHeight(context) * 0.02),
      itemBuilder: (context, Ama ama) => Align(
        alignment: ama.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Bubble(
          nipWidth: kPaddingS,
          nipHeight: kPaddingS - 4,
          nip: ama.isUser ? BubbleNip.rightBottom : BubbleNip.leftBottom,
          color: ama.isUser ? kLightPrimaryColor : kPrimaryColor,
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(kPaddingS),
            child: Theme(
              data: ThemeData(
                textSelectionTheme: TextSelectionThemeData(
                  selectionColor: ama.isUser ? null : kAccentColor,
                  selectionHandleColor: ama.isUser ? kRed : kAccentColor,
                ),
              ),
              child: SelectableText(
                ama.message,
                style: ama.isUser
                    ? Theme.of(context).textTheme.bodyMedium
                    : Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhite),
                scrollPhysics: const ClampingScrollPhysics(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Displays component where users can send their questions
class _ChatInput extends StatelessWidget {
  /// Displays component where users can send their questions
  _ChatInput({
    required this.controller,
    required this.openAI,
  });
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _userMessage = {};
  final TextEditingController textEditingController = TextEditingController();
  final AmaController controller;
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
              //width: kScreenWidth(context) * 0.7,
              child: SingleChildScrollView(
                child: TextFormField(
                  key: const ValueKey('ama'),
                  keyboardType: TextInputType.text,
                  minLines: 1,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 12),
                  controller: textEditingController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 15.0),
                    labelText: 'Ask me anything...',
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
                      return 'You cannot send an empty message';
                    }

                    return null;
                  },
                  onSaved: (value) {
                    if (value != null) {
                      _userMessage['message'] = value;
                    } else {
                      printOut('Tried saving a null message');
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
                await controller.sendMessage(
                  context: context,
                  formKey: _formKey,
                  messageData: _userMessage,
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
