class VitalReading {
  final String id;
  final String patientId;
  final String type; // Blood Pressure, Blood Glucose, BMI, Weight
  final double value;
  final double? secondaryValue; // Diastolic for BP
  final String unit;
  final DateTime recordedAt;
  final String status; // Normal, High, Low

  const VitalReading({
    required this.id,
    required this.patientId,
    required this.type,
    required this.value,
    this.secondaryValue,
    required this.unit,
    required this.recordedAt,
    required this.status,
  });

  String get displayValue {
    if (secondaryValue != null) {
      return '${value.toInt()}/${secondaryValue!.toInt()} $unit';
    }
    return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)} $unit';
  }
}
