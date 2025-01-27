import 'package:flutter/material.dart';
import 'package:frontend/network/app_exceptions.dart';
import 'package:frontend/src/deposit_details/deposit_details_model.dart';
import 'package:frontend/src/deposit_details/deposit_details_service.dart';

class DepositDetailsController extends ChangeNotifier {
  final String address;
  DepositDetailsController(this.address) {
    fetchTransactions(address);
  }

  final TextEditingController addressController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

// lib/controllers/deposit_details_controller.dart

  List<TransactionModel> transactions = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchTransactions(String address) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await DepositDetailsService().getTransactions(address);
      if (response['transactions'] != null) {
        final data = response['transactions'] as List<dynamic>;
        transactions =
            data.map((json) => TransactionModel.fromJson(json)).toList();
        print('object');
        return;
      }
    } catch (e) {
      if (e is AppException) {
        errorMessage = e.message;
      } else {
        errorMessage = 'An unexpected error occurred.';
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
