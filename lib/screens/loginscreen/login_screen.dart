import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_haha_guys/core/common/sign_in_button.dart';
import 'package:the_haha_guys/core/constants/constants.dart';
import 'package:the_haha_guys/responsive/responsive.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: ClipOval(
          child: Image.asset(
            Constants.loginEmotePath,
            height: 40,
            width: 40,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => {},
            //  signInAsGuest(ref, context),
            child: const Text(
              'Skip',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body:
          //  isLoading.user != null
          //     ? const Loader()
          //     :
          Column(
        children: [
          const SizedBox(height: 60),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Center(
                  child: Text(
                    'Find your own way to vent out your emotions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              child: Image.asset(
                Constants.loginEmotePath,
                height: 250,
                width: 250,
              ),
            ),
          ),
          const SizedBox(height: 60),
          const Responsive(child: SignInButton()),
        ],
      ),
    );
  }
}
