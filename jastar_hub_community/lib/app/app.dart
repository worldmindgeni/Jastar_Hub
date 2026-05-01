import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jastar_hub_community/core/theme/app_theme.dart';
import 'package:jastar_hub_community/core/l10n/app_localizations.dart';
import 'package:jastar_hub_community/core/router/app_router.dart';
import 'package:jastar_hub_community/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:jastar_hub_community/features/auth/data/repositories/auth_repository.dart';
import 'package:jastar_hub_community/features/events/data/repositories/event_repository.dart';
import 'package:jastar_hub_community/features/events/presentation/cubit/events_cubit.dart';
import 'package:jastar_hub_community/features/events/presentation/cubit/recommendations_cubit.dart';
import 'package:jastar_hub_community/features/notifications/data/notifications_repository.dart';
import 'package:jastar_hub_community/features/notifications/presentation/notifications_cubit.dart';
import 'package:jastar_hub_community/app/cubit/app_cubit.dart';

/// Root application widget.
class JastarHubApp extends StatelessWidget {
  const JastarHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider<EventRepository>(
          create: (_) => EventRepository(),
        ),
        RepositoryProvider<NotificationsRepository>(
          create: (_) => NotificationsRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(const AuthCheckRequested()),
          ),
          BlocProvider<EventsCubit>(
            create: (context) => EventsCubit(
              eventRepository: context.read<EventRepository>(),
            )..fetchEvents(),
          ),
          BlocProvider<RecommendationsCubit>(
            create: (context) => RecommendationsCubit(
              eventRepository: context.read<EventRepository>(),
            )..fetchRecommendations(),
          ),
          BlocProvider<NotificationsCubit>(
            create: (context) => NotificationsCubit(
              repository: context.read<NotificationsRepository>(),
            )..fetchNotifications(),
          ),
          BlocProvider<AppCubit>(
            create: (context) => AppCubit()..init(),
          ),
        ],
        child: BlocBuilder<AppCubit, AppState>(
          builder: (context, appState) {
            return MaterialApp.router(
              title: 'Jastar Hub Community',
              debugShowCheckedModeBanner: false,

              // Theme
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: appState.themeMode,

              // Routing
              routerConfig: AppRouter.router,

              // Localization
              locale: appState.locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            );
          },
        ),
      ),
    );
  }
}
