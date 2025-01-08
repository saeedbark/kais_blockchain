import 'package:flutter/material.dart';
import 'package:frontend/src/dashboard/dashboard_service.dart';

class DashboardController  extends ChangeNotifier{
  DashboardController(){
    getAccounts();
  }


  List<dynamic> accounts = [];
  bool isLoading = false;

  Future<void> getAccounts()async{
   isLoading = true ;


    final response = await DashboardService().getAccounts();

    isLoading = false;
    
    notifyListeners();


    accounts = response['accounts'];

    
  }

}