import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MovieGridstyleLogic extends ChangeNotifier {
  bool _gridStyle = true;
  bool get gridStyle => _gridStyle;

  final _key = "MovieGridstyleLogic";

  final _storage = FlutterSecureStorage();

  Future readStyle() async{
    String darkString = await _storage.read(key: _key) ?? "true";
    _gridStyle = bool.tryParse(darkString) ?? true;
    notifyListeners();
  }

  void toggleStyle(){
    _gridStyle = !_gridStyle;
    notifyListeners();
    _storage.write(key: _key, value:  _gridStyle.toString());
  }
}