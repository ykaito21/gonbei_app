import 'package:flutter/material.dart';

class StreamWrapper<T> extends StatelessWidget {
  final Stream<T> stream;
  final Function(BuildContext, T) onSuccess;
  final Function(BuildContext, dynamic) onError;
  final Function(BuildContext) onWaitting;
  final T initialData;
  const StreamWrapper({
    Key key,
    @required this.stream,
    @required this.onSuccess,
    this.onError,
    this.onWaitting,
    this.initialData,
  })  : assert(stream != null),
        assert(onSuccess != null),
        super(key: key);

  Function get _defaultOnError =>
      (BuildContext cotext, dynamic error) => Center(
            child: Text('Error: $error'),
          );

  Function get _defaultOnWaitting => (BuildContext cotext) => Center(
        child: CircularProgressIndicator(),
      );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      initialData: initialData,
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError)
          return onError != null
              ? onError(context, snapshot.error)
              : _defaultOnError(context, snapshot.error);
        if (!snapshot.hasData)
          return onWaitting != null
              ? onWaitting(context)
              : _defaultOnWaitting(context);
        return onSuccess(context, snapshot.data);
      },
    );
  }
}
