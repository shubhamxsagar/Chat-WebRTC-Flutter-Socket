import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:the_haha_guys/core/rich_text/base_text.dart';
import 'package:the_haha_guys/core/rich_text/link_text.dart';

class RichTextWidget extends StatelessWidget {
  final TextStyle? styleForAll;
  final Iterable<BaseText> texts;

  const RichTextWidget({super.key, required this.texts, this.styleForAll});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: texts.map((baseText) {
          if (baseText is LinkText) {
            return TextSpan(
              text: baseText.text,
              style: styleForAll?.merge(baseText.style),
              recognizer: TapGestureRecognizer()..onTap = baseText.onTapped,
            );
          } else {
            return TextSpan(
              text: baseText.text,
              style: styleForAll?.merge(baseText.style),
            );
          }
        }).toList(),
      ),
    );
  }
}
