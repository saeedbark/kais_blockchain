
import 'package:flutter/material.dart';
import 'package:frontend/constent/my_string.dart';
import 'package:frontend/src/deposit/deposit_view.dart';

class DespoiseDetailsView extends StatelessWidget {
  final bool isPushFromDashboard;
  const DespoiseDetailsView({super.key, this.isPushFromDashboard = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        title: Text('Deposit Details'),
        backgroundColor: AppColors.seconde,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16).copyWith(top: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 12),
                    const Text(
                      '5000 MRU',
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            if(!isPushFromDashboard)...[
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap:isPushFromDashboard ? null : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DepositView(),
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
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                                        margin: EdgeInsets.only(bottom: 16),

                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '1000 MRU',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Text('2025-01-08 09:43:24', style: TextStyle(
                            fontSize: 14,
                          ),),
                          ],
                        ),
                        SizedBox(height: 4),
                        const Text(
                          '0x179a282Ca6c4C8FBFF0e467C889896322AD6E1cad',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                                        margin: EdgeInsets.only(bottom: 16),

                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '2000 MRU',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Text('2025-01-07 11:43:24', style: TextStyle(
                            fontSize: 14,
                          ),),
                          ],
                        ),
                        SizedBox(height: 4),
                        const Text(
                          '0x179a282Ca6c4C8FBFF0e467C889896322AD6E1Ba',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '3000 MRU',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Text('2025-01-06 10:55:24', style: TextStyle(
                            fontSize: 14,
                          ),),
                          ],
                        ),
                        SizedBox(height: 4),
                        const Text(
                          '0x179a282Ca6c4C8FBFF0e467C889896322AD6Earb',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}