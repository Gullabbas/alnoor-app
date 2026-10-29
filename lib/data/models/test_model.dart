class TestModel {
  final String id;
  final String name;
  final String category;
  final int price;
  final String sampleType;
  final bool fastingRequired;
  final int fastingHours;
  final String turnaroundTime;
  final String description;
  final String preparation;

  const TestModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.sampleType,
    required this.fastingRequired,
    this.fastingHours = 0,
    required this.turnaroundTime,
    required this.description,
    required this.preparation,
  });
}

class PackageModel {
  final String id;
  final String name;
  final String description;
  final int originalPrice;
  final int discountedPrice;
  final int discountPercent;
  final String targetGender; // All, Male, Female
  final bool fastingRequired;
  final List<String> includedTestIds;
  final List<String> highlights;

  const PackageModel({
    required this.id,
    required this.name,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercent,
    this.targetGender = 'All',
    this.fastingRequired = true,
    required this.includedTestIds,
    required this.highlights,
  });
}
