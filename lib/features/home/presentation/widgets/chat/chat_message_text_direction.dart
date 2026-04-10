import 'package:flutter/material.dart';

TextDirection resolveChatMessageTextDirection(String text) {
  final hasArabicContent = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  return hasArabicContent ? TextDirection.rtl : TextDirection.ltr;
}
