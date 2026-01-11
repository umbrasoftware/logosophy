import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/pages/books_tab/pdf_reader.dart';
import 'package:logosophy/pages/splash_pages/setup_page.dart';

import 'pages/books_tab/books_page.dart';
import 'pages/search_tab/search_page.dart';
import 'pages/settings_tab/settings_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/loading',
  routes: [
    GoRoute(path: '/loading', builder: (context, state) => const SetupPage()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/books', builder: (context, state) => const BooksPage())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/search', builder: (context, state) => const SearchPage())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/settings', builder: (context, state) => const SettingsPage())],
        ),
      ],
    ),
    GoRoute(
      path: '/pdfviewer',
      builder: (context, state) {
        final extra = state.extra as ReaderArgs;
        return PDFReader(filePath: extra.path, page: extra.page);
      },
    ),
  ],
);

class _ScaffoldWithNavBar extends StatelessWidget {
  const _ScaffoldWithNavBar({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
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
          BottomNavigationBarItem(icon: const Icon(Icons.book), label: t.navBar.books),
          BottomNavigationBarItem(icon: const Icon(Icons.search), label: t.navBar.search),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: t.navBar.settings),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
