enum MessageSender { user, agent, system }

enum MessageStatus { sending, sent, delivered, seen }

enum ChatTopic {
  booking('Booking & Sampling', 'Home sampling, slots, packages'),
  reports('Reports & Results', 'Turnaround time, report delivery, doctor remarks'),
  payments('Payments & Cards', 'Invoices, Health Card discounts, refunds'),
  homeSampling('Phlebotomist Tracking', 'Rider ETA, location, sample collection'),
  general('General Queries', 'Branch timings, consultations, corporate enlistment');

  final String title;
  final String description;
  const ChatTopic(this.title, this.description);
}

class SupportAgent {
  final String id;
  final String name;
  final String role;
  final String department;
  final String languages;
  final double rating;
  final bool isOnline;
  final String avatarInitials;

  const SupportAgent({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
    required this.languages,
    required this.rating,
    required this.isOnline,
    required this.avatarInitials,
  });
}

class ChatMessage {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final MessageStatus status;
  final String? cardType; // orderStatus, reportReady, paymentReceipt
  final Map<String, dynamic>? cardData;
  final List<String>? quickReplies;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.status = MessageStatus.seen,
    this.cardType,
    this.cardData,
    this.quickReplies,
  });
}
