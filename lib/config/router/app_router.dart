import 'package:go_router/go_router.dart';
import 'package:testapp/features/auth/presentation/pages/login_page.dart';
import 'package:testapp/features/home/presentation/page/home_page.dart';

import 'route_names.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        name: RouteNames.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}

