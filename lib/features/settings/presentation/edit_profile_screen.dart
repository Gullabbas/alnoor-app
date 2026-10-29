import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../data/repositories/auth_repository.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _cnicCtrl;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _nameCtrl = TextEditingController(text: user?.fullName ?? '');
    _emailCtrl = TextEditingController(text: user?.email ?? '');
    _cnicCtrl = TextEditingController(text: user?.cnic ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _cnicCtrl.dispose();
    super.dispose();
  }

  void _onSave() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      AppToast.show(context, title: 'Name cannot be empty', type: ToastType.error);
      return;
    }

    await ref.read(authProvider.notifier).updateProfile(
          fullName: name,
          email: _emailCtrl.text.trim(),
          cnic: _cnicCtrl.text.trim(),
        );

    if (!mounted) return;
    AppToast.show(context, title: 'Profile Updated Successfully', type: ToastType.success);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: AppColors.brandPeach,
                    child: Text(
                      user != null && user.fullName.isNotEmpty ? user.fullName[0] : 'P',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.brandRed),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: AppColors.brandRed, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            AppTextField(
              label: 'Full Name',
              controller: _nameCtrl,
              prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.brandRed),
            ),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Phone Number (Verified)',
              controller: TextEditingController(text: user?.phone ?? '0300 1234567'),
              enabled: false,
              prefixIcon: const Icon(Icons.phone_iphone_rounded, color: AppColors.inkSoft),
            ),
            const SizedBox(height: 16),

            AppTextField(
              label: 'CNIC / National Identity (Optional)',
              controller: _cnicCtrl,
              hint: '35201-1234567-1',
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.brandCopper),
            ),
            const SizedBox(height: 16),

            AppTextField(
              label: 'Email Address (Optional)',
              controller: _emailCtrl,
              hint: 'patient@example.pk',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.brandCopper),
            ),
            const SizedBox(height: 36),

            AppButton(
              text: 'Save Changes',
              onPressed: _onSave,
            ),
          ],
        ),
      ),
    );
  }
}
