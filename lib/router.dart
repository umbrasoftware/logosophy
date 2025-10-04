import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logosophy/database/notes/models/note.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/pages/books_tab/pdf_viewer.dart';
import 'package:logosophy/pages/splash_pages/login_page.dart';
import 'package:logosophy/pages/splash_pages/registration_page.dart';
import 'package:logosophy/pages/splash_pages/setup_page.dart';
import 'package:logosophy/pages/splash_pages/splash_page.dart';

import 'pages/books_tab/books_page.dart';
import 'pages/home_tab/home_page.dart';
import 'pages/notes_tab/notes_page.dart';
import 'pages/search_tab/search_page.dart';
import 'pages/settings_tab/settings_page.dart';

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

    // If the user is not logged in, they can only access the login and
    // register pages. Any other attempt will redirect them to the login page.
    if (!loggedIn) {
      final bool isGoingToLogin = state.matchedLocation == '/login';
      final bool isGoingToRegister = state.matchedLocation == '/register';

      // Allow access only to login and register screens.
      // Redirect to /login in any other case (including the splash screen '/').
      return isGoingToLogin || isGoingToRegister ? null : '/login';
    }

    // If a logged-in user is on an auth route, redirect them to the loading page
    // to perform one-time checks before proceeding to the main app.
    final onAuthRoute =
        state.matchedLocation == '/' ||
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    if (onAuthRoute) {
      return '/loading';
    }

    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/loading', builder: (context, state) => const SetupPage()),
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
              builder: (context, state) =>
                  NotesPage(note: state.extra as Note?),
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
    GoRoute(
      path: '/pdfviewer',
      builder: (context, state) => PdfViewer(file: state.extra as File),
    ),
    GoRoute(
      path: '/note-editor',
      builder: (context, state) => NotesPage(note: state.extra as Note?),
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
        showSelectedLabels: false,
        showUnselectedLabels: false,
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
