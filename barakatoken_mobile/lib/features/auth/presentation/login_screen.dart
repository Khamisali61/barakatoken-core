import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barakatoken_mobile/core/theme/app_theme.dart';
import 'package:barakatoken_mobile/core/widgets/premium_widgets.dart';
import 'package:barakatoken_mobile/features/auth/presentation/registration_screen.dart';
import 'package:barakatoken_mobile/features/dashboard/presentation/dashboard_screen.dart';
import 'package:barakatoken_mobile/features/auth/data/auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _showBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final authService = ref.read(authServiceProvider);
    final canUse = await authService.canUseBiometrics();
    final isEnabled = await authService.isBiometricsEnabled();
    if (mounted) {
      setState(() {
        _showBiometrics = canUse && isEnabled;
      });
    }
  }

  Future<void> _handleBiometricLogin() async {
    final authService = ref.read(authServiceProvider);
    final authenticated = await authService.authenticateWithBiometrics();
    if (authenticated && mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              const Center(child: Icon(Icons.shield_outlined, size: 80, color: AppTheme.goldColor)),
              const SizedBox(height: 48),
              const Text('Welcome Back', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text('Securely manage your Shariah investments.', style: TextStyle(color: Colors.white30)),
              const SizedBox(height: 48),
              _buildTextField('Email Address', _emailController, Icons.email_outlined),
              const SizedBox(height: 24),
              _buildTextField('Password', _passwordController, Icons.lock_outline, isPassword: true),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          onChanged: (val) => setState(() => _rememberMe = val!),
                          activeColor: AppTheme.primaryColor,
                          side: const BorderSide(color: Colors.white10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Remember Me', style: TextStyle(color: Colors.white30, fontSize: 13)),
                    ],
                  ),
                  const Text('Forgot Password?', style: TextStyle(color: AppTheme.goldColor, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 48),
              GoldButton(
                label: 'Sign In',
                onPressed: () {
                  // Simulate login and navigate to dashboard
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
                },
              ),
              if (_showBiometrics) ...[
                const SizedBox(height: 24),
                _buildBiometricShortcut(),
              ],
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?", style: TextStyle(color: Colors.white30)),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistrationScreen())),
                    child: const Text('Sign Up', style: TextStyle(color: AppTheme.goldColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white54)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: AppTheme.goldColor.withOpacity(0.5)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(vertical: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildBiometricShortcut() {
    return Center(
      child: Column(
        children: [
          const Text('OR', style: TextStyle(color: Colors.white10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          InkWell(
            onTap: _handleBiometricLogin,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.goldColor.withOpacity(0.2)),
              ),
              child: const Icon(Icons.face_retouching_natural, size: 32, color: AppTheme.goldColor),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Biometric Login', style: TextStyle(color: Colors.white30, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
