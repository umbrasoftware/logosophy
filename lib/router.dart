import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

/// Height of the icon row itself, excluding any system inset below it.
const double _barHeight = 40.0;

/// Clearance the floating bar keeps above the bottom edge / home indicator.
const double _floatingGap = 8.0;

/// Side margin that lifts the floating bar off the screen edges.
const double _floatingMargin = 16.0;

/// Whether the bar should dock into Android's 3-button strip instead of
/// floating above the gesture handle, so the two read as a single surface.
///
/// Gesture navigation reserves back-swipe zones down both vertical edges, so
/// non-zero horizontal [MediaQueryData.systemGestureInsets] means gestures are
/// on; 3-button navigation leaves them at zero. Reading it from MediaQuery
/// keeps the choice reactive — changing the mode in Android Settings re-lays
/// out the bar without an app restart.
///
/// The "is there a bottom strip at all" test deliberately reads `viewPadding`
/// rather than `padding`: the latter collapses to zero while the keyboard is
/// up, which would otherwise flip the bar between styles mid-search.
bool _isDocked(MediaQueryData mq) {
  if (!Platform.isAndroid) return false;
  if (mq.viewPadding.bottom <= 0) return false; // Nothing to merge with.
  return mq.systemGestureInsets.left == 0 && mq.systemGestureInsets.right == 0;
}

/// Hands the system navigation bar over to the app: transparent, no divider
/// and no contrast scrim, so what shows behind Android's buttons is whatever
/// the app paints there. That is what fuses the docked bar with the button
/// strip — Android's own scrim would otherwise tint one half of the pair.
SystemUiOverlayStyle _systemUiStyle(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarContrastEnforced: false,
    // The buttons sit on the bar's surface colour, so they follow the theme.
    systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
  );
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
    final docked = _isDocked(MediaQuery.of(context));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _systemUiStyle(context),
      child: Scaffold(
        // Floating, the page shows through beneath the pill, so it takes the
        // full height and Scaffold hands it the bar's extent as bottom padding
        // instead. Docked, the slab is opaque and butts straight against the
        // content, so the body is laid out above it as before.
        extendBody: !docked,
        body: navigationShell,
        bottomNavigationBar: _buildBar(context, docked: docked),
      ),
    );
  }

  /// Wraps the icon row in whichever shell the active navigation style calls for.
  ///
  /// Docked, the bar is a full-bleed slab whose surface continues behind
  /// Android's buttons — square, seamless and shadowless, because any margin,
  /// corner radius or drop shadow would draw the boundary this mode exists to
  /// erase. Floating, it is a pill hovering clear of the gesture handle, with
  /// the page scrolling visibly beneath it.
  Widget _buildBar(BuildContext context, {required bool docked}) {
    final colorScheme = Theme.of(context).colorScheme;
    final row = SizedBox(
      height: _barHeight,
      child: Row(
        children: [
          Expanded(
            child: _NavBarItem(
              icon: Icons.menu_book_outlined,
              selectedIcon: Icons.menu_book,
              selected: navigationShell.currentIndex == 0,
              tooltip: t.navBar.books,
              onTap: () => _onTap(0),
            ),
          ),
          Expanded(
            child: _NavBarItem(
              icon: Icons.search,
              selectedIcon: Icons.search,
              selected: navigationShell.currentIndex == 1,
              tooltip: t.navBar.search,
              onTap: () => _onTap(1),
            ),
          ),
          Expanded(
            child: _NavBarItem(
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings,
              selected: navigationShell.currentIndex == 2,
              tooltip: t.navBar.settings,
              onTap: () => _onTap(2),
            ),
          ),
        ],
      ),
    );

    if (docked) {
      return ColoredBox(
        color: colorScheme.surfaceContainer,
        child: SafeArea(top: false, child: row),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
        _floatingMargin,
        0,
        _floatingMargin,
        MediaQuery.paddingOf(context).bottom + _floatingGap,
      ),
      child: Material(
        color: colorScheme.surfaceContainer,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        elevation: 8,
        shadowColor: Colors.black,
        child: row,
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Icon(
            selected ? selectedIcon : icon,
            size: 28,
            color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
