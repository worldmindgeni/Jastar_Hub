import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jastar_hub_community/app/app.dart';
import 'package:jastar_hub_community/app/app_bloc_observer.dart';
import 'package:jastar_hub_community/core/network/dio_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API Client
  ApiClient.initialize();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Set up Bloc observer for debugging
  Bloc.observer = AppBlocObserver();

  runApp(const JastarHubApp());
}
