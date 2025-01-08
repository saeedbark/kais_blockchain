import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/constent/my_string.dart';
import 'package:frontend/src/dashboard/dashboard_controller.dart';
import 'package:frontend/src/deposit/deposit_view.dart';
import 'package:frontend/src/deposit_details/deposit_details_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();
    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        title: const Text('Dashboard'),
        
        backgroundColor: AppColors.seconde,
       // shadowColor: ,
        centerTitle: true,
      ),
      body: controller.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
            margin: const EdgeInsets.only(top: 20),
            child: const _DashboardDetailsView()),
    );
  }
}

/// Widget displaying a list of accounts with details
class _DashboardDetailsView extends StatelessWidget {
  const _DashboardDetailsView();

  static const List<String> names = [
    "Saeed bark",
    "Ahmed salem",
    "John Doe",
    "Mary Smith",
    "Fatima  Abdullah",
    "Ali saeed",
    "Sara Ali",
    "Kareem Amir",
    "Aisha Hassan",
    "Hassan"
  ];

  List<Map<String, dynamic>> _generateAccountData(BuildContext context) {
    final accounts = context.watch<DashboardController>().accounts;

    return List.generate(
      names.length,
      (index) {
        final amount = Random().nextDouble() * 5000;
        return {
          "name": names[index],
          "account": accounts[index],
          "amount": amount,
          "percentage": amount / 5000,
        };
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountData = _generateAccountData(context);

    return ListView.builder(
      itemCount: accountData.length,
      itemBuilder: (context, index) => AccountCard(data: accountData[index]),
    );
  }
}

/// Widget displaying account details with a circular progress indicator
class AccountCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const AccountCard({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DespoiseDetailsView(isPushFromDashboard: true,),
        ),
      ),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircularPercentIndicator(
                radius: 50.0,
                lineWidth: 8.0,
                percent: data['percentage'],
                center: Text(
                  "${(data['percentage'] * 100).toStringAsFixed(1)}%",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                progressColor: AppColors.primary,
                backgroundColor: Colors.grey[300]!,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${data['name']}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Address: ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          TextSpan(
                            text: data['account'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Amount: ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          TextSpan(
                            text: '${data['amount'].toStringAsFixed(2)} MRU',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
