import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:frontend/constent/my_string.dart';
import 'package:frontend/src/deposit/deposit_view.dart';
import 'package:frontend/src/deposit_details/deposit_details_controller.dart';
import 'package:frontend/src/deposit_details/deposit_details_model.dart';
import 'package:intl/intl.dart';
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
          title: const Text('Deposit Details',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              )),
          backgroundColor: AppColors.primary,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _AnimatedHeader(
            percentage: percentage,
            amount: amount,
            isDeposit: isDesposit,
            address: address,
          ),
          Expanded(
            child: AnimationLimiter(
              child: controller.isLoading
                  ? const _LoadingIndicator()
                  : controller.errorMessage != null
                      ? _ErrorWidget(message: controller.errorMessage)
                      : _TransactionList(transactions: controller.transactions),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedHeader extends StatelessWidget {
  final double percentage;
  final double amount;
  final bool isDeposit;
  final String? address;

  const _AnimatedHeader({
    required this.percentage,
    required this.amount,
    required this.isDeposit,
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // TweenAnimationBuilder(
        //   tween: Tween<double>(begin: 0, end: percentage / 100),
        //   duration: const Duration(seconds: 1),
        //   builder: (context, value, _) {
        //     return CircularPercentIndicator(
        //       radius: 70,
        //       lineWidth: 12,
        //       percent: value,
        //       animation: true,
        //       animateFromLastPercent: true,
        //       center: Text(
        //         "${percentage.toStringAsFixed(1)}%",
        //         style: const TextStyle(
        //           fontSize: 20,
        //           fontWeight: FontWeight.bold,
        //           color: AppColors.primary,
        //         ),
        //       ),
        //       progressColor: AppColors.primary,
        //       backgroundColor: AppColors.accent.withOpacity(0.2),
        //       circularStrokeCap: CircularStrokeCap.round,
        //     );
        //   },
        // ),
        const SizedBox(height: 20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Text(
            '${amount.toStringAsFixed(2)} MRU',
            key: ValueKey<double>(amount),
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              shadows: [
                Shadow(
                  color: AppColors.textSecondary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
        ),
        if (isDeposit) ...[
          const SizedBox(height: 30),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                        DepositView(address: address ?? ''),
                    transitionsBuilder: (_, a, __, c) =>
                        FadeTransition(opacity: a, child: c),
                  ),
                );

                if (result == true) {
                  final controller = Provider.of<DepositDetailsController>(
                      context,
                      listen: false);
                  await controller.fetchTransactions(address ?? '');
                }
              },
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_rounded, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Text(
                      'New Deposit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 30),
        FadeTransition(
          opacity: AlwaysStoppedAnimation(
              Provider.of<DepositDetailsController>(context).isLoading ? 0 : 1),
          child: Text(
            'Transaction History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}

class _TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;

  const _TransactionList({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _TransactionCard(transaction: transaction),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('MMM dd, yyyy').format(transaction.timestamp);
    final formattedTime = DateFormat('hh:mm a').format(transaction.timestamp);
    final isTampered = transaction.isTampered;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: isTampered ? AppColors.error.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border:
            isTampered ? Border.all(color: AppColors.error, width: 1.5) : null,
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isTampered ? AppColors.error : AppColors.accent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isTampered ? Icons.warning_rounded : Icons.account_balance_wallet,
            color: isTampered ? Colors.white : AppColors.primary,
            size: 24,
          ),
        ),
        title: Text(
          '${transaction.amount.toStringAsFixed(2)} MRU',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isTampered ? AppColors.error : AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Block #${transaction.blockNumber} • $formattedDate',
              style: TextStyle(
                fontSize: 12,
                //color: c,
              ),
            ),
            Text(
              transaction.txHash,
              style: TextStyle(
                fontSize: 11,
                // color: AppColors.textSecondary.withOpacity(0.7),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: Text(
          formattedTime,
          style: TextStyle(
            fontSize: 12,
            // color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading Transactions...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final String? message;

  const _ErrorWidget({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded,
              color: AppColors.error.withOpacity(0.8), size: 40),
          const SizedBox(height: 16),
          Text(
            message ?? 'Failed to load transactions',
            style: TextStyle(
              color: AppColors.error.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
