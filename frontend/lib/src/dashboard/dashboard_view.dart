import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:frontend/constent/my_string.dart';
import 'package:frontend/shared_pref/shared_preferences.dart';
import 'package:frontend/src/dashboard/dashboard_controller.dart';
import 'package:frontend/src/deposit_details/deposit_details_view.dart';
import 'package:frontend/src/login/login_view.dart';
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
        title: const Text('Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            )),
        actions: [
          _AnimatedDepositButton(controller: controller),
        ],
        backgroundColor: AppColors.primary,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      drawer: _buildDrawer(context, controller),
      body: controller.isLoading
          ? const _LoadingIndicator()
          : const _DashboardDetailsView(),
    );
  }

  Widget _buildDrawer(BuildContext context, DashboardController controller) {
    final account =
        controller.accounts.isNotEmpty ? controller.accounts[0] : null;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(account?['name'] ?? 'Guest User',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            accountEmail: Text(account?['address'] ?? 'user@example.com',
                style: const TextStyle(fontSize: 14)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: account?['image'] ?? '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Icon(Icons.person),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.9),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: AppColors.primary),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              // Add navigation to profile screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: AppColors.primary),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Add navigation to settings screen
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              _handleLogout(context);
            },
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    // Implement your logout logic here
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await SharedPreferencesHelper.remove('token');
              await SharedPreferencesHelper.remove('code');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginView()),
              );
            },
            child:
                const Text('Logout', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _AnimatedDepositButton extends StatelessWidget {
  final DashboardController controller;

  const _AnimatedDepositButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () => _navigateToDeposit(context),
        style: TextButton.styleFrom(
          backgroundColor: AppColors.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: const Text(
          'Deposit',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _navigateToDeposit(BuildContext context) async {
    final address = await SharedPreferencesHelper.getString('address');
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => DepositDetailsView(
          address: address,
          isDesposit: true,
          amount: double.tryParse(controller.accounts[0]['balance']) ?? 0.0,
        ),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
      ),
    );
  }
}

class _DashboardDetailsView extends StatelessWidget {
  const _DashboardDetailsView();

  @override
  Widget build(BuildContext context) {
    final accountData = _generateAccountData(context);

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 20, bottom: 40),
        itemCount: accountData.length,
        itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            horizontalOffset: 50.0,
            child: FadeInAnimation(
              child: AccountCard(data: accountData[index]),
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _generateAccountData(BuildContext context) {
    final accounts = context.watch<DashboardController>().accounts;
    List<String> names = [
      "Caisse",
      "Chimchawi Ahmed",
      "Saeed",
      "Fatima  Abdullah",
      "Ali saeed",
      "moustapha  ",
      "Kareem Amir",
      "Aisha Hassan",
      "Hassan"
    ];
    List<String> images = [
      "https://c0.klipartz.com/pngpicture/103/822/gratis-png-paquete-de-u-s-ilustracion-de-billetes-en-dolares-bolsa-de-dinero-moneda-prestamo-de-moneda-monedero-en-efectivo-thumbnail.png",
      "https://st.depositphotos.com/1743476/2514/i/950/depositphotos_25144755-stock-photo-presenting-your-text.jpg",
      "https://st3.depositphotos.com/12985790/17521/i/1600/depositphotos_175218564-stock-photo-smiling-handsome-man-holding-cup.jpg",
      "https://st5.depositphotos.com/1049680/64158/i/1600/depositphotos_641589546-stock-photo-hispanic-man-standing-blue-background.jpg",
      "https://st4.depositphotos.com/13193658/30158/i/1600/depositphotos_301586860-stock-photo-handsome-businessman-formal-wear-smiling.jpg",
      "https://st3.depositphotos.com/12985790/16264/i/1600/depositphotos_162644654-stock-photo-happy-african-american-man.jpg",
      "https://st5.depositphotos.com/88369228/74460/i/1600/depositphotos_744609920-stock-photo-high-resolution-ultrarealistic-image-photograph.jpg",
      "https://st5.depositphotos.com/62628780/73296/i/1600/depositphotos_732968602-stock-photo-happy-man-portrait-outdoor-relax.jpg",
      "https://st.depositphotos.com/1269204/1219/i/950/depositphotos_12196477-stock-photo-smiling-men-isolated-on-the.jpg"
    ];

    return List.generate(
      names.length,
      (index) => {
        "name": names[index],
        "account": accounts[index]['address'],
        "amount": accounts[index]['balance'],
        "image": images[index],
        "usage_percentage": accounts[index]['usage_percentage'],
      },
    );
  }
}

class AccountCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const AccountCard({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _navigateToDetails(context),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          onTap: () => _navigateToDetails(context),
          child: Card(
            elevation: 0,
            color: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _UserAvatar(imageUrl: data['image']),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _AccountInfoRow(
                          label: 'Address:',
                          value: data['account'],
                        ),
                        const SizedBox(height: 4),
                        _AccountInfoRow(
                          label: 'Balance:',
                          value:
                              '${double.tryParse(data['amount'])?.toStringAsFixed(2) ?? 0.0} MRU',
                        ),
                      ],
                    ),
                  ),
                  // _UsagePercentageIndicator(
                  //   percentage: double.tryParse(data['usage_percentage']) ?? 0.0,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => DepositDetailsView(
          address: data['account'],
          amount: double.tryParse(data['amount']) ?? 0.0,
          percentage: double.tryParse(data['usage_percentage']) ?? 0.0,
        ),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final String imageUrl;

  const _UserAvatar({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppColors.accent.withOpacity(0.1),
            child: const Icon(Icons.person, color: AppColors.primary, size: 30),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppColors.error.withOpacity(0.1),
            child: const Icon(Icons.error_outline, color: AppColors.error),
          ),
        ),
      ),
    );
  }
}

class _AccountInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _AccountInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _UsagePercentageIndicator extends StatelessWidget {
  final double percentage;

  const _UsagePercentageIndicator({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 24,
      lineWidth: 3,
      percent: percentage / 100,
      center: Text(
        '${percentage.toStringAsFixed(0)}%',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
      progressColor: AppColors.primary,
      backgroundColor: AppColors.accent.withOpacity(0.2),
      circularStrokeCap: CircularStrokeCap.round,
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
            'Loading Accounts...',
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
