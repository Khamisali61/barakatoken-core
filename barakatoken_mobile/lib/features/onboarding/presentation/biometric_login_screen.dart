import 'package:flutter/material.dart';
import 'package:barakatoken_mobile/core/theme/app_theme.dart';
import 'package:barakatoken_mobile/core/widgets/premium_widgets.dart';

class BiometricLoginScreen extends StatelessWidget {
  const BiometricLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(Icons.shield_outlined, size: 80, color: AppTheme.goldColor),
              const SizedBox(height: 32),
              const Text('Secure Access', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              const Text(
                'Unlock your private banking suite using Biometrics for maximum security.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white30, fontSize: 16),
              ),
              const Spacer(),
              _buildKYCStatusTracker(),
              const SizedBox(height: 48),
              GoldButton(
                label: 'Authenticate with FaceID',
                icon: Icons.face_retouching_natural,
                onPressed: () {},
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {},
                child: const Text('Use PIN instead', style: TextStyle(color: Colors.white30, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKYCStatusTracker() {
    return PremiumCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: const [
              SizedBox(width: 44, height: 44, child: CircularProgressIndicator(value: 0.7, color: AppTheme.primaryColor, strokeWidth: 3)),
              Icon(Icons.person_search_outlined, size: 20, color: AppTheme.primaryColor),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('KYC Verification', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text('Document Review: 70% Complete', style: TextStyle(color: Colors.white30, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
