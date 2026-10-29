import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, String>> _notifications = [
    {
      'title': 'Phlebotomist Assigned',
      'body': 'Tariq Mehmood is assigned for your home sampling appointment today.',
      'time': '10 mins ago',
      'type': 'order',
    },
    {
      'title': 'CBC Report Verified & Ready',
      'body': 'Your Complete Blood Count report has been signed by Prof. Dr. Safdar Ali Malik.',
      'time': '2 hours ago',
      'type': 'report',
    },
    {
      'title': 'Executive Package Special Offer',
      'body': 'Enjoy 38% off on Al Noor Executive Health Profile this month.',
      'time': 'Yesterday',
      'type': 'offer',
    },
    {
      'title': 'Medication Reminder',
      'body': 'Time to take your scheduled Vitamin D3 monthly supplement.',
      'time': '3 days ago',
      'type': 'reminder',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (_notifications.isNotEmpty)
            TextButton(
              onPressed: () => setState(() => _notifications.clear()),
              child: const Text('Clear All', style: TextStyle(color: AppColors.brandRed)),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? const EmptyState(
              icon: Icons.notifications_none_rounded,
              title: 'No Notifications',
              message: 'You have no unread notifications at this time.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, idx) {
                final n = _notifications[idx];
                IconData icon;
                Color color;

                switch (n['type']) {
                  case 'report':
                    icon = Icons.assignment_turned_in_rounded;
                    color = AppColors.success;
                    break;
                  case 'offer':
                    icon = Icons.local_offer_rounded;
                    color = AppColors.brandCopper;
                    break;
                  case 'reminder':
                    icon = Icons.alarm_rounded;
                    color = AppColors.brandRose;
                    break;
                  case 'order':
                  default:
                    icon = Icons.local_shipping_rounded;
                    color = AppColors.brandRed;
                    break;
                }

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    n['title']!,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                  ),
                                ),
                                Text(
                                  n['time']!,
                                  style: const TextStyle(fontSize: 10, color: AppColors.inkLighter),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              n['body']!,
                              style: const TextStyle(fontSize: 12, color: AppColors.inkSoft, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
