import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Container(
        height: 48.0,
        padding: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 10.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Image.asset(
          'assets/images/gonbei.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
