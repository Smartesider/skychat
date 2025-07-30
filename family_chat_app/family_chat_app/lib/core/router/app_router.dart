import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/home/presentation/pages/main_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/chat/presentation/chat_room_page.dart';

// Router provider with auth integration
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      return authState.when(
        data: (user) {
          final isLoggedIn = user != null;
          final isOnAuthRoute = state.uri.path.startsWith('/login') || 
                               state.uri.path.startsWith('/register') || 
                               state.uri.path.startsWith('/onboarding');
          final isOnSplash = state.uri.path == '/splash';

          // If user is logged in and on auth route, redirect to home
          if (isLoggedIn && isOnAuthRoute) {
            return '/home';
          }
          
          // If user is not logged in and trying to access protected route
          if (!isLoggedIn && !isOnAuthRoute && !isOnSplash) {
            return '/onboarding';
          }
          
          return null; // No redirect needed
        },
        loading: () => null, // Don't redirect while loading
        error: (_, __) => '/onboarding', // Redirect to onboarding on error
      );
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Authentication Routes
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

      // Main App Routes
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainPage(),
        routes: [
          // Dashboard tab
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const MainPage(initialTab: 0),
          ),
          // Feed tab
          GoRoute(
            path: '/feed',
            name: 'feed',
            builder: (context, state) => const MainPage(initialTab: 1),
          ),
          // Chat tab
          GoRoute(
            path: '/chat',
            name: 'chat',
            builder: (context, state) => const MainPage(initialTab: 2),
            routes: [
              // Individual chat room
              GoRoute(
                path: '/room/:chatRoomId',
                name: 'chat-room',
                builder: (context, state) {
                  final chatRoomId = state.pathParameters['chatRoomId']!;
                  return ChatRoomPage(chatRoomId: chatRoomId);
                },
              ),
            ],
          ),
          // Profile tab
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const MainPage(initialTab: 3),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
});

// Navigation extensions
extension AppRouter on GoRouter {
  void goToSplash() => go('/splash');
  void goToOnboarding() => go('/onboarding');
  void goToLogin() => go('/login');
  void goToRegister() => go('/register');
  void goToHome() => go('/home');
  void goToDashboard() => go('/home/dashboard');
  void goToFeed() => go('/home/feed');
  void goToChat() => go('/home/chat');
  void goToProfile() => go('/home/profile');
  void goToChatRoom(String chatRoomId) => go('/home/chat/room/$chatRoomId');
}
