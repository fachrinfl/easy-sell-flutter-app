import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

class AuthGuard {
  static bool isAuthenticated(WidgetRef ref) {
    final authState = ref.read(authStateProvider);
    return authState.when(
      data: (user) => user != null,
      loading: () => false,
      error: (_, __) => false,
    );
  }

  static String? redirectIfNotAuthenticated(BuildContext context, GoRouterState state, WidgetRef ref) {
    final isAuth = isAuthenticated(ref);
    
    if (!isAuth && !_isAuthPage(state.uri.toString())) {
      return '/login';
    }
    
    if (isAuth && _isAuthPage(state.uri.toString())) {
      return '/home';
    }
    
    return null;
  }

  static bool _isAuthPage(String location) {
    return location == '/' ||
           location == '/login' ||
           location == '/register' ||
           location == '/forgot-password';
  }
}

String? authRedirect(BuildContext context, GoRouterState state) {
  return null;
}
