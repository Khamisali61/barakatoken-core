class SukukAsset {
  final int id;
  final String title;
  final String description;
  final String location;
  final double totalValuation;
  final double totalTokens;
  final double availableTokens;
  final double minInvestment;
  final double expectedIrr;
  final String distributionCycle;
  final String riskLevel;
  final String? imageUrl;

  SukukAsset({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.totalValuation,
    required this.totalTokens,
    required this.availableTokens,
    required this.minInvestment,
    required this.expectedIrr,
    required this.distributionCycle,
    required this.riskLevel,
    this.imageUrl,
  });

  factory SukukAsset.fromJson(Map<String, dynamic> json) {
    return SukukAsset(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      totalValuation: double.parse(json['total_valuation'].toString()),
      totalTokens: double.parse(json['total_tokens'].toString()),
      availableTokens: double.parse(json['available_tokens'].toString()),
      minInvestment: double.parse(json['min_investment'].toString()),
      expectedIrr: double.parse(json['expected_irr'].toString()),
      distributionCycle: json['distribution_cycle'],
      riskLevel: json['risk_level'],
      imageUrl: json['image_url'],
    );
  }
}
