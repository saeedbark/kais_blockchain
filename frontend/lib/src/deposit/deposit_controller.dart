import 'package:flutter/material.dart';
import 'package:frontend/src/dashboard/dashboard_service.dart';
import 'package:frontend/src/deposit/deposit_service.dart';

class DepositController extends ChangeNotifier {
  final String address;
  DepositController({required this.address}) {
    getAccount();
  }
  final TextEditingController amountController = TextEditingController();
  final TextEditingController privateKeyController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String addressadmin = '';

  Future<void> getAccount() async {
    isLoading = true;

    final response = await DashboardService().getAccounts();

    isLoading = false;

    addressadmin = response['accounts_with_balances'].first['address'];

    notifyListeners();
  }

  Future<bool> deposit(BuildContext context) async {
    isLoading = true;
    notifyListeners(); // CORRECTED METHOD NAME

    try {
      await DepositService().deposit(
        sender: address,
        recipient: addressadmin,
        amount: double.tryParse(amountController.text) ?? 2,
        privateKey: privateKeyController.text,
      );

      isLoading = false;
      Navigator.pop(context, true); // Pass true indicating success
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deposit failed: ${e.toString()}')),
      );
      return false;
    }
  }
}
