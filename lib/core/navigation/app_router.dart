import 'package:go_router/go_router.dart';
import '../presentation/widgets/scaffold_with_nav_bar.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/messages/presentation/screens/messages_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(
          title: _getTitle(state.uri.path),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: '/messages',
          builder: (context, state) => const MessagesScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);

String _getTitle(String location) {
  switch (location) {
    case '/home':
      return 'Главная страница';
    case '/notifications':
      return 'Уведомления';
    case '/messages':
      return 'Сообщения';
    case '/settings':
      return 'Настройки';
    default:
      return 'Главная страница';
  }
}
