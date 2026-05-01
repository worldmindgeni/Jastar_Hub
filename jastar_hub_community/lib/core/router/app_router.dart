import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jastar_hub_community/app/shell_page.dart';
import 'package:jastar_hub_community/features/auth/presentation/pages/splash_page.dart';
import 'package:jastar_hub_community/features/auth/presentation/pages/onboarding_page.dart';
import 'package:jastar_hub_community/features/auth/presentation/pages/login_page.dart';
import 'package:jastar_hub_community/features/auth/presentation/pages/register_page.dart';
import 'package:jastar_hub_community/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:jastar_hub_community/features/home/presentation/pages/home_page.dart';
import 'package:jastar_hub_community/features/events/presentation/pages/events_page.dart';
import 'package:jastar_hub_community/features/events/presentation/pages/event_details_page.dart';
import 'package:jastar_hub_community/features/profile/presentation/pages/profile_page.dart';
import 'package:jastar_hub_community/features/profile/presentation/pages/public_user_profile_page.dart';
import 'package:jastar_hub_community/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:jastar_hub_community/features/profile/presentation/pages/settings_page.dart';
import 'package:jastar_hub_community/features/map/presentation/pages/map_page.dart';
import 'package:jastar_hub_community/features/chat/presentation/pages/chat_page.dart';
import 'package:jastar_hub_community/features/chat/presentation/pages/chat_details_page.dart';
import 'package:jastar_hub_community/features/notifications/presentation/notifications_page.dart';
import 'package:jastar_hub_community/features/events/presentation/pages/create_event_page.dart';
import 'package:jastar_hub_community/features/admin/presentation/pages/admin_page.dart';
import 'package:jastar_hub_community/shared/models/event_model.dart';

/// Application router using GoRouter with ShellRoute for bottom navigation.
class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // ─── Auth Routes (no bottom nav) ──────────────────────
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: '/user/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PublicUserProfilePage(userId: id);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/create-event',
        builder: (context, state) => const CreateEventPage(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminPage(),
      ),

      // ─── Main App Routes (with bottom nav) ────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ShellPage(
            currentIndex: navigationShell.currentIndex,
            onTabChanged: (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
            child: navigationShell,
          );
        },
        branches: [
          // Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          // Events
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/events',
                builder: (context, state) => const EventsPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final event = state.extra as EventModel;
                      return EventDetailsPage(event: event);
                    },
                  ),
                ],
              ),
            ],
          ),
          // Map
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/map',
                builder: (context, state) => const MapPage(),
              ),
            ],
          ),
          // Chat
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chat',
                builder: (context, state) => const ChatPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final partnerId = state.pathParameters['id']!;
                      final extra = state.extra as Map<String, dynamic>? ?? {};
                      return ChatDetailsPage(
                        partnerId: partnerId,
                        partnerName: extra['partnerName'] ?? 'Unknown',
                        partnerAvatarUrl: extra['partnerAvatarUrl'] ?? '',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
