import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logosophy/pages/splash_pages/login_page.dart';
import 'package:logosophy/pages/splash_pages/registration_page.dart';
import 'package:logosophy/pages/splash_pages/splash_page.dart';

import 'pages/books_tab/books_page.dart';
import 'pages/home_tab/home_page.dart';
import 'pages/notes_tab/notes_page.dart';
import 'pages/search_tab/search_page.dart';
import 'pages/settings_tab/settings_page.dart';
import 'package:logosophy/gen/strings.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Notifies the GoRouter about changes in the authentication state.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  refreshListenable: GoRouterRefreshStream(
    FirebaseAuth.instance.authStateChanges(),
  ),
  redirect: (BuildContext context, GoRouterState state) {
    final bool loggedIn = FirebaseAuth.instance.currentUser != null;
    bool onAuthRoute =
        state.matchedLocation == '/' ||
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    // Se o usuário não estiver logado, ele só pode acessar as rotas de autenticação.
    // Se tentar acessar qualquer outra, será redirecionado para /login.
    if (!loggedIn) {
      final bool isGoingToLogin = state.matchedLocation == '/login';
      final bool isGoingToRegister = state.matchedLocation == '/register';

      // Permite o acesso apenas às telas de login e registro.
      // Redireciona para /login em qualquer outro caso (incluindo a splash '/').
      return isGoingToLogin || isGoingToRegister ? null : '/login';
    }

    // Usuário está logado.
    onAuthRoute =
        state.matchedLocation == '/' ||
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    // Se estiver em uma rota de autenticação, redireciona para a home.
    if (onAuthRoute) {
      return '/home';
    }

    // Nenhum redirecionamento necessário.
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/books',
              builder: (context, state) => const BooksPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notes',
              builder: (context, state) => const NotesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class _ScaffoldWithNavBar extends StatelessWidget {
  const _ScaffoldWithNavBar({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: t.navBar.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.book),
            label: t.navBar.books,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: t.navBar.search,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notes_outlined),
            label: t.navBar.notes,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: t.navBar.settings,
          ),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
