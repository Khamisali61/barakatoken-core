import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barakatoken_mobile/core/theme/app_theme.dart';
import 'package:barakatoken_mobile/core/widgets/premium_widgets.dart';
import 'package:barakatoken_mobile/features/dashboard/data/user_provider.dart';
import 'package:barakatoken_mobile/features/dashboard/data/wallet_service.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baraka Wallet', style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildBalanceSwitcher(ref),
            const SizedBox(height: 32),
            _buildActionGrid(context, ref),
            const SizedBox(height: 32),
            _buildRecentTransactions(),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceSwitcher(WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView(
            children: [
              userAsync.when(
                data: (user) => _buildBalanceCard('KES Balance', 'KES ${user.kesBalance.toStringAsFixed(2)}', 'Kenyan Shilling'),
                loading: () => _buildBalanceCard('KES Balance', 'KES ...', 'Kenyan Shilling'),
                error: (_, __) => _buildBalanceCard('KES Balance', 'KES 0.00', 'Kenyan Shilling'),
              ),
              userAsync.when(
                data: (user) => _buildBalanceCard('USD Balance', 'USD ${user.usdBalance.toStringAsFixed(2)}', 'US Dollar'),
                loading: () => _buildBalanceCard('USD Balance', 'USD ...', 'US Dollar'),
                error: (_, __) => _buildBalanceCard('USD Balance', 'USD 0.00', 'US Dollar'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 24, height: 4, decoration: BoxDecoration(color: AppTheme.goldColor, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 4),
            Container(width: 8, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
          ],
        ),
      ],
    );
  }

  Widget _buildBalanceCard(String title, String amount, String currency) {
    return PremiumCard(
      hasGoldBorder: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text(amount, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppTheme.goldColor)),
          const SizedBox(height: 8),
          Text(currency, style: const TextStyle(fontSize: 12, color: Colors.white30, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildActionGrid(BuildContext context, WidgetRef ref) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 2.5,
      children: [
        _buildSmallAction(context, 'Deposit', Icons.add_circle_outline, () => _showTopupDialog(context, ref)),
        _buildSmallAction(context, 'Withdraw', Icons.outbox_outlined, () {}),
        _buildSmallAction(context, 'Exchange', Icons.swap_horiz, () {}),
        _buildSmallAction(context, 'Analytics', Icons.analytics_outlined, () {}),
      ],
    );
  }

  Widget _buildSmallAction(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  void _showTopupDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
            backgroundColor: AppTheme.backgroundColor,
            title: const Text('Mock M-Pesa Top-up', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Enter amount (KES)',
                hintStyle: TextStyle(color: Colors.white24),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.goldColor)),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Colors.white30)),
              ),
              ElevatedButton(
                onPressed: isLoading ? null : () async {
                  final amount = double.tryParse(controller.text);
                  if (amount != null && amount > 0) {
                    setState(() => isLoading = true);
                    final success = await ref.read(walletServiceProvider).topUp(amount);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(success ? 'Top-up successful!' : 'Top-up failed')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
                child: isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Confirm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Transaction History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('See All', style: TextStyle(color: AppTheme.goldColor, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        _buildTransactionItem('M-Pesa Deposit', 'May 24, 2023', '+ KES 50,000', Colors.green),
        _buildTransactionItem('One-Tap Investment', 'May 22, 2023', '- KES 5,000', Colors.white),
        _buildTransactionItem('Quarterly Yield', 'May 20, 2023', '+ KES 12,450', Colors.green),
      ],
    );
  }

  Widget _buildTransactionItem(String title, String date, String amount, Color amountColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.receipt_long_outlined, size: 20, color: Colors.white54),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(date, style: const TextStyle(color: Colors.white30, fontSize: 12)),
                ],
              ),
            ],
          ),
          Text(amount, style: TextStyle(fontWeight: FontWeight.w900, color: amountColor, fontSize: 15)),
        ],
      ),
    );
  }
}
