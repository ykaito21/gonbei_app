import 'package:flutter/material.dart';
import '../../global/extensions.dart';

class BaseFlatButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  const BaseFlatButton({
    Key key,
    @required this.buttonText,
    @required this.onPressed,
  })  : assert(buttonText != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        buttonText,
        style: TextStyle(
          color: context.accentColor,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
