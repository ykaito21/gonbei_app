import 'package:flutter/material.dart';

enum ViewState { Idle, Busy, Retrieved, Error }

class BaseProvider extends ChangeNotifier {
  ViewState _viewState = ViewState.Idle;

  ViewState get viewState => _viewState;

  void setViewState(ViewState newViewState) {
    _viewState = newViewState;
    notifyListeners();
  }
}
