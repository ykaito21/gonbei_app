import 'package:flutter/material.dart';
import '../../global/style_list.dart';
import '../../global/extensions.dart';

class AuthButton extends StatelessWidget {
  final String buttonText;
  final Icon buttonIcon;
  final Function onPressed;

  const AuthButton({
    Key key,
    @required this.buttonText,
    @required this.buttonIcon,
    @required this.onPressed,
  })  : assert(buttonText != null),
        assert(buttonIcon != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Padding(
        padding: StyleList.allPadding10,
        child: Row(
          children: <Widget>[
            buttonIcon,
            Padding(
              padding: StyleList.leftPadding20,
              child: Text(
                buttonText,
                style: StyleList.smallBoldTextStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
      color: context.accentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        // side: BorderSide(
        //   color: context.accentColor,
        // ),
      ),
    );
  }
}
