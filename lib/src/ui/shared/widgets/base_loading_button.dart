import 'package:flutter/material.dart';
import '../../global/style_list.dart';
import '../../global/extensions.dart';

class BaseLoadingButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final bool isLoading;

  const BaseLoadingButton({
    Key key,
    @required this.buttonText,
    @required this.onPressed,
    this.isLoading = false,
  })  : assert(buttonText != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: isLoading ? null : onPressed,
      child: Padding(
        padding: StyleList.allPadding10,
        child: isLoading
            ? SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(),
              )
            : Text(
                buttonText,
                style: StyleList.baseSubtitleTextStyle,
              ),
      ),
      color: context.accentColor,
      textColor: context.primaryColor,
      disabledColor: context.accentColor.withOpacity(0.5),
      disabledTextColor: context.primaryColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        // side: BorderSide(
        //   color: context.accentColor,
        // ),
      ),
    );
  }
}
