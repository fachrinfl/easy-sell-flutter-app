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

class AppRouter {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String pos = '/pos';
  static const String inventory = '/home/inventory';
  static const String addProduct = '/home/inventory/add-product';
  static const String viewProduct = '/home/inventory/view-product';
  static const String editProduct = '/home/inventory/edit-product';
  static const String settings = '/settings';
  static const String reports = '/reports';
  static const String transactionHistory = '/transactions/history';

  static final GoRouter router = GoRouter(
    initialLocation: welcome,
    redirect: (context, state) {
      return null;
    },
    routes: [
      GoRoute(
        path: welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const MainNavigationPage(),
      ),
      GoRoute(
        path: '/home/inventory',
        name: 'inventory',
        builder: (context, state) => const InventoryPage(),
      ),
      GoRoute(
        path: '/home/inventory/add-product',
        name: 'addProduct',
        builder: (context, state) => const AddProductPage(),
      ),
      GoRoute(
        path: '/home/inventory/view-product',
        name: 'viewProduct',
        builder: (context, state) {
          final product = state.extra as Product?;
          return ViewProductPage(product: product?.toJson() ?? {});
        },
      ),
      GoRoute(
        path: '/home/inventory/edit-product',
        name: 'editProduct',
        builder: (context, state) {
          final product = state.extra as Product?;
          return EditProductPage(product: product?.toJson() ?? {});
        },
      ),
      GoRoute(
        path: pos,
        name: 'pos',
        builder: (context, state) => const POSPage(),
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: reports,
        name: 'reports',
        builder: (context, state) => const ReportsPage(),
      ),
      GoRoute(
        path: transactionHistory,
        name: 'transactionHistory',
        builder: (context, state) => const TransactionHistoryPage(),
      ),
    ],
  );
}
