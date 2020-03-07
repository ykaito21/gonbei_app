import 'package:flutter/material.dart';

enum ViewState { Idle, Busy, Retrieved, Error }

class BaseProvider extends ChangeNotifier {
  ViewState _viewState = ViewState.Idle;

  ViewState get viewState => _viewState;
  bool get isBusy => _viewState == ViewState.Busy;
  bool get isError => _viewState == ViewState.Error;
  bool get isRetrieved => _viewState == ViewState.Retrieved;

  void setViewState(ViewState newViewState) {
    _viewState = newViewState;
    notifyListeners();
  }
}
