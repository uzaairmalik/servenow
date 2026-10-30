import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/catalog_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/main_shell.dart';

/// ServeNow entry point.
///
/// Architecture in one line: screens -> providers -> ApiService ->
/// JSON (mock) / HTTP (production). See README.md for the diagram.
///
/// Auth gating lives here and nowhere else: logged out -> AuthScreen,
/// logged in -> MainShell. No screen has to check "am I logged in?"
void main() {
  runApp(const ServeNowApp());
}

class ServeNowApp extends StatelessWidget {
  const ServeNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CatalogProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: Consumer2<ThemeProvider, AuthProvider>(
        builder: (context, theme, auth, _) {
          return MaterialApp(
            title: 'ServeNow',
            debugShowCheckedModeBanner: false,
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            themeMode: theme.mode,
            home: auth.isLoggedIn ? const MainShell() : const AuthScreen(),
          );
        },
      ),
    );
  }
}
