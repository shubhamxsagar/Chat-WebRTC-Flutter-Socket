import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_haha_guys/core/common/logger.dart';
import 'package:the_haha_guys/core/constants/constants.dart';
import 'package:the_haha_guys/route_constants.dart';
import 'package:the_haha_guys/screens/homescreen/home_screen.dart';
import 'package:the_haha_guys/theme/pallete.dart';
import 'package:the_haha_guys/view_models/auth_view_model.dart';
import 'package:go_router/go_router.dart';

class SignInButton extends ConsumerWidget {
  final bool isFromLogin;
  const SignInButton({Key? key, this.isFromLogin = true}) : super(key: key);

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    // final navigator = Navigator.of(context);
    final errorModel =
        await ref.read(authRepositoryProvider).signInWithGoogle();
    logger.d('SignInWithGoogle ErrorModel: ${errorModel.error}');
    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      // navigator.push(MaterialPageRoute(builder: (context) => HomeScreen()));
      // context.push('/');
      context.pushNamed(RouteConstants.home);
    } else {
      sMessenger.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(ref, context),
        icon: Image.asset(
          Constants.googlePath,
          width: 35,
        ),
        label: const Text(
          'Continue with Google',
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
