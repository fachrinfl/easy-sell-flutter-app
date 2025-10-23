import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_service.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseService.instance.auth.authStateChanges();
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthService {
  final FirebaseService _firebaseService = FirebaseService.instance;

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _firebaseService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseService.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user != null) {
      await _firebaseService.createUserDocument(
        uid: credential.user!.uid,
        email: email,
        displayName: credential.user!.displayName,
        photoURL: credential.user!.photoURL,
      );
    }

    return credential;
  }

  Future<void> signOut() async {
    await _firebaseService.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseService.sendPasswordResetEmail(email);
  }

  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    await _firebaseService.updateUserProfile(
      displayName: displayName,
      photoURL: photoURL,
    );
  }

  Future<void> deleteUser() async {
    await _firebaseService.deleteUser();
  }

  User? get currentUser => _firebaseService.currentUser;

  bool get isAuthenticated => _firebaseService.isAuthenticated;

  Future<void> updateBusinessName(String businessName) async {
    await _firebaseService.updateBusinessName(businessName);
  }

  Future<String?> getBusinessName() async {
    return await _firebaseService.getBusinessName();
  }

  Future<void> createUserDocument({
    required String uid,
    required String email,
    String? displayName,
    String? photoURL,
    String? businessName,
  }) async {
    await _firebaseService.createUserDocument(
      uid: uid,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
      businessName: businessName,
    );
  }
}

final businessNameProvider = StateNotifierProvider<BusinessNameNotifier, AsyncValue<String?>>((ref) {
  return BusinessNameNotifier(ref.read(authServiceProvider));
});

class BusinessNameNotifier extends StateNotifier<AsyncValue<String?>> {
  final AuthService _authService;

  BusinessNameNotifier(this._authService) : super(const AsyncValue.loading()) {
    _loadBusinessName();
  }

  Future<void> _loadBusinessName() async {
    try {
      final businessName = await _authService.getBusinessName();
      state = AsyncValue.data(businessName);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateBusinessName(String businessName) async {
    try {
      await _authService.updateBusinessName(businessName);
      state = AsyncValue.data(businessName);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void refresh() {
    _loadBusinessName();
  }
}
