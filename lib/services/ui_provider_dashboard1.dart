import 'package:flutter/material.dart';

class UiProvider extends ChangeNotifier{


  // ignore: prefer_final_fields
  int _seleccionMenu = 0;

  int get seleccionMenu{
    return _seleccionMenu;

  }

  set seleccionMenu (int i){
    _seleccionMenu = i;
  notifyListeners();
  }



}