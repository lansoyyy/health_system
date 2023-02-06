import 'package:flutter/material.dart';
import 'package:sumilao/widgets/text_widget.dart';

import '../utils/colors.dart';

PreferredSizeWidget customAppbar(String title) {
  return AppBar(
    title: TextRegular(text: title, fontSize: 18, color: Colors.white),
    centerTitle: true,
    foregroundColor: Colors.white,
    elevation: 0,
    backgroundColor: primary,
  );
}
