import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'platform_alert_dialog_action.dart';
import 'platform_widget.dart';

class PlatformComplexAlertDialog extends PlatformWidget {
  final String title;
  final Widget content;
  final Widget defaultActionWidget;
  final Function defaultActionOnPressed;
  final Widget cancelActionWidget;
  final Function cancelActionOnPressed;

  PlatformComplexAlertDialog({
    @required this.title,
    @required this.content,
    @required this.defaultActionWidget,
    @required this.defaultActionOnPressed,
    this.cancelActionWidget,
    this.cancelActionOnPressed,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionWidget != null),
        assert(defaultActionOnPressed != null);

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
      content: content,
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
      ),
      content: content,
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      if (cancelActionWidget != null)
        PlatformAlertDialogAction(
          child: cancelActionWidget,
          onPressed: cancelActionOnPressed,
        ),
      PlatformAlertDialogAction(
        child: defaultActionWidget,
        onPressed: defaultActionOnPressed,
      ),
    ];
  }
}
