import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/health_card_widget.dart';
import '../../../data/demo/seed_data.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../../../data/repositories/orders_repository.dart';

class BookSamplingScreen extends ConsumerStatefulWidget {
  const BookSamplingScreen({super.key});

  @override
  ConsumerState<BookSamplingScreen> createState() => _BookSamplingScreenState();
}

class _BookSamplingScreenState extends ConsumerState<BookSamplingScreen> {
  int _currentStep = 1;
  final int _totalSteps = 7;

  // Step 1: Patient
  FamilyProfile? _selectedPatient;

  // Step 2: Address
  Map<String, dynamic>? _selectedAddress;

  // Step 3: Date & Slot
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedSlot = '07:30 AM – 08:30 AM';

  // Step 4: Health Card
  bool _applyHealthCard = true;

  // Step 5: Tests / Packages
  final List<OrderItem> _selectedItems = [];

  // Step 6: Prescription & Notes
  bool _hasPrescriptionUploaded = false;
  final TextEditingController _notesCtrl = TextEditingController();

  // Step 7: Payment
  String _selectedPaymentMethod = 'Cash on Collection';

  late ConfettiController _confettiCtrl;

  @override
  void initState() {
    super.initState();
    _confettiCtrl = ConfettiController(duration: const Duration(seconds: 3));

    final auth = ref.read(authProvider);
    _selectedPatient = auth.activeProfile ?? auth.user?.defaultProfile;
    _selectedAddress = SeedData.savedAddresses.first;

    // Pre-populate with items from cart if any
    final cart = ref.read(cartProvider);
    if (cart.items.isNotEmpty) {
      _selectedItems.addAll(cart.items);
    } else {
      // Default to CBC
      _selectedItems.add(const OrderItem(id: 't_cbc', name: 'Complete Blood Count (CBC)', price: 1150));
    }
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    _confettiCtrl.dispose();
    super.dispose();
  }

  int get _subtotal => _selectedItems.fold(0, (sum, i) => sum + i.price);
  int get _cardDiscount => _applyHealthCard ? (_subtotal * 0.20).round() : 0;
  int get _total => (_subtotal - _cardDiscount) > 0 ? (_subtotal - _cardDiscount) : 0;

  void _onConfirm() async {
    final patient = _selectedPatient ?? ref.read(authProvider).user!.defaultProfile;
    final addrStr = _selectedAddress != null ? '${_selectedAddress!['street']}, ${_selectedAddress!['city']}' : 'Sabzazar, Lahore';

    final order = await ref.read(ordersProvider.notifier).createBooking(
          patientId: patient.patientId,
          patientName: patient.fullName,
          address: addrStr,
          date: _selectedDate,
          timeSlot: _selectedSlot,
          items: _selectedItems,
          subtotal: _subtotal,
          discount: _cardDiscount,
          total: _total,
          paymentMethod: _selectedPaymentMethod,
        );

    ref.read(cartProvider.notifier).clearCart();
    _confettiCtrl.play();

    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      context.go('/order-success/${order.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Home Sampling'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (_currentStep > 1) {
              setState(() => _currentStep--);
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Step Progress Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Step $_currentStep of $_totalSteps: ${_stepTitle(_currentStep)}',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        Text(
                          '${((_currentStep / _totalSteps) * 100).toInt()}%',
                          style: const TextStyle(color: AppColors.brandRed, fontWeight: FontWeight.w800, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _currentStep / _totalSteps,
                        backgroundColor: isDark ? Colors.white12 : Colors.black12,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.brandRed),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),

              // Step Content Area
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildCurrentStep(isDark),
                ),
              ),

