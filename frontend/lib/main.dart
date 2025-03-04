import 'package:flutter/material.dart';
import 'package:frontend/shared_pref/shared_preferences.dart';
import 'package:frontend/src/dashboard/dashboard_controller.dart';
import 'package:frontend/src/dashboard/dashboard_view.dart';
import 'package:frontend/src/login/login_view.dart';
import 'package:frontend/src/otp/otp_view.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final token = await SharedPreferencesHelper.getString('token');
  final otp = await SharedPreferencesHelper.getString('code');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: token != null && otp != null ? DashboardView() : LoginView(),
      ),
    ),
  );
}
