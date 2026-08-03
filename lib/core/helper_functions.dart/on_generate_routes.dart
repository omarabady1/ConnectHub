import 'package:connect_hub/features/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
     case SplashView.routeName:
      return MaterialPageRoute(builder: (context) => const SplashView());
   default:
      return MaterialPageRoute(builder: (context) => Container());
  }
}
