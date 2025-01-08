import 'package:flutter/material.dart';
import 'package:frontend/src/dashboard/dashboard_controller.dart';
import 'package:frontend/src/dashboard/dashboard_view.dart';
import 'package:frontend/src/deposit/deposit_view.dart';
import 'package:frontend/src/deposit_details/deposit_details_controller.dart';
import 'package:frontend/src/deposit_details/deposit_details_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => DepositDetailsController()),
      ],
      child: MaterialApp( 
        debugShowCheckedModeBanner: false,
        home: DashboardView(),
      ),
    ),
  ); 
}
