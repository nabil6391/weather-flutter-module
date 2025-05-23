import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_profile_app/common/services/startup_service.dart';
import 'package:weather_profile_app/features/dashboard/domain/weather_provider.dart';
import 'package:weather_profile_app/features/user_profile/domain/user_provider.dart';

import 'common/network/dio_client.dart';
import 'common/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DioClient>(
          create: (_) => DioClient(),
        ),
        ChangeNotifierProxyProvider<DioClient, WeatherProvider>(
          create: (_) => WeatherProvider(null),
          // Provide a default or initial value
          update: (_, dioClient, previousWeatherProvider) {
            return previousWeatherProvider?.updateDioClient(dioClient) ??
                WeatherProvider(dioClient);
          },
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
      ],
      builder: (context, child) {
        StartupService.initializeNativeCommunication(context);

        return MaterialApp.router(
          title: 'Weather Profile App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
