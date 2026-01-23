import 'package:go_router/go_router.dart';
import 'package:testapp/features/counter/presentation/pages/counter_details_page.dart';
import 'package:testapp/features/counter/presentation/pages/counter_page.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: CounterPage.routePath,
        name: CounterPage.routeName,
        builder: (context, state) => const CounterPage(),
      ),
      GoRoute(
        path: CounterDetailsPage.routePath,
        name: CounterDetailsPage.routeName,
        builder: (context, state) => const CounterDetailsPage(),
      ),
    ],
  );
}

