import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logosophy/gen/strings.g.dart';
import 'package:logosophy/pages/books_tab/pdf_reader.dart';
import 'package:logosophy/pages/settings_tab/support_page.dart';
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
    StatefulShellRoute(
      navigatorContainerBuilder: (context, navigationShell, children) {
        return _SlidingBranchContainer(navigationShell: navigationShell, children: children);
      },
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
    GoRoute(
      path: '/support',
      builder: (context, state) {
        return SupportPage();
      },
    ),
  ],
);

class _SlidingBranchContainer extends StatefulWidget {
  const _SlidingBranchContainer({required this.navigationShell, required this.children});

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  State<_SlidingBranchContainer> createState() => _SlidingBranchContainerState();
}

class _SlidingBranchContainerState extends State<_SlidingBranchContainer> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.navigationShell.currentIndex);
  }

  @override
  void didUpdateWidget(covariant _SlidingBranchContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.navigationShell.currentIndex != _pageController.page?.round()) {
      _pageController.jumpToPage(widget.navigationShell.currentIndex);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const ClampingScrollPhysics(),
      onPageChanged: (index) {
        if (index != widget.navigationShell.currentIndex) {
          FocusManager.instance.primaryFocus?.unfocus();
          widget.navigationShell.goBranch(index, initialLocation: false);
        }
      },
      children: widget.children.map((child) => _KeepAlivePage(child: child)).toList(),
    );
  }
}

class _KeepAlivePage extends StatefulWidget {
  const _KeepAlivePage({required this.child});
  final Widget child;

  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}

class _ScaffoldWithNavBar extends StatelessWidget {
  const _ScaffoldWithNavBar({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: t.navBar.books,
          ),
          NavigationDestination(icon: const Icon(Icons.search), label: t.navBar.search),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: t.navBar.settings,
          ),
        ],
      ),
    );
  }
}
