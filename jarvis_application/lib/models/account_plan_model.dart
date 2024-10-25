class AccountPlanModel {
  final String name;
  final double price;
  final String description;
  final List<String> basicFeatures;
  final String queriesDescription;
  final List<String> advancedFeatures;
  final List<String> otherBenefits;

  AccountPlanModel({
    required this.name,
    required this.price,
    required this.description,
    required this.basicFeatures,
    required this.queriesDescription,
    required this.advancedFeatures,
    required this.otherBenefits,
  });
}
