import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'role': 'ai',
      'text': 'Hello! I am your Al Noor AI Health Companion. I can help explain diagnostic tests, preparation rules, and guide you across our 1500+ tests.',
    },
  ];
  bool _isTyping = false;

  final List<String> _suggestedPrompts = [
    'Which test is best for extreme fatigue?',
    'How do I prepare for a fasting lipid profile?',
    'What does HbA1c 5.9% mean?',
    'What is the address of the main branch?',
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _send(String text) async {
    final query = text.trim();
    if (query.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': query});
      _isTyping = true;
    });
    _ctrl.clear();

    await Future.delayed(const Duration(milliseconds: 1400));

    String reply = '';
    final q = query.toLowerCase();
    if (q.contains('fatigue') || q.contains('tired')) {
      reply = 'For unexplained fatigue, our consultants typically recommend: (1) Complete Blood Count (CBC) with ESR for anemia, (2) Serum Ferritin, (3) Vitamin D 25-OH, and (4) Thyroid Profile (TSH). You can book our Women/Men Wellness Package which covers all of these with Save 38%!';
    } else if (q.contains('fast') || q.contains('lipid') || q.contains('sugar')) {
      reply = 'For Fasting Blood Sugar and Lipid Profiles, 10–12 hours overnight fasting is required. You can drink plain water to stay hydrated. Morning sampling between 6:30 AM and 9:30 AM is ideal.';
    } else if (q.contains('hba1c') || q.contains('5.9')) {
      reply = 'An HbA1c of 5.9% falls in the pre-diabetes borderline bracket (5.7% – 6.4%). Normal is below 5.7%. We advise consulting Dr. Samina Riaz (Endocrinologist) and adopting moderate aerobic exercise.';
    } else if (q.contains('branch') || q.contains('address') || q.contains('location')) {
      reply = 'Our Main Campus is located at 680-A Shadman, Opp. Fatima Memorial Hospital, Lahore. We are open Monday–Sunday, 9:00 AM to 12:00 Midnight. UAN: +92 42 111 939 939.';
    } else {
      reply = 'Thank you for asking! Al Noor Diagnostic Centre provides comprehensive pathology analysers, 128-slice MDCT, Open MRI, and home sampling. Would you like to schedule a test or talk to a consultant?';
    }

    if (mounted) {
      setState(() {
        _messages.add({'role': 'ai', 'text': reply});
        _isTyping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.auto_awesome_rounded, color: AppColors.brandCopper, size: 20),
            SizedBox(width: 8),
            Text('Talk to AI Assistant'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Medical Disclaimer Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: isDark ? const Color(0xFF261D20) : const Color(0xFFFBF0EA),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: AppColors.brandCopper, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'AI Health Assistant is for educational guidance only and does not replace medical diagnosis by a licensed doctor.',
                    style: TextStyle(fontSize: 10, color: isDark ? AppColors.darkTextSoft : AppColors.inkSoft),
                  ),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final msg = _messages[idx];
                final isUser = msg['role'] == 'user';

                return Row(
                  mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isUser) ...[
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.76),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? AppColors.brandRed
                            : (isDark ? AppColors.darkSurface : AppColors.surface),
                        borderRadius: BorderRadius.circular(18),
                        border: isUser ? null : Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                      ),
                      child: Text(
                        msg['text']!,
                        style: TextStyle(
                          color: isUser ? Colors.white : (isDark ? AppColors.darkText : AppColors.ink),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Typing animation
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.brandRed)),
                  const SizedBox(width: 8),
                  const Text('AI is analyzing diagnostic database...', style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
                ],
              ),
            ),

          // Suggested Prompts
          if (_messages.length <= 3) ...[
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _suggestedPrompts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final prompt = _suggestedPrompts[i];
                  return ActionChip(
                    label: Text(prompt, style: const TextStyle(fontSize: 11)),
                    backgroundColor: isDark ? AppColors.darkSurface : AppColors.brandPeach.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: AppColors.brandCopper)),
                    onPressed: () => _send(prompt),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Input Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      decoration: const InputDecoration(
                        hintText: 'Ask about any test, preparation, or symptoms...',
                        hintStyle: TextStyle(fontSize: 12),
                        border: InputBorder.none,
                      ),
                      onSubmitted: _send,
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: AppColors.brandRed, shape: BoxShape.circle),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    ),
                    onPressed: () => _send(_ctrl.text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
