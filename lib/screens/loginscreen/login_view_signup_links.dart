import 'package:flutter/material.dart';
import 'package:the_haha_guys/core/constants/strings.dart';
import 'package:the_haha_guys/core/rich_text/base_text.dart';
import 'package:the_haha_guys/core/rich_text/rich_text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginViewSignupLink extends StatelessWidget {
  const LoginViewSignupLink({super.key});

  @override
  Widget build(BuildContext context) {
    return RichTextWidget(
      texts: [
        BaseText.plain(
          text: Strings.dontHaveAnAccount,
        ),
        BaseText.plain(
          text: Strings.signUpOn,
        ),
        BaseText.link(
          text: Strings.facebook,
          onTapped: () {
            launchUrl(
              Uri.parse(
                Strings.facebookSignupUrl,
              ),
            );
          },
        ),
        BaseText.plain(
          text: Strings.orCreateAnAccountOn,
        ),
        BaseText.link(
          text: Strings.google,
          onTapped: () {
            launchUrl(
              Uri.parse(
                Strings.googleSignupUrl,
              ),
            );
          },
        ),
      ],
      styleForAll:
          Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.5),
    );
  }
}