              // Bottom Navigation Actions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border)),
                ),
                child: Row(
                  children: [
                    if (_currentStep > 1) ...[
                      OutlinedButton(
                        onPressed: () => setState(() => _currentStep--),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          side: const BorderSide(color: AppColors.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text('Back'),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: AppButton(
                        text: _currentStep == _totalSteps ? 'Confirm Booking — PKR $_total' : 'Next Step',
                        onPressed: () {
                          if (_currentStep < _totalSteps) {
                            setState(() => _currentStep++);
                          } else {
                            _onConfirm();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Confetti Celebration
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiCtrl,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.brandRed,
                AppColors.brandCopper,
                AppColors.brandRose,
                Colors.amber,
                Colors.white,
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _stepTitle(int step) {
    switch (step) {
      case 1:
        return 'Select Patient';
      case 2:
        return 'Address & Location';
      case 3:
        return 'Date & Time Slot';
      case 4:
        return 'Health Card Discount';
      case 5:
        return 'Select Tests & Packages';
      case 6:
        return 'Prescription & Notes';
      case 7:
        return 'Review & Payment';
      default:
        return '';
    }
  }

  Widget _buildCurrentStep(bool isDark) {
    switch (_currentStep) {
      case 1:
        return _buildStep1Patient(isDark);
      case 2:
        return _buildStep2Address(isDark);
      case 3:
        return _buildStep3DateTime(isDark);
      case 4:
        return _buildStep4HealthCard(isDark);
      case 5:
        return _buildStep5Tests(isDark);
      case 6:
        return _buildStep6Prescription(isDark);
      case 7:
        return _buildStep7Summary(isDark);
      default:
        return const SizedBox();
    }
  }

  // STEP 1: PATIENT SELECTION
  Widget _buildStep1Patient(bool isDark) {
    final user = ref.watch(authProvider).user;
    final profiles = user?.familyProfiles ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Who is this test for?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        const Text('Select the patient profile who will be sampled.', style: TextStyle(fontSize: 12, color: AppColors.inkSoft)),
        const SizedBox(height: 16),
        ...profiles.map((p) {
          final isSelected = p.id == (_selectedPatient?.id ?? '');
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.brandRed : (isDark ? AppColors.darkBorder : AppColors.border),
                width: isSelected ? 2.0 : 1.2,
              ),
            ),
            child: ListTile(
              onTap: () => setState(() => _selectedPatient = p),
              leading: CircleAvatar(
                backgroundColor: isSelected ? AppColors.brandRed : AppColors.brandPeach,
                child: Text(
                  p.initials,
                  style: TextStyle(color: isSelected ? Colors.white : AppColors.brandRed, fontWeight: FontWeight.w700),
                ),
              ),
              title: Text(p.fullName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              subtitle: Text('${p.relation} • ${p.age} yrs • ID: ${p.patientId}'),
              trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.brandRed) : null,
            ),
          );
        }),
      ],
    );
  }

  // STEP 2: ADDRESS SELECTION
  Widget _buildStep2Address(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Where should our phlebotomist visit?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        const Text('Select your home or office address in Lahore.', style: TextStyle(fontSize: 12, color: AppColors.inkSoft)),
        const SizedBox(height: 16),

        // Mini Map Preview Card
        Container(
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF261D20) : const Color(0xFFF3ECE6),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.brandCopper.withValues(alpha: 0.5)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.map_rounded, size: 48, color: AppColors.brandCopper),
              Positioned(
                bottom: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '📍 Lahore Fast Home Sampling Fleet Active',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        ...SeedData.savedAddresses.map((addr) {
          final isSelected = _selectedAddress?['id'] == addr['id'];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.brandRed : (isDark ? AppColors.darkBorder : AppColors.border),
                width: isSelected ? 2.0 : 1.2,
              ),
            ),
            child: ListTile(
              onTap: () => setState(() => _selectedAddress = addr),
              leading: Icon(
                addr['label'] == 'Home' ? Icons.home_rounded : Icons.apartment_rounded,
                color: isSelected ? AppColors.brandRed : AppColors.inkSoft,
              ),
              title: Text(addr['label'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              subtitle: Text('${addr['street']}, ${addr['city']}', style: const TextStyle(fontSize: 11)),
              trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.brandRed) : null,
            ),
          );
        }),
      ],
    );
  }

  // STEP 3: DATE & TIME SLOTS
  Widget _buildStep3DateTime(bool isDark) {
    final now = DateTime.now();
    final dates = List.generate(7, (i) => now.add(Duration(days: i + 1)));

    final morningSlots = [
      '06:30 AM – 07:30 AM',
      '07:30 AM – 08:30 AM',
      '08:30 AM – 09:30 AM',
      '09:30 AM – 10:30 AM',
    ];
    final afternoonSlots = [
      '11:00 AM – 12:00 PM',
      '02:00 PM – 03:00 PM',
      '04:00 PM – 05:00 PM',
      '06:00 PM – 07:00 PM',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),

        // Horizontal Date Strip
        SizedBox(
          height: 78,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final d = dates[i];
              final isSelected = d.day == _selectedDate.day && d.month == _selectedDate.month;

              return GestureDetector(
                onTap: () => setState(() => _selectedDate = d),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 62,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.brandRed : (isDark ? AppColors.darkSurface : AppColors.surface),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.brandRed : (isDark ? AppColors.darkBorder : AppColors.border),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E').format(d).toUpperCase(),
                        style: TextStyle(
                          color: isSelected ? Colors.white70 : AppColors.inkSoft,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${d.day}',
                        style: TextStyle(
                          color: isSelected ? Colors.white : (isDark ? AppColors.darkText : AppColors.ink),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),

        // Time Slots
        const Text('Morning Fasting Slots', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: morningSlots.map((slot) => _slotChip(slot, isDark)).toList(),
        ),
        const SizedBox(height: 18),

        const Text('Afternoon & Evening Slots', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: afternoonSlots.map((slot) => _slotChip(slot, isDark)).toList(),
        ),
      ],
    );
  }

  Widget _slotChip(String slot, bool isDark) {
    final isSelected = _selectedSlot == slot;
    return ChoiceChip(
      label: Text(slot),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedSlot = slot),
      selectedColor: AppColors.brandRed,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : (isDark ? AppColors.darkText : AppColors.ink),
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        fontSize: 11,
      ),
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.brandRed : (isDark ? AppColors.darkBorder : AppColors.border),
        ),
      ),
    );
  }

  // STEP 4: HEALTH CARD
  Widget _buildStep4HealthCard(bool isDark) {
    final user = ref.watch(authProvider).user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Attach Al Noor Health Card', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        const Text('Save 20% to 35% on all laboratory and imaging diagnostics.', style: TextStyle(fontSize: 12, color: AppColors.inkSoft)),
        const SizedBox(height: 16),

        HealthCardWidget(
          holderName: user?.fullName ?? 'Ahmed Raza',
          cardNumber: user?.healthCardNumber ?? '2557 0001 6257 7360',
          expiry: '12/28',
          points: user?.healthPoints ?? 1250,
        ),
        const SizedBox(height: 16),

        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Apply Health Card 20% Discount', style: TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text('Saves PKR $_cardDiscount on this booking', style: const TextStyle(fontSize: 12, color: AppColors.success)),
          value: _applyHealthCard,
          activeThumbColor: AppColors.brandRed,
          onChanged: (val) => setState(() => _applyHealthCard = val),
        ),
      ],
    );
  }

  // STEP 5: TESTS / PACKAGES SELECTION
  Widget _buildStep5Tests(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selected Tests for Collection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),

        ..._selectedItems.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                ),
                Text('PKR ${item.price}', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.brandRed)),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: AppColors.danger, size: 20),
                  onPressed: () {
                    if (_selectedItems.length > 1) {
                      setState(() => _selectedItems.remove(item));
                    } else {
                      AppToast.show(context, title: 'At least one test is required', type: ToastType.warning);
                    }
                  },
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 16),
        const Text('Frequently Added Tests', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        _suggestTest('t_vit_d', 'Vitamin D 25-Hydroxy', 3600, isDark),
        _suggestTest('t_hba1c', 'HbA1c (Glycated Hemoglobin)', 1450, isDark),
        _suggestTest('t_lipid', 'Lipid Profile (Fasting)', 2600, isDark),
      ],
    );
  }

  Widget _suggestTest(String id, String name, int price, bool isDark) {
    final alreadyAdded = _selectedItems.any((i) => i.id == id);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(name, style: const TextStyle(fontSize: 12))),
          Text('PKR $price', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          TextButton(
            onPressed: alreadyAdded
                ? null
                : () {
                    setState(() {
                      _selectedItems.add(OrderItem(id: id, name: name, price: price));
                    });
                  },
            child: Text(alreadyAdded ? 'Added' : '+ Add', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // STEP 6: PRESCRIPTION & NOTES
  Widget _buildStep6Prescription(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Doctor Prescription (Optional)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        const Text('Upload your prescription (JPG, PNG or PDF under 5MB) for verification.', style: TextStyle(fontSize: 12, color: AppColors.inkSoft)),
        const SizedBox(height: 16),

        GestureDetector(
          onTap: () {
            setState(() => _hasPrescriptionUploaded = !_hasPrescriptionUploaded);
            AppToast.show(
              context,
              title: _hasPrescriptionUploaded ? 'Prescription Attached' : 'Prescription Removed',
              type: ToastType.info,
            );
          },
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _hasPrescriptionUploaded ? AppColors.success : AppColors.brandCopper,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _hasPrescriptionUploaded ? Icons.check_circle_rounded : Icons.cloud_upload_outlined,
                  size: 44,
                  color: _hasPrescriptionUploaded ? AppColors.success : AppColors.brandRed,
                ),
                const SizedBox(height: 8),
                Text(
                  _hasPrescriptionUploaded ? 'Prescription_Dr_Shahid.pdf (1.8 MB)' : 'Click to Upload Prescription',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: _hasPrescriptionUploaded ? AppColors.success : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                const Text('Max size: 5 MB • JPG, PNG, PDF supported', style: TextStyle(fontSize: 10, color: AppColors.inkLighter)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        const Text('Additional Notes for Phlebotomist', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        TextField(
          controller: _notesCtrl,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'e.g. Ring bell twice, senior citizen patient, difficult vein...',
            hintStyle: const TextStyle(fontSize: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    );
  }

  // STEP 7: SUMMARY & PAYMENT SELECTION
  Widget _buildStep7Summary(bool isDark) {
    final patient = _selectedPatient ?? ref.watch(authProvider).user!.defaultProfile;
    final paymentMethods = [
      {'name': 'Cash on Collection', 'icon': Icons.payments_rounded},
      {'name': 'Credit / Debit Card', 'icon': Icons.credit_card_rounded},
      {'name': 'JazzCash', 'icon': Icons.phone_android_rounded},
      {'name': 'Easypaisa', 'icon': Icons.account_balance_wallet_rounded},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Booking Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _summaryRow('Patient', patient.fullName),
              _summaryRow('Patient ID', patient.patientId),
              _summaryRow('Date', DateFormat('EEE, dd MMM yyyy').format(_selectedDate)),
              _summaryRow('Time Slot', _selectedSlot),
              _summaryRow('Address', _selectedAddress?['street'] ?? 'Sabzazar, Lahore'),
              const Divider(height: 20),
              _summaryRow('Subtotal', 'PKR $_subtotal'),
              if (_cardDiscount > 0)
                _summaryRow('Health Card 20% Off', '- PKR $_cardDiscount', valueColor: AppColors.success),
              const Divider(height: 20),
              _summaryRow('Total Amount', 'PKR $_total', isBold: true, valueColor: AppColors.brandRed),
            ],
          ),
        ),
        const SizedBox(height: 24),

        const Text('Select Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),

        ...paymentMethods.map((m) {
          final isSelected = _selectedPaymentMethod == m['name'];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? AppColors.brandRed : (isDark ? AppColors.darkBorder : AppColors.border),
                width: isSelected ? 2.0 : 1.0,
              ),
            ),
            child: ListTile(
              onTap: () => setState(() => _selectedPaymentMethod = m['name'] as String),
              leading: Icon(m['icon'] as IconData, color: isSelected ? AppColors.brandRed : AppColors.inkSoft),
              title: Text(m['name'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.brandRed) : null,
            ),
          );
        }),
      ],
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.inkSoft, fontSize: 13, fontWeight: isBold ? FontWeight.w800 : FontWeight.w400)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.w900 : FontWeight.w700, fontSize: isBold ? 15 : 13, color: valueColor)),
        ],
      ),
    );
  }
}
