import 'package:flutter/foundation.dart' show immutable, VoidCallback;
import 'package:the_haha_guys/core/rich_text/base_text.dart';

@immutable
class LinkText extends BaseText {
  final VoidCallback onTapped;
  const LinkText({
    required super.text,
    required this.onTapped,
    super.style,
  });
}
