import 'package:flutter/material.dart';
import 'package:frontend/constent/my_string.dart';
import 'package:frontend/src/deposit/deposit_view.dart';
import 'package:frontend/src/deposit_details/deposit_details_controller.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class DepositDetailsView extends StatelessWidget {
  final String? address;
  final bool isDesposit;
  final double amount;
  final double percentage;

  const DepositDetailsView({
    super.key,
    this.address,
    this.isDesposit = false,
    this.amount = 4000,
    this.percentage = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DepositDetailsController(address ?? ''),
      child: Scaffold(
        backgroundColor: AppColors.accent,
        appBar: AppBar(
          title: const Text('Deposit Details'),
          backgroundColor: AppColors.secondary,
          shadowColor: AppColors.primary,
          elevation: 2,
        ),
        body: _DepositDetailsViewBody(
          address: address,
          isDesposit: isDesposit,
          amount: amount,
          percentage: percentage,
        ),
      ),
    );
  }
}

class _DepositDetailsViewBody extends StatelessWidget {
  final String? address;
  final bool isDesposit;
  final double amount;
  final double percentage;

  const _DepositDetailsViewBody({
    this.address,
    this.isDesposit = false,
    this.amount = 4000,
    this.percentage = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DepositDetailsController>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
      child: Column(
        children: [
          // Circular Percent Indicator
          CircularPercentIndicator(
            radius: 40.0,
            lineWidth: 8.0,
            percent: percentage / 100,
            center: Text(
              "${percentage.toStringAsFixed(1)} %",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            progressColor: AppColors.primary,
            backgroundColor: Colors.grey[300]!,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 12),
              Text(
                '${amount.toStringAsFixed(2)} MRU',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          if (isDesposit) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DepositView(
                          address: address ?? '',
                        ),
                      ),
                    ),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.primary,
                      ),
                      child: const Center(
                        child: Text(
                          '+ DEPOSIT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          const Text( 
            'Transactions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          // Divider
          const Divider(height: 1, thickness: 2, color: Colors.grey),

          // Loading or Error State
          if (controller.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (controller.errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  controller.errorMessage ?? 'Error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          else
            // List of Transactions
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: controller.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = controller.transactions[index];

                  // Format the timestamp
                  final formattedDate =
                      DateFormat('yyyy-MM-dd').format(transaction.timestamp);
                  final formattedTime =
                      DateFormat('HH:mm:ss').format(transaction.timestamp);
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.account_balance_wallet),
                      title: Text(
                        'Amount: ${transaction.amount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tx Hash: ${transaction.txHash}'),
                          Text('Block Number: ${transaction.blockNumber}'),
                          Text(
                            'Date: $formattedDate $formattedTime',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
