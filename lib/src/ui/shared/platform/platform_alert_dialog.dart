import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../global/extensions.dart';
import 'platform_alert_dialog_action.dart';
import 'platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {
  final String title;
  final String content;
  final String defaultActionText;
  final String cancelActionText;
  final Widget optionalContent;

  PlatformAlertDialog({
    @required this.title,
    @required this.content,
    @required this.defaultActionText,
    this.cancelActionText,
    this.optionalContent,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this,
          )
        : await showDialog<bool>(
            context: context,
            builder: (context) => this,
          );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: optionalContent ?? Text(content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: optionalContent ?? Text(content),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      if (cancelActionText != null)
        PlatformAlertDialogAction(
          child: Text(
            cancelActionText,
            // style: TextStyle(
            //   color: context.accentColor,
            // ),
          ),
          onPressed: () => context.pop(false),
        ),
      PlatformAlertDialogAction(
        child: Text(
          defaultActionText,
          // style: TextStyle(
          //   color: context.accentColor,
          // ),
        ),
        onPressed: () => context.pop(true),
      )
    ];
  }
}
