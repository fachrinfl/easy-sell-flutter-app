import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/pages/forgot_password_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/register_page.dart';
import '../../features/auth/pages/welcome_page.dart';
import '../../features/pos/models/product.dart';
import '../../shared/widgets/pages/add_product_page.dart';
import '../../shared/widgets/pages/edit_product_page.dart';
import '../../shared/widgets/pages/inventory_page.dart';
import '../../shared/widgets/pages/main_navigation_page.dart';
import '../../shared/widgets/pages/pos_page.dart';
import '../../shared/widgets/pages/reports_page.dart';
import '../../shared/widgets/pages/settings_page.dart';
import '../../shared/widgets/pages/transaction_history_page.dart';
import '../../shared/widgets/pages/view_product_page.dart';
import '../services/auth_service.dart';
import 'app_router.dart';

class AuthRouter extends ConsumerWidget {
  const AuthRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        final router = GoRouter(
          initialLocation: AppRouter.welcome,
          redirect: (context, state) {
            final isAuth = user != null;
            final isAuthPage = _isAuthPage(state.uri.toString());

            if (!isAuth && !isAuthPage) {
              return AppRouter.login;
            }

            if (isAuth && isAuthPage) {
              return AppRouter.home;
            }

            return null;
          },
          routes: routes,
        );

        return MaterialApp.router(
          title: 'EasySell POS',
          theme: Theme.of(context),
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      },
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Authentication Error: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(authStateProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isAuthPage(String location) {
    return location == AppRouter.welcome ||
        location == AppRouter.login ||
        location == AppRouter.register ||
        location == AppRouter.forgotPassword;
  }
}

final List<RouteBase> routes = [
  GoRoute(
    path: AppRouter.welcome,
    name: 'welcome',
    builder: (context, state) => const WelcomePage(),
  ),
  GoRoute(
    path: AppRouter.login,
    name: 'login',
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: AppRouter.register,
    name: 'register',
    builder: (context, state) => const RegisterPage(),
  ),
  GoRoute(
    path: AppRouter.forgotPassword,
    name: 'forgotPassword',
    builder: (context, state) => const ForgotPasswordPage(),
  ),
  GoRoute(
    path: AppRouter.home,
    name: 'home',
    builder: (context, state) => const MainNavigationPage(),
  ),
  GoRoute(
    path: AppRouter.pos,
    name: 'pos',
    builder: (context, state) => const POSPage(),
  ),
  GoRoute(
    path: AppRouter.inventory,
    name: 'inventory',
    builder: (context, state) => const InventoryPage(),
  ),
  GoRoute(
    path: AppRouter.addProduct,
    name: 'addProduct',
    builder: (context, state) => const AddProductPage(),
  ),
  GoRoute(
    path: AppRouter.viewProduct,
    name: 'viewProduct',
    builder: (context, state) {
      final product = state.extra as Product?;
      return ViewProductPage(product: product?.toJson() ?? {});
    },
  ),
  GoRoute(
    path: AppRouter.editProduct,
    name: 'editProduct',
    builder: (context, state) {
      final product = state.extra as Product?;
      return EditProductPage(product: product?.toJson() ?? {});
    },
  ),
  GoRoute(
    path: AppRouter.settings,
    name: 'settings',
    builder: (context, state) => const SettingsPage(),
  ),
  GoRoute(
    path: AppRouter.reports,
    name: 'reports',
    builder: (context, state) => const ReportsPage(),
  ),
  GoRoute(
    path: AppRouter.transactionHistory,
    name: 'transactionHistory',
    builder: (context, state) => const TransactionHistoryPage(),
  ),
];
