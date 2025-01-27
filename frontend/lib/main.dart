import 'package:flutter/material.dart';
import 'package:frontend/src/dashboard/dashboard_controller.dart';
import 'package:frontend/src/dashboard/dashboard_view.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DashboardView(),
        // DespoiseDetailsView
      ),
    ),
  );
}
