import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MovieThemeLogic extends ChangeNotifier {
  bool _dark = false;
  bool get dark => _dark;

  final _key = "MovieThemeLogic";

  final _storage = FlutterSecureStorage();

  Future readTheme() async{
    String darkString = await _storage.read(key: _key) ?? "false";
    _dark = bool.tryParse(darkString) ?? false;
    notifyListeners();
  }

  void toggleDark(){
    _dark = !_dark;
    notifyListeners();
    _storage.write(key: _key, value:  _dark.toString());
  }
}