import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:vchat/providers/auth_provider.dart';
import 'package:vchat/providers/theme_provider.dart';
import 'package:vchat/screens/home/home.dart';
import 'package:vchat/screens/get_started.dart';
import 'package:vchat/styles/styles.dart';

// Author : Kausik at 2.44am Nov 19, 2021

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Trying to get the existing darkMode data from local db
  const themeId = "isDark#123";
  final sharedPref = await SharedPreferences.getInstance();
  final isDark = sharedPref.getBool(themeId);

  // Try to get the existing signed user data
  const userDbId = "s_userid";
  final curUserId = sharedPref.getString(userDbId);

  // Initialise the ThemeProvider
  ThemeProvider.init(isDark);
  AuthProvider.init(curUserId);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// Providers
final themeProvider = ChangeNotifierProvider((ref) => ThemeProvider());
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
              home: Consumer(
                builder: (context, ref, _) {
                  final userId = ref.watch(authProvider).curUserId;
                  if (userId == null) {
                    return const GetStartedPage();
                  } else {
                    return const Home();
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}

// class _Splash extends StatelessWidget {
//   const _Splash({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: CupertinoActivityIndicator(radius: 20),
//       ),
//     );
//   }
// }
