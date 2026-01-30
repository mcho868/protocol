import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/database/database_provider.dart';
import 'core/services/notification_service.dart';
import 'core/services/auth_service.dart';
import 'features/session/views/dashboard_page.dart';
import 'features/onboarding/views/onboarding_page.dart';
import 'features/auth/views/login_page.dart';
import 'features/settings/providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('PROTOCOL: App Starting...');
  
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('PROTOCOL: No .env file found.');
  }
  
  // Initialize Supabase
  final supabaseUrl = dotenv.env['DATABASE_URL'] ?? '';
  final supabaseAnonKey = dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? '';
  
  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    debugPrint('PROTOCOL: Supabase Initialized.');
  }

  final container = ProviderContainer();
  
  // Initialize Database
  final repository = container.read(localStorageRepositoryProvider);
  debugPrint('PROTOCOL: Initializing Database...');
  await repository.init();
  debugPrint('PROTOCOL: Database Initialized.');

  // Initialize Notifications
  final notifications = container.read(notificationServiceProvider);
  await notifications.init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const ProtocolApp(),
    ),
  );
}

class ProtocolApp extends ConsumerWidget {
  const ProtocolApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);
    final settingsAsync = ref.watch(settingsControllerProvider);

    return MaterialApp(
      title: 'Protocol',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: Colors.black,
          secondary: Colors.black,
          surface: const Color(0xFFF5F5F7),
        ),
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.zero,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F5F7),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
      ),
      home: authStateAsync.when(
        data: (authState) {
          final session = authState.session;
          if (session == null) {
             debugPrint('PROTOCOL: Unauthenticated -> Login Page');
             return const LoginPage();
          }
          
          // Authenticated, check user context
          return settingsAsync.when(
            data: (settings) {
              debugPrint('PROTOCOL: Authenticated. Context: ${settings == null ? 'Missing' : 'Found'}');
              return settings == null ? const OnboardingPage() : const DashboardPage();
            },
            loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
            error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
          );
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) => Scaffold(body: Center(child: Text('Auth Error: $err'))),
      ),
      routes: {
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
