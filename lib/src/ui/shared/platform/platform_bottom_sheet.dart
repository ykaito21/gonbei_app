import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../global/extensions.dart';
import '../../global/style_list.dart';
import 'platform_widget.dart';

class PlatformBottomSheet extends PlatformWidget {
  final String title;
  final List<String> actionTextList;
  final String cancelActionText;

  PlatformBottomSheet(
      {@required this.title,
      @required this.actionTextList,
      @required this.cancelActionText})
      : assert(title != null),
        assert(actionTextList != null),
        assert(cancelActionText != null);

  Future<String> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoModalPopup<String>(
            context: context,
            builder: (context) => this,
          )
        : await showModalBottomSheet<String>(
            useRootNavigator: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30.0),
              ),
            ),
            context: context,
            builder: (context) => this,
          );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        ...actionTextList.map(
          (text) {
            return CupertinoActionSheetAction(
              child: Text(text),
              onPressed: () => context.pop(text),
            );
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(cancelActionText),
        isDefaultAction: true,
        onPressed: () => context.pop(cancelActionText),
      ),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ...ListTile.divideTiles(
            context: context,
            tiles: [
              Container(
                width: double.infinity,
                padding: StyleList.verticalPadding15,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...actionTextList.map(
                (text) {
                  return ListTile(
                    onTap: () => context.pop(text),
                    title: Center(
                      child: Text(
                        text,
                        style: TextStyle(
                            // color: context.accentColor,
                            // fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                onTap: () => context.pop(cancelActionText),
                title: Center(
                  child: Text(
                    cancelActionText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
