import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barakatoken_mobile/core/theme/app_theme.dart';
import 'package:barakatoken_mobile/core/widgets/premium_widgets.dart';
import 'package:barakatoken_mobile/features/auth/data/auth_service.dart';
import 'package:barakatoken_mobile/features/auth/data/auth_provider.dart';
import 'package:barakatoken_mobile/features/auth/presentation/login_screen.dart';

class SecuritySettingsScreen extends ConsumerStatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  ConsumerState<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends ConsumerState<SecuritySettingsScreen> {
  bool _biometricsEnabled = false;
  bool _canUseBiometrics = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final authService = ref.read(authServiceProvider);
    final canUse = await authService.canUseBiometrics();
    final isEnabled = await authService.isBiometricsEnabled();
    setState(() {
      _canUseBiometrics = canUse;
      _biometricsEnabled = isEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Settings', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Biometrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.goldColor)),
            const SizedBox(height: 16),
            PremiumCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Enable Biometric Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(
                        _canUseBiometrics ? 'Use FaceID/Fingerprint for quick access' : 'Not supported on this device',
                        style: const TextStyle(color: Colors.white30, fontSize: 12),
                      ),
                    ],
                  ),
                  Switch(
                    value: _biometricsEnabled,
                    onChanged: _canUseBiometrics ? (val) async {
                      final authService = ref.read(authServiceProvider);
                      if (val) {
                        // Request authentication before enabling
                        final authenticated = await authService.authenticateWithBiometrics();
                        if (authenticated) {
                          await authService.setBiometricsEnabled(true);
                          setState(() => _biometricsEnabled = true);
                        }
                      } else {
                        await authService.setBiometricsEnabled(false);
                        setState(() => _biometricsEnabled = false);
                      }
                    } : null,
                    activeColor: AppTheme.primaryColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Security Options', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.goldColor)),
            const SizedBox(height: 16),
            _buildSecurityOption('Change PIN', Icons.pin_outlined),
            const SizedBox(height: 12),
            _buildSecurityOption('Two-Factor Authentication', Icons.security_outlined, subtitle: 'Off'),
            const SizedBox(height: 12),
            _buildSecurityOption('Active Sessions', Icons.devices_outlined),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text('Log Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.redAccent.withOpacity(0.3)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityOption(String title, IconData icon, {String? subtitle}) {
    return PremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.white54),
              const SizedBox(width: 16),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          Row(
            children: [
              if (subtitle != null) ...[
                Text(subtitle, style: const TextStyle(color: Colors.white30, fontSize: 12)),
                const SizedBox(width: 8),
              ],
              const Icon(Icons.chevron_right, size: 16, color: Colors.white24),
            ],
          ),
        ],
      ),
    );
  }
}
