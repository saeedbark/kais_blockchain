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

        // Parse all transactions
        final allTransactions =
            data.map((json) => TransactionModel.fromJson(json)).toList();

        // Remove duplicates - keep earliest transaction per unique identifier
        final uniqueTransactions = <String, TransactionModel>{};
        for (final transaction in allTransactions) {
          final key =
              '${transaction.amount}-${transaction.timestamp}'; // Adjust key as needed
          final existing = uniqueTransactions[key];

          if (existing == null ||
              transaction.timestamp.isBefore(existing.timestamp)) {
            uniqueTransactions[key] = transaction;
          }
        }

        transactions = uniqueTransactions.values.toList();
        return;
      }
    } catch (e) {
      errorMessage =
          e is AppException ? e.message : 'An unexpected error occurred.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
