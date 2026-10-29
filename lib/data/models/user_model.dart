class FamilyProfile {
  final String id;
  final String fullName;
  final String relation; // Self, Mother, Father, Spouse, Son, Daughter
  final int age;
  final String gender;
  final String patientId;
  final String bloodGroup;

  const FamilyProfile({
    required this.id,
    required this.fullName,
    required this.relation,
    required this.age,
    required this.gender,
    required this.patientId,
    this.bloodGroup = 'O+',
  });

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'relation': relation,
        'age': age,
        'gender': gender,
        'patientId': patientId,
        'bloodGroup': bloodGroup,
      };

  factory FamilyProfile.fromJson(Map<String, dynamic> json) => FamilyProfile(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        relation: json['relation'] as String,
        age: json['age'] as int,
        gender: json['gender'] as String,
        patientId: json['patientId'] as String,
        bloodGroup: json['bloodGroup'] as String? ?? 'O+',
      );
}

class UserModel {
  final String id;
  final String phone;
  final String fullName;
  final String? email;
  final String? cnic;
  final String gender;
  final int age;
  final String pin;
  final bool biometricEnabled;
  final String defaultProfileId;
  final List<FamilyProfile> familyProfiles;
  final String healthCardNumber;
  final String healthCardTier; // Blue, Silver, Gold
  final int healthPoints;

  const UserModel({
    required this.id,
    required this.phone,
    required this.fullName,
    this.email,
    this.cnic,
    required this.gender,
    required this.age,
    required this.pin,
    this.biometricEnabled = false,
    required this.defaultProfileId,
    required this.familyProfiles,
    required this.healthCardNumber,
    required this.healthCardTier,
    this.healthPoints = 1250,
  });

  FamilyProfile get defaultProfile {
    return familyProfiles.firstWhere(
      (p) => p.id == defaultProfileId,
      orElse: () => familyProfiles.first,
    );
  }

  UserModel copyWith({
    String? fullName,
    String? email,
    String? cnic,
    String? pin,
    bool? biometricEnabled,
    String? defaultProfileId,
    List<FamilyProfile>? familyProfiles,
    int? healthPoints,
  }) {
    return UserModel(
      id: id,
      phone: phone,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      cnic: cnic ?? this.cnic,
      gender: gender,
      age: age,
      pin: pin ?? this.pin,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      defaultProfileId: defaultProfileId ?? this.defaultProfileId,
      familyProfiles: familyProfiles ?? this.familyProfiles,
      healthCardNumber: healthCardNumber,
      healthCardTier: healthCardTier,
      healthPoints: healthPoints ?? this.healthPoints,
    );
  }
}
