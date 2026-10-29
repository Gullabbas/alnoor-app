import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../demo/seed_data.dart';
import '../models/chat_model.dart';

class ChatSessionState {
  final SupportAgent? assignedAgent;
  final ChatTopic? topic;
  final List<ChatMessage> messages;
  final bool isConnecting;
  final bool isAgentTyping;
  final bool isEnded;
  final int? rating;

  const ChatSessionState({
    this.assignedAgent,
    this.topic,
    this.messages = const [],
    this.isConnecting = false,
    this.isAgentTyping = false,
    this.isEnded = false,
    this.rating,
  });

  ChatSessionState copyWith({
    SupportAgent? assignedAgent,
    ChatTopic? topic,
    List<ChatMessage>? messages,
    bool? isConnecting,
    bool? isAgentTyping,
    bool? isEnded,
    int? rating,
  }) {
    return ChatSessionState(
      assignedAgent: assignedAgent ?? this.assignedAgent,
      topic: topic ?? this.topic,
      messages: messages ?? this.messages,
      isConnecting: isConnecting ?? this.isConnecting,
      isAgentTyping: isAgentTyping ?? this.isAgentTyping,
      isEnded: isEnded ?? this.isEnded,
      rating: rating ?? this.rating,
    );
  }
}

class ChatNotifier extends Notifier<ChatSessionState> {
  @override
  ChatSessionState build() {
    return const ChatSessionState();
  }

  Future<void> startSession(ChatTopic topic) async {
    state = ChatSessionState(
      topic: topic,
      isConnecting: true,
      messages: [],
    );

    // Pick agent based on topic
    SupportAgent agent;
    switch (topic) {
      case ChatTopic.booking:
        agent = SeedData.supportAgents[0]; // Sana
        break;
      case ChatTopic.reports:
        agent = SeedData.supportAgents[1]; // Bilal
        break;
      case ChatTopic.payments:
        agent = SeedData.supportAgents[2]; // Hira
        break;
      case ChatTopic.homeSampling:
        agent = SeedData.supportAgents[4]; // Zain
        break;
      case ChatTopic.general:
        agent = SeedData.supportAgents[3]; // Dr. Kamran
        break;
    }

    // Connecting delay 1.5 seconds
    await Future.delayed(const Duration(milliseconds: 1500));

    final welcomeMsg = ChatMessage(
      id: 'msg_welcome',
      text: 'Hello! I am ${agent.name} from ${agent.department} at Al Noor Diagnostic Centre. How can I assist you with your ${topic.title.toLowerCase()} today?',
      sender: MessageSender.agent,
      timestamp: DateTime.now(),
      quickReplies: _getTopicQuickReplies(topic),
    );

    state = state.copyWith(
      assignedAgent: agent,
      isConnecting: false,
      messages: [welcomeMsg],
    );
  }

  List<String> _getTopicQuickReplies(ChatTopic topic) {
    switch (topic) {
      case ChatTopic.booking:
        return ['Book Home Sampling', 'Health Package Discounts', 'Available Time Slots'];
      case ChatTopic.reports:
        return ['When will report be ready?', 'Explain my results', 'Download PDF Report'];
      case ChatTopic.payments:
        return ['Apply Health Card Discount', 'Payment Methods', 'Get Invoice Copy'];
      case ChatTopic.homeSampling:
        return ['Where is my rider?', 'Phlebotomist Contact', 'Reschedule Slot'];
      case ChatTopic.general:
        return ['Shadman Branch Timings', 'Doctor Consultation Fees', 'MRI Scan Prep'];
    }
  }

  Future<void> sendMessage(String text) async {
    final userMsg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isAgentTyping: true,
    );

    // Human feel delay: 1.5 - 2.5s
    await Future.delayed(const Duration(milliseconds: 1800));

    final replyText = _generateSmartReply(text, state.topic);
    final agentMsg = ChatMessage(
      id: 'msg_reply_${DateTime.now().millisecondsSinceEpoch}',
      text: replyText,
      sender: MessageSender.agent,
      timestamp: DateTime.now(),
      status: MessageStatus.delivered,
      quickReplies: ['Thank you!', 'Can you share details?', 'Talk to Doctor'],
    );

    state = state.copyWith(
      messages: [...state.messages, agentMsg],
      isAgentTyping: false,
    );
  }

  String _generateSmartReply(String query, ChatTopic? topic) {
    final q = query.toLowerCase();
    if (q.contains('rider') || q.contains('phlebotomist') || q.contains('where')) {
      return 'Your assigned phlebotomist Tariq Mehmood is currently en route with sterile cold-chain sampling kits. Current ETA is approximately 14 minutes. You can also track him live on the My Orders map.';
    } else if (q.contains('timing') || q.contains('time') || q.contains('open') || q.contains('hours')) {
      return 'Our Main Shadman Centre (Opp. Fatima Memorial Hospital) is open Monday to Sunday from 9:00 AM to 12:00 Midnight. Home sampling dispatches begin daily at 6:30 AM.';
    } else if (q.contains('report') || q.contains('ready') || q.contains('pdf')) {
      return 'Most routine pathology reports (CBC, LFT, RFT, Urine) are finalized within 4–6 hours. You can view, verify consultant digital signatures, and download verified PDFs anytime under the "My Documents" tab.';
    } else if (q.contains('discount') || q.contains('card') || q.contains('coupon')) {
      return 'You can use promo code NOOR10 for an instant 10% discount, or attach your Al Noor Health Card at checkout for up to 35% savings across laboratory and radiology diagnostics!';
    } else if (q.contains('fasting') || q.contains('prep')) {
      return 'For Lipid Profiles and Fasting Blood Sugar, 10–12 hours overnight fasting is required. Plain drinking water is allowed and recommended to keep veins well hydrated.';
    } else {
      return 'Certainly! Let me check the details in our Shadman Central IT system for you. Everything is in order and our team is actively at your service. Is there anything else you need assistance with?';
    }
  }

  void endChat(int rating, String? comment) {
    state = state.copyWith(
      isEnded: true,
      rating: rating,
    );
  }
}

final chatProvider = NotifierProvider<ChatNotifier, ChatSessionState>(() => ChatNotifier());
