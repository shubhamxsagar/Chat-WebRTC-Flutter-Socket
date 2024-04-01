// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    this.text,
    required this.child,
    this.actions,
  }) : super(key: key);
  final String? text;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        iconTheme: const IconThemeData(),
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 70,
        leading: child,
        actions: actions,
        centerTitle: true,
        title: Text(
          text!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
