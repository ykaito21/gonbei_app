import 'package:flutter/material.dart';
import '../../global/style_list.dart';

class BaseButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;

  const BaseButton({
    Key key,
    @required this.buttonText,
    @required this.onPressed,
  })  : assert(buttonText != null),
        assert(onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        child: Text(
          buttonText,
          style: StyleList.baseSubtitleTextStyle,
        ),
      ),
      color: Theme.of(context).accentColor,
      textColor: Theme.of(context).primaryColor,
      disabledColor: Theme.of(context).accentColor.withOpacity(0.5),
      disabledTextColor: Theme.of(context).primaryColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
