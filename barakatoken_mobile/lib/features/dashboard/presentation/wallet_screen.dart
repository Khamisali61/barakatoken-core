import 'package:flutter/material.dart';
import 'package:barakatoken_mobile/core/theme/app_theme.dart';
import 'package:barakatoken_mobile/core/widgets/premium_widgets.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baraka Wallet', style: TextStyle(fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildBalanceSwitcher(),
            const SizedBox(height: 32),
            _buildActionGrid(),
            const SizedBox(height: 32),
            _buildRecentTransactions(),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceSwitcher() {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView(
            children: [
              _buildBalanceCard('KES Balance', 'KES 142,500.00', 'Kenyan Shilling'),
              _buildBalanceCard('USD Balance', 'USD 1,080.00', 'US Dollar'),
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

  Widget _buildActionGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 2.5,
      children: [
        _buildSmallAction('Deposit', Icons.add_circle_outline),
        _buildSmallAction('Withdraw', Icons.outbox_outlined),
        _buildSmallAction('Exchange', Icons.swap_horiz),
        _buildSmallAction('Analytics', Icons.analytics_outlined),
      ],
    );
  }

  Widget _buildSmallAction(String label, IconData icon) {
    return Container(
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
