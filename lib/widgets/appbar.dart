import 'package:flutter/material.dart';
import 'package:remake_simple_app/widgets/colors.dart';

PreferredSizeWidget appBar() {
  return AppBar(
    automaticallyImplyLeading: false,
    elevation: 0,
    title: const Icon(
      Icons.menu,
      size: 27,
    ),
    actions: const [
      Padding(
        padding: EdgeInsets.only(right: 15),
        child: CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage('assets/RecipeLogo.jpg'),
        ),
      ),
    ],
    backgroundColor: AppTheme.mainColor, // Use mainColor from AppTheme
  );
}
