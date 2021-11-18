import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:vchat/providers/auth_provider.dart';
import 'package:vchat/providers/theme_provider.dart';
import 'package:vchat/screens/welcome.dart';
import 'package:vchat/styles/styles.dart';

// Author : Kausik at 6.37pm Nov 13, 2021

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Trying to get the existing darkMode data from local db
  final sharedPref = await SharedPreferences.getInstance();
  final isDark = sharedPref.getBool("isDark#123");

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// Providers
final themeProvider = ChangeNotifierProvider((ref) => ThemeProvider(false));
final authProvider = ChangeNotifierProvider((ref) => AuthProvider());




class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Consumer(
          builder: (context, ref, _) {
            final isDark = ref.watch(themeProvider).isDark;
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
              darkTheme: VStyle.darkTheme(),
              theme: VStyle.lightTheme(),
              home: const Welcome(),
            );
          },
        );
      },
    );
  }
}
