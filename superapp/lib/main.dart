import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:superapp/core/services/storage_service.dart';
import 'package:superapp/features/auth/bloc/auth_bloc.dart';
import 'package:superapp/features/auth/bloc/auth_event.dart';
import 'package:superapp/features/auth/bloc/auth_state.dart';
import 'package:superapp/features/auth/repository/auth_repository.dart';
import 'package:superapp/features/auth/services/auth_api_service.dart';
import 'package:superapp/features/auth/screens/login_screen.dart';
import 'package:superapp/core/services/api_service.dart';
import 'package:superapp/features/marketplace/bloc/sell_car_bloc.dart';
import 'package:superapp/features/marketplace/repository/marketplace_repository.dart';
import 'package:superapp/features/marketplace/services/marketplace_api_service.dart';
import 'package:superapp/features/bootmnav/bottm_navbar.dart';
import 'package:superapp/core/widgets/app_loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light, // White icons for Android
      statusBarBrightness: Brightness.dark, // White icons for iOS
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(
            authApiService: AuthApiService(),
            storageService: storageService,
          ),
        ),
        RepositoryProvider(
          create: (context) => MarketplaceRepository(
            MarketplaceApiService(apiService),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(CheckAuthEvent()),
          ),
          BlocProvider(
            create: (context) => SellCarBloc(
              context.read<MarketplaceRepository>(),
            ),
          ),
        ],
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: MaterialApp(
            title: 'SuperApp',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'SF-PRO',
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xff000000),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                ),
              ),
            ),
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated || 
                    state is ProfileLoading || 
                    state is ProfileLoaded || 
                    state is ProfileUpdateSuccess) {
                  return const BottomNavBar();
                }
                if (state is AuthUnauthenticated || state is AuthFailure) {
                  return const LoginScreen();
                }
                return const Scaffold(
                  body: Center(
                    child: AppLoading(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
