import 'dart:developer';

import 'package:eco_adventure/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NavigationLayoutScaffold extends StatefulWidget {
  final Widget child;
  final String path;

  const NavigationLayoutScaffold({
    required this.path,
    required this.child,
    Key? key,
  }) : super(key: key ?? const ValueKey('NavigationLayoutScaffold'));

  @override
  State<NavigationLayoutScaffold> createState() => _NavigationLayoutScaffoldState();
}

class _NavigationLayoutScaffoldState extends State<NavigationLayoutScaffold> {
  final _navigationItems = const [
    {
      'route': 'home',
      'widget': BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
    },
    {
      'route': 'search',
      'widget': BottomNavigationBarItem(label: 'Search', icon: Icon(Icons.search)),
    },
    {
      'route': 'places',
      'routes': ['places', 'destination', 'destinations'],
      'widget': BottomNavigationBarItem(
        icon: Icon(Icons.place),
        label: 'Places',
      ),
    },
    {
      'route': 'travels',
      'routes': ['travel', 'travels'],
      'widget': BottomNavigationBarItem(
        icon: Icon(Icons.map),
        label: 'Travels',
      ),
    },
    {
      'route': 'profile',
      'widget': BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: 'Profile',
      ),
    },
    {
      'route': 'logout',
      'widget': BottomNavigationBarItem(
        icon: Icon(Icons.logout),
        label: 'Logout',
      ),
    },
  ];

  void _goBranch(int index) {
    final navigationItem = _navigationItems[index];

    if (navigationItem['route'] == 'logout') {
      context.read<AuthProvider>().logout().then((_) {
        context.replace('/');
      });

      return;
    }

    context.goNamed(navigationItem['route'] as String);
  }

  int getPathIndex(String path) {
    final uri = Uri.parse(path);
    
    // path without query params
    path = uri.path.toLowerCase();

    return _navigationItems.indexWhere((item) {
      if (item.containsKey('routes')) {
        final routes = item['routes'] as List<String>;

        for (String route in routes) {
          route = route.toLowerCase();
          if (route == path || route == '$path/' || route == '/$path' || route == '/$path/') {
            return true;
          }
        }

        return false;
      } else {
        final route = (item['route'] as String).toLowerCase();
        return route == path || route == '$path/' || route == '/$path' || route == '/$path/';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final index = getPathIndex(widget.path);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index == -1 ? 0 : getPathIndex(widget.path),
        items: _navigationItems.map((item) => item['widget'] as BottomNavigationBarItem).toList(),
        selectedItemColor: index == -1 ? const Color.fromARGB(255, 48, 54, 63) : const Color.fromARGB(255, 22, 160, 133),
        unselectedItemColor: const Color.fromARGB(255, 48, 54, 63),
        selectedLabelStyle: const TextStyle(fontSize: 14),
        onTap: (index) => _goBranch(index),
      ),
    );
  }
}
