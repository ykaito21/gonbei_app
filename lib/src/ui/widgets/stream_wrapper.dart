import 'package:flutter/material.dart';

class StreamWrapper<T> extends StatelessWidget {
  final Stream<T> stream;
  final Function onSuccess;
  final Function onError;
  final Function onWaitting;
  const StreamWrapper({
    Key key,
    @required this.stream,
    @required this.onSuccess,
    this.onError,
    this.onWaitting,
  })  : assert(stream != null),
        assert(onSuccess != null),
        super(key: key);

  Function get _defaultOnError => (cotext, error) => Center(
        child: Text('Error: $error'),
      );

  Function get _defaultOnWaitting => (cotext) => Center(
        child: CircularProgressIndicator(),
      );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, AsyncSnapshot<T> snapshot) {
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
