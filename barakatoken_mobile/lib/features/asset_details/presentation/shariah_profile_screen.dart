import 'package:flutter/material.dart';
import 'package:barakatoken_mobile/core/theme/app_theme.dart';
import 'package:barakatoken_mobile/core/widgets/premium_widgets.dart';

class ShariahProfileScreen extends StatelessWidget {
  const ShariahProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shariah Profile',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCertificateScan(),
            const SizedBox(height: 32),
            const Text(
              'Fatwa Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFatwaContent(),
            const SizedBox(height: 32),
            _buildCommitteeSignatures(),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificateScan() {
    return PremiumCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://barakatoken.com/docs/nairobi-shariah-highres.jpg',
                ),
                fit: BoxFit.cover,
                opacity: 0.1, // Mocking high-fidelity scan
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.verified_user_outlined,
                size: 80,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Certificate #BT-2023-001',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.download,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  label: const Text(
                    'Download PDF',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFatwaContent() {
    return PremiumCard(
      child: const Text(
        'This Musharakah Sukuk has been reviewed and approved by the Global Shariah Advisory Board. The structure ensures no interest (Riba) is paid, and returns are strictly derived from physical asset yields and capital appreciation. The purification manager flags non-permissible income for charitable disbursement.',
        style: TextStyle(color: Colors.white70, height: 1.6, fontSize: 14),
      ),
    );
  }

  Widget _buildCommitteeSignatures() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSignature('Sheikh Abdallah', 'Chairman'),
        _buildSignature('Dr. Mohamed Ali', 'Shariah Expert'),
      ],
    );
  }

  Widget _buildSignature(String name, String role) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 60,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppTheme.goldColor.withOpacity(0.3)),
            ),
          ),
          child: Center(
            child: Text(
              name.split(' ').last,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.white30,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        Text(role, style: const TextStyle(color: Colors.white30, fontSize: 10)),
      ],
    );
  }
}
