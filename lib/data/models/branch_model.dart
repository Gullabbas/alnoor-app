class BranchModel {
  final String id;
  final String name;
  final String address;
  final String city;
  final String uan;
  final String mobile;
  final String openHours;
  final double latitude;
  final double longitude;
  final bool isMainBranch;
  final List<String> services;

  const BranchModel({
    required this.id,
    required this.name,
    required this.address,
    this.city = 'Lahore',
    required this.uan,
    required this.mobile,
    required this.openHours,
    required this.latitude,
    required this.longitude,
    this.isMainBranch = false,
    required this.services,
  });

  bool get isOpenNow {
    // Al Noor hours: 9:00 AM to 12:00 Midnight
    final now = DateTime.now();
    final hour = now.hour;
    // Open from 9 AM to 24 (Midnight)
    return hour >= 9 && hour < 24;
  }
}
