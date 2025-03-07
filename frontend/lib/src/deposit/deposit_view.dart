import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:frontend/constent/my_string.dart';
import 'package:frontend/src/deposit/deposit_controller.dart';
import 'package:provider/provider.dart';

class DepositView extends StatelessWidget {
  final String address;
  const DepositView({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DepositController(address: address),
      child: const _DepositBody(),
    );
  }
}

class _DepositBody extends StatelessWidget {
  const _DepositBody();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DepositController>();
    //final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Deposit',
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
      body: AnimationLimiter(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: AnimationConfiguration.staggeredList(
              position: 0,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 200),
                      _AnimatedAmountInput(controller: controller),
                      const SizedBox(height: 40),
                      _AnimatedPrivateKeyInput(controller: controller),
                      const SizedBox(height: 40),
                      _DepositButton(controller: controller),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedAmountInput extends StatelessWidget {
  final DepositController controller;

  const _AnimatedAmountInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 30.0,
        child: FadeInAnimation(
          child: TextFormField(
            controller: controller.amountController,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Amount',
              labelStyle: TextStyle(color: AppColors.textSecondary),
              floatingLabelStyle: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              filled: true,
              fillColor: Colors.cyanAccent.withOpacity(0.1),
              prefixIcon: Icon(
                Icons.price_change_outlined,
                color: AppColors.primary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              hintText: 'Enter amount to deposit',
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedPrivateKeyInput extends StatelessWidget {
  final DepositController controller;

  const _AnimatedPrivateKeyInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: 1,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 30.0,
        child: FadeInAnimation(
          child: TextFormField(
            controller: controller.privateKeyController,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Private Key',
              labelStyle: TextStyle(color: AppColors.textSecondary),
              floatingLabelStyle: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              filled: true,
              fillColor: Colors.cyanAccent.withOpacity(0.1),
              prefixIcon: Icon(
                Icons.currency_exchange_rounded,
                color: AppColors.primary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              hintText: 'Enter your private key',
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DepositButton extends StatelessWidget {
  final DepositController controller;

  const _DepositButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: 2,
      duration: const Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 30.0,
        child: FadeInAnimation(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => controller.deposit(context),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_rounded, color: Colors.white, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'DEPOSIT',
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
          ),
        ),
      ),
    );
  }
}
