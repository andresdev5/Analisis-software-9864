import 'dart:developer';

import 'package:eco_adventure/presentation/providers/auth_provider.dart';
import 'package:eco_adventure/presentation/providers/destination_provider.dart';
import 'package:eco_adventure/presentation/providers/location_provider.dart';
import 'package:eco_adventure/presentation/providers/review_provider.dart';
import 'package:eco_adventure/presentation/providers/user_provider.dart';
import 'package:eco_adventure/presentation/screens/auth_screen.dart';
import 'package:eco_adventure/presentation/screens/destination_screen.dart';
import 'package:eco_adventure/presentation/screens/edit_profile_screen.dart';
import 'package:eco_adventure/presentation/screens/home_screen.dart';
import 'package:eco_adventure/presentation/screens/login_screen.dart';
import 'package:eco_adventure/presentation/screens/profile_screen.dart';
import 'package:eco_adventure/presentation/screens/register_screen.dart';
import 'package:eco_adventure/presentation/screens/travel_screen.dart';
import 'package:eco_adventure/presentation/screens/travels_screen.dart';
import 'package:eco_adventure/presentation/services/destination_service.dart';
import 'package:eco_adventure/presentation/widgets/navigation_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'presentation/screens/search_screen.dart';
import 'presentation/services/travel_service.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (_, __) => '/home',
    ),
    ShellRoute(
      builder: (context, state, child) {
        final path = state.location.toString().split('/')[1];
        return NavigationLayoutScaffold(path: path, child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/search',
          name: 'search',
          builder: (context, state) => SearchScreen(searchValue: state.queryParameters['searchValue'])
        ),
        GoRoute(
          path: '/destination/:id',
          name: 'destination',
          builder: (context, state) {
            return PlaceScreen(destinationId: state.pathParameters['id']);
          },
        ),
        GoRoute(
          path: '/travels',
          name: 'travels',
          builder: (context, state) {
            return TravelsScreen();
          },
        ),
        GoRoute(
          path: '/travel/:id',
          name: 'travel',
          builder: (context, state) {
            final id = state.pathParameters['id'];
            return TravelScreen(travelId: id);
          },
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
          routes: [
            GoRoute(
              path: 'profile-edit',
              name: 'profile-edit',
              builder: (context, state) => const EditProfileScreen(),
            ),
          ]),
      ],
    ),
    GoRoute(
      path: '/auth',
      name: 'auth',
      builder: (context, state) => const AuthScreen()
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: LoginScreen(),
      ),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: RegisterScreen(),
      ),
    ),
  ],
  redirect: (BuildContext context, state) async {
    final authProvider = context.read<AuthProvider>();
    bool loggedIn = await authProvider.isLoggedIn();

    if (!loggedIn) {
      return (state.location == '/login' || state.location == '/register') ? null : '/auth';
    }

    if (loggedIn && (state.location == '/' || state.location == '/auth')) {
      return '/home';
    }

    return null;
  },
);

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 22, 160, 133),
    ),
  );

  return runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
            create: (_) => UserProvider(),
            update: (_, authProvider, userProvider) => UserProvider(authProvider: authProvider)),
        ChangeNotifierProxyProvider<AuthProvider, LocationProvider>(
            create: (_) => LocationProvider(),
            update: (_, authProvider, userProvider) => LocationProvider(authProvider: authProvider)),
        ChangeNotifierProxyProvider<AuthProvider, DestinationProvider>(
            create: (_) => DestinationProvider(),
            update: (_, authProvider, destinationProvider) => DestinationProvider(authProvider: authProvider)),
        ChangeNotifierProxyProvider<AuthProvider, ReviewProvider>(
            create: (_) => ReviewProvider(),
            update: (_, authProvider, reviewProvider) => ReviewProvider(authProvider: authProvider)),
        ProxyProvider<AuthProvider, TravelService>(
          update: (_, authProvider, __) => TravelService(authProvider: authProvider)),
        ProxyProvider<AuthProvider, DestinationService>(
          update: (_, authProvider, __) => DestinationService(authProvider: authProvider)),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _router,
        builder: (context, child) {
          final mediaQueryData = MediaQuery.of(context);
          final scale = mediaQueryData.textScaleFactor.clamp(0.7, 1.0);

          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 0.85),
            child: child!,
          );
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ));
  }
}
