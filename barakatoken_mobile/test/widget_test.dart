import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barakatoken_mobile/main.dart';
import 'package:barakatoken_mobile/features/dashboard/presentation/dashboard_screen.dart';
import 'package:barakatoken_mobile/features/marketplace/data/asset_provider.dart';
import 'package:barakatoken_mobile/features/marketplace/domain/asset_model.dart';

void main() {
  testWidgets('Dashboard loads test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          assetsProvider.overrideWith(
            (ref) => [
              SukukAsset(
                id: 1,
                title: 'Test Asset',
                description: 'Description',
                location: 'Location',
                totalValuation: 1000,
                totalTokens: 100,
                availableTokens: 50,
                minInvestment: 10,
                expectedIrr: 0.12,
                distributionCycle: 'Monthly',
                riskLevel: 'Low',
              ),
            ],
          ),
        ],
        child: const BarakaTokenApp(),
      ),
    );

    // Verify that the dashboard is displayed.
    expect(find.byType(DashboardScreen), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);

    // Allow any pending timers to complete or just pump
    await tester.pump();
  });
}
