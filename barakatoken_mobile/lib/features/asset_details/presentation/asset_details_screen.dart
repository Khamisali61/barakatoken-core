import 'package:flutter/material.dart';
import 'package:barakatoken_mobile/core/theme/app_theme.dart';

class AssetDetailsScreen extends StatelessWidget {
  final String title;
  const AssetDetailsScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderInfo(),
                  const SizedBox(height: 30),
                  _buildInvestmentStats(),
                  const SizedBox(height: 30),
                  _buildAboutAsset(),
                  const SizedBox(height: 30),
                  _buildDocumentsSection(),
                  const SizedBox(height: 30),
                  _buildComplianceSeals(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomAction(context),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDRDRtd7I-eNIyDLFv8zIRYJi526Z5liZPFn26mMlhhwmZPR8Gdg9lS-vhFlhXclQq9568Cw7AYM21XRP8f0U8kpyQSg5g7Sa5t4eKdrlHfMUNtAR4Md9v-grpVtIgrVclRiP75l2H7tqsxvIAXbEZPA7pFUZy93dXD0Ouar8T1pe5HQhWsNs3wdx77MqUAE6K5URXA1RGLI8HPYIG_tMBJmF1uDL3E7arO-8BBIIa8q-D42Sf6LLkRnCh2oUMKxetdoa3s59lBxnw',
          fit: BoxFit.cover,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () {},
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.extrabold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppTheme.primaryColor, borderRadius: BorderRadius.circular(8)),
              child: const Text('12% p.a.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Icon(Icons.location_on, color: Colors.grey, size: 16),
            SizedBox(width: 4),
            Text('Nairobi, Kenya', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildInvestmentStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem('Valuation', 'KES 500M'),
        _buildStatItem('Min Invest', 'KES 5,000'),
        _buildStatItem('Term', '24 Months'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildAboutAsset() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('About this Sukuk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Text(
          'Sustainable affordable housing project in Nairobi\'s Westlands area. Phase 1 includes 200 units with solar power and rain water harvesting. This Musharakah-based Sukuk allows investors to share in the rental income and capital appreciation of the property.',
          style: TextStyle(color: Colors.grey, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildDocumentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Legal Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildDocItem('Offering Memorandum', 'PDF • 2.4 MB'),
        const SizedBox(height: 12),
        _buildDocItem('Shariah Certificate', 'PDF • 1.1 MB'),
      ],
    );
  }

  Widget _buildDocItem(String title, String size) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.glassCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          const Icon(Icons.description, color: Colors.redAccent),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(size, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.download, color: AppTheme.primaryColor),
        ],
      ),
    );
  }

  Widget _buildComplianceSeals() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSeal('CMA Sandbox', Icons.security),
        _buildSeal('Shariah Certified', Icons.verified),
        _buildSeal('Asset Backed', Icons.account_balance),
      ],
    );
  }

  Widget _buildSeal(String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor.withOpacity(0.5), size: 32),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppTheme.backgroundColor,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Total to Invest', style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text('KES 5,000.00', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
