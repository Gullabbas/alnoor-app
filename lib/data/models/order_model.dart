enum OrderStatus {
  booked('Booked', 'Appointment confirmed in system'),
  phlebotomistAssigned('Phlebotomist Assigned', 'Rider assigned to your home sampling'),
  onTheWay('On the Way', 'Phlebotomist is en route with sampling kit'),
  sampleCollected('Sample Collected', 'Sample drawn and barcoded safely'),
  processing('Processing in Lab', 'High-accuracy automated analyzers at Shadman Lab'),
  reportReady('Report Ready', 'Signed and available in My Documents'),
  cancelled('Cancelled', 'Booking cancelled by patient');

  final String label;
  final String description;
  const OrderStatus(this.label, this.description);
}

class OrderItem {
  final String id;
  final String name;
  final int price;
  final bool isPackage;

  const OrderItem({
    required this.id,
    required this.name,
    required this.price,
    this.isPackage = false,
  });
}

class PhlebotomistRider {
  final String name;
  final String phone;
  final double rating;
  final String vehicle;
  final String photoUrl;
  final double latitude;
  final double longitude;

  const PhlebotomistRider({
    required this.name,
    required this.phone,
    required this.rating,
    required this.vehicle,
    required this.photoUrl,
    required this.latitude,
    required this.longitude,
  });
}

class OrderModel {
  final String id;
  final String bookingNumber;
  final String patientId;
  final String patientName;
  final String address;
  final DateTime scheduledDate;
  final String timeSlot;
  final List<OrderItem> items;
  final int subtotal;
  final int discount;
  final int total;
  final String paymentMethod; // Cash on Collection, Card, JazzCash, Easypaisa
  final OrderStatus status;
  final DateTime createdAt;
  final PhlebotomistRider? rider;
  final int etaMinutes;
  final String? cancellationReason;

  const OrderModel({
    required this.id,
    required this.bookingNumber,
    required this.patientId,
    required this.patientName,
    required this.address,
    required this.scheduledDate,
    required this.timeSlot,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.rider,
    this.etaMinutes = 18,
    this.cancellationReason,
  });

  OrderModel copyWith({
    OrderStatus? status,
    PhlebotomistRider? rider,
    int? etaMinutes,
    String? cancellationReason,
  }) {
    return OrderModel(
      id: id,
      bookingNumber: bookingNumber,
      patientId: patientId,
      patientName: patientName,
      address: address,
      scheduledDate: scheduledDate,
      timeSlot: timeSlot,
      items: items,
      subtotal: subtotal,
      discount: discount,
      total: total,
      paymentMethod: paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt,
      rider: rider ?? this.rider,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }
}
