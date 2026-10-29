import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../data/models/chat_model.dart';
import '../../../data/repositories/chat_repository.dart';

class LiveChatScreen extends ConsumerStatefulWidget {
  const LiveChatScreen({super.key});

  @override
  ConsumerState<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends ConsumerState<LiveChatScreen> {
  final TextEditingController _msgCtrl = TextEditingController();

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    ref.read(chatProvider.notifier).sendMessage(text);
    _msgCtrl.clear();
  }

  void _showEndChatDialog() {
    int rating = 5;
    final commentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('End Chat & Rate Agent'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('How satisfied were you with this support session?'),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return IconButton(
                    icon: Icon(
                      i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () => setDialogState(() => rating = i + 1),
                  );
                }),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: commentCtrl,
                decoration: const InputDecoration(
                  hintText: 'Optional comment...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.brandRed),
              onPressed: () {
                ref.read(chatProvider.notifier).endChat(rating, commentCtrl.text);
                Navigator.of(ctx).pop();
                context.pop();
                AppToast.show(context, title: 'Thank you for your feedback!', type: ToastType.success);
              },
              child: const Text('Submit & End', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Pre-Chat Screen if no topic selected yet
    if (chatState.topic == null) {
      return _buildPreChatView(isDark);
    }

    // Connecting Screen
    if (chatState.isConnecting) {
      return _buildConnectingView(chatState.topic!, isDark);
    }

    final agent = chatState.assignedAgent;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.brandPeach,
              child: Text(
                agent?.avatarInitials ?? 'SA',
                style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.brandRed, fontSize: 13),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agent?.name ?? 'Al Noor Agent',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
                Text(
                  '${agent?.department} • Online',
                  style: const TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Transcript',
            onPressed: () {
              AppToast.show(context, title: 'Chat Transcript Copied', type: ToastType.info);
            },
          ),
          TextButton(
            onPressed: _showEndChatDialog,
            child: const Text('End', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: chatState.messages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final msg = chatState.messages[idx];
                final isUser = msg.sender == MessageSender.user;

                return Column(
                  crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? AppColors.brandRed
                            : (isDark ? AppColors.darkSurface : AppColors.surface),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft: Radius.circular(isUser ? 18 : 4),
                          bottomRight: Radius.circular(isUser ? 4 : 18),
                        ),
                        border: isUser
                            ? null
                            : Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg.text,
                            style: TextStyle(
                              color: isUser ? Colors.white : (isDark ? AppColors.darkText : AppColors.ink),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateFormat('hh:mm a').format(msg.timestamp),
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: isUser ? Colors.white60 : AppColors.inkLighter,
                                  ),
                                ),
                                if (isUser) ...[
                                  const SizedBox(width: 4),
                                  const Icon(Icons.done_all_rounded, size: 12, color: Colors.white70),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Quick Reply Chips
                    if (!isUser && msg.quickReplies != null && msg.quickReplies!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: msg.quickReplies!.map((reply) {
                          return ActionChip(
                            label: Text(reply, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                            backgroundColor: isDark ? AppColors.darkSurfaceElevated : AppColors.brandPeach.withValues(alpha: 0.35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: const BorderSide(color: AppColors.brandCopper, width: 0.8),
                            ),
                            onPressed: () {
                              ref.read(chatProvider.notifier).sendMessage(reply);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),

          // Typing Indicator
          if (chatState.isAgentTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.brandRed),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${agent?.name ?? "Agent"} is typing...',
                    style: const TextStyle(fontSize: 11, color: AppColors.inkSoft, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),

          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file_rounded, color: AppColors.inkSoft),
                    onPressed: () {
                      AppToast.show(context, title: 'Attachment Added', type: ToastType.info);
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _msgCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Type a message in English or Urdu...',
                        hintStyle: TextStyle(fontSize: 12),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.brandRed,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    ),
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Pre-Chat Topic Selection View
  Widget _buildPreChatView(bool isDark) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Support Chat')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.brandRed.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 6)),
                  ],
                ),
                child: const Icon(Icons.support_agent_rounded, color: Colors.white, size: 40),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Al Noor Patient Support Desk',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'Select a department to connect with an available specialist agent:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.inkSoft),
              ),
            ),
            const SizedBox(height: 28),

            ...ChatTopic.values.map((topic) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                ),
                child: ListTile(
                  onTap: () => ref.read(chatProvider.notifier).startSession(topic),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.brandPeach.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.brandRed, size: 20),
                  ),
                  title: Text(topic.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  subtitle: Text(topic.description, style: const TextStyle(fontSize: 11)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.brandCopper),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // Connecting Animation Screen
  Widget _buildConnectingView(ChatTopic topic, bool isDark) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Connecting to Agent...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                'Assigning a dedicated coordinator for ${topic.title}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppColors.inkSoft),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
