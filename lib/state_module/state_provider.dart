import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'count_app.dart';
import 'counter_logic.dart';
import 'theme_logic.dart';

Widget stateProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CounterLogic()),
      ChangeNotifierProvider(create: (context) => ThemeLogic()),
    ],
    child: CountApp(),
  );
}
