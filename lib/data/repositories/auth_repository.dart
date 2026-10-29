import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../demo/fake_api.dart';
import '../demo/seed_data.dart';
import '../models/user_model.dart';

class AuthState {
  final UserModel? user;
  final String? activeProfileId;
  final bool isAuthenticated;
  final bool isGuest;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.activeProfileId,
    this.isAuthenticated = false,
    this.isGuest = false,
    this.isLoading = false,
    this.error,
  });

  FamilyProfile? get activeProfile {
    if (user == null) return null;
    return user!.familyProfiles.firstWhere(
      (p) => p.id == (activeProfileId ?? user!.defaultProfileId),
      orElse: () => user!.familyProfiles.first,
    );
  }

  AuthState copyWith({
    UserModel? user,
    String? activeProfileId,
    bool? isAuthenticated,
    bool? isGuest,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      activeProfileId: activeProfileId ?? this.activeProfileId,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isGuest: isGuest ?? this.isGuest,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  SharedPreferences? _prefs;
  List<UserModel> _userList = [];

  @override
  AuthState build() {
    _init();
    // Default to Ahmed Raza so the app opens immediately populated with data!
    return AuthState(
      user: SeedData.users[0],
      activeProfileId: SeedData.users[0].defaultProfileId,
      isAuthenticated: true,
    );
  }

  Future<void> _init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _userList = List<UserModel>.from(SeedData.users);
      final savedPhone = _prefs?.getString('auth_phone');
      if (savedPhone != null) {
        final user = _userList.firstWhere(
          (u) => u.phone == savedPhone,
          orElse: () => _userList[0],
        );
        final profileId = _prefs?.getString('active_profile_id') ?? user.defaultProfileId;
        state = AuthState(
          user: user,
          activeProfileId: profileId,
          isAuthenticated: true,
        );
      }
    } catch (_) {
      _userList = List<UserModel>.from(SeedData.users);
    }
  }

  Future<bool> login(String rawPhone) async {
    state = state.copyWith(isLoading: true, error: null);
    await FakeApi.delay(400, 800);

    // Clean phone format: remove spaces and hyphens
    final cleanPhone = rawPhone.replaceAll(RegExp(r'[\s\-]'), '');

    UserModel? matchingUser;
    for (final u in _userList) {
      if (u.phone == cleanPhone || cleanPhone.endsWith(u.phone.substring(1))) {
        matchingUser = u;
        break;
      }
    }

    if (matchingUser != null) {
      state = state.copyWith(
        user: matchingUser,
        activeProfileId: matchingUser.defaultProfileId,
        isLoading: false,
      );
      return true;
    } else {
      // Dynamic user creation for any valid Pakistani phone number
      final newUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        phone: cleanPhone,
        fullName: 'Al Noor Patient',
        gender: 'Male',
        age: 30,
        pin: '1234',
        defaultProfileId: 'prof_new_1',
        healthCardNumber: '2557 0000 1122 3344',
        healthCardTier: 'Blue',
        healthPoints: 100,
        familyProfiles: [
          FamilyProfile(
            id: 'prof_new_1',
            fullName: 'Al Noor Patient',
            relation: 'Self',
            age: 30,
            gender: 'Male',
            patientId: 'ALN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          ),
        ],
      );
      _userList.add(newUser);
      state = state.copyWith(
        user: newUser,
        activeProfileId: newUser.defaultProfileId,
        isLoading: false,
      );
      return true;
    }
  }

  Future<bool> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true, error: null);
    await FakeApi.delay(300, 600);
    // Universal demo OTP is 1234
    if (otp == '1234') {
      state = state.copyWith(isLoading: false);
      return true;
    } else {
      state = state.copyWith(isLoading: false, error: 'Invalid verification code. Enter 1234');
      return false;
    }
  }

  Future<bool> verifyPin(String pin) async {
    state = state.copyWith(isLoading: true, error: null);
    await FakeApi.delay(300, 600);
    if (state.user != null && (state.user!.pin == pin || pin == '1234')) {
      await _prefs?.setString('auth_phone', state.user!.phone);
      await _prefs?.setString('active_profile_id', state.user!.defaultProfileId);
      state = state.copyWith(
        isAuthenticated: true,
        isGuest: false,
        isLoading: false,
      );
      return true;
    } else {
      state = state.copyWith(isLoading: false, error: 'Incorrect PIN. Demo PIN is 1234');
      return false;
    }
  }

  void continueAsGuest() {
    state = state.copyWith(
      user: SeedData.users[0],
      activeProfileId: SeedData.users[0].defaultProfileId,
      isAuthenticated: true,
      isGuest: true,
    );
  }

  void switchActiveProfile(String profileId) {
    if (state.user == null) return;
    _prefs?.setString('active_profile_id', profileId);
    state = state.copyWith(activeProfileId: profileId);
  }

  Future<void> addFamilyProfile({
    required String fullName,
    required String relation,
    required int age,
    required String gender,
    String bloodGroup = 'O+',
  }) async {
    if (state.user == null) return;
    state = state.copyWith(isLoading: true);
    await FakeApi.delay(400, 700);

    final newProf = FamilyProfile(
      id: 'prof_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      relation: relation,
      age: age,
      gender: gender,
      patientId: 'ALN-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
      bloodGroup: bloodGroup,
    );

    final updatedProfiles = List<FamilyProfile>.from(state.user!.familyProfiles)..add(newProf);
    final updatedUser = state.user!.copyWith(familyProfiles: updatedProfiles);

    state = state.copyWith(
      user: updatedUser,
      isLoading: false,
    );
  }

  Future<void> updateProfile({
    required String fullName,
    String? email,
    String? cnic,
  }) async {
    if (state.user == null) return;
    state = state.copyWith(isLoading: true);
    await FakeApi.delay(300, 600);
    final updatedUser = state.user!.copyWith(
      fullName: fullName,
      email: email,
      cnic: cnic,
    );
    state = state.copyWith(user: updatedUser, isLoading: false);
  }

  Future<void> toggleBiometric(bool enabled) async {
    if (state.user == null) return;
    final updated = state.user!.copyWith(biometricEnabled: enabled);
    state = state.copyWith(user: updated);
  }

  Future<void> resetDemoData() async {
    state = state.copyWith(isLoading: true);
    await FakeApi.delay(400, 800);
    _userList = List<UserModel>.from(SeedData.users);
    final mainUser = _userList[0];
    await _prefs?.setString('auth_phone', mainUser.phone);
    await _prefs?.setString('active_profile_id', mainUser.defaultProfileId);
    state = AuthState(
      user: mainUser,
      activeProfileId: mainUser.defaultProfileId,
      isAuthenticated: true,
      isGuest: false,
      isLoading: false,
    );
  }

  void logout() {
    _prefs?.remove('auth_phone');
    _prefs?.remove('active_profile_id');
    state = const AuthState(isAuthenticated: false);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() => AuthNotifier());
