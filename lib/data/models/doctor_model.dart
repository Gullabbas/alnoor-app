class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String qualifications;
  final int experienceYears;
  final double rating;
  final int reviewsCount;
  final int fee;
  final String availability;
  final String hospitalAffiliation;
  final String about;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.qualifications,
    required this.experienceYears,
    required this.rating,
    required this.reviewsCount,
    required this.fee,
    required this.availability,
    this.hospitalAffiliation = 'Al Noor Diagnostic Centre',
    required this.about,
  });
}

class ConsultationBooking {
  final String id;
  final String doctorId;
  final String doctorName;
  final String specialty;
  final String patientName;
  final DateTime dateTime;
  final String type; // Video, Audio, Chat
  final int fee;
  final String status; // Scheduled, In-Progress, Completed, Cancelled
  final String? prescriptionNotes;

  const ConsultationBooking({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.patientName,
    required this.dateTime,
    required this.type,
    required this.fee,
    this.status = 'Scheduled',
    this.prescriptionNotes,
  });
}
