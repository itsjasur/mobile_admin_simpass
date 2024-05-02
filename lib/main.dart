import 'package:admin_simpass/globals/global_keys.dart';
import 'package:admin_simpass/providers/auth_provider.dart';
import 'package:admin_simpass/providers/myinfo_provider.dart';
import 'package:admin_simpass/providers/menu_navigation_provider.dart';
import 'package:admin_simpass/providers/side_menu_provider.dart';
import 'package:admin_simpass/globals/main_ui.dart';
import 'package:admin_simpass/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthServiceProvider()),
      ChangeNotifierProvider(create: (context) => SideMenuProvider()),
      ChangeNotifierProvider(create: (context) => MyinfoProvifer()),
      ChangeNotifierProvider(create: (context) => MenuIndexProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Simpass Admin',
      routerConfig: appRouter,

      key: rootScaffoldKey,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      debugShowCheckedModeBanner: false,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('en', 'US'), // American English
        Locale('ko', 'KO'), // Korean
        // ...
      ],

      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(), // Optional, ensure this is set properly

      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        colorScheme: const ColorScheme.light(
          // brightness: Brightness.light,
          primary: MainUi.mainColor,
          secondary: MainUi.mainColor,
          background: Colors.white,
        ),

        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.macOS: NoTransitionsBuilder(),
            TargetPlatform.windows: NoTransitionsBuilder(),
          },
        ),
        useMaterial3: true,
        // textTheme: GoogleFonts.notoSansKrTextTheme(Theme.of(context).textTheme),
        // textTheme: GoogleFonts.notoSansKRTextTheme(),
        dividerTheme: DividerThemeData(
          color: Colors.grey.shade200,
          thickness: 0,
        ),

        datePickerTheme: const DatePickerThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          rangePickerBackgroundColor: Colors.transparent,
          rangePickerHeaderForegroundColor: Colors.transparent,
          rangePickerHeaderBackgroundColor: Colors.transparent,
        ),
        timePickerTheme: const TimePickerThemeData(
          backgroundColor: Colors.white,
        ),

        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          showDragHandle: true,
          dragHandleColor: Colors.black12,
        ),
        scaffoldBackgroundColor: Colors.white,

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: Colors.black38,
            disabledForegroundColor: Colors.white70,
            backgroundColor: MainUi.mainColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),

        // menuButtonTheme: const MenuButtonThemeData(style: ButtonStyle(padding: MaterialStatePropertyAll(EdgeInsets.zero))),

        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            backgroundColor: MaterialStatePropertyAll(Colors.amber),
            padding: MaterialStatePropertyAll(
              EdgeInsets.all(1),
            ),
          ),
        ),

        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStatePropertyAll(Colors.grey.withOpacity(0.2)),
          thickness: const MaterialStatePropertyAll(15),
          thumbVisibility: const MaterialStatePropertyAll(true),
          trackVisibility: const MaterialStatePropertyAll(false),
        ),

        checkboxTheme: const CheckboxThemeData(
          // checkColor: MaterialStatePropertyAll(Colors.red),
          side: BorderSide(
            width: 1,
            color: Colors.black26,
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 10),
            disabledBackgroundColor: Colors.black38,
            disabledForegroundColor: Colors.white70,
            foregroundColor: Colors.black87,
            side: const BorderSide(color: Colors.black54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),

        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          width: 400,
        ),
      ),
      // home: const HomePage(),
    );
  }
}

// class NoAnimationPageTransitionsBuilder extends PageTransitionsBuilder {
//   const NoAnimationPageTransitionsBuilder();

//   @override
//   Widget buildTransitions<T>(
//     PageRoute<T> route,
//     BuildContext context,
//     Animation<double> animation,
//     Animation<double> secondaryAnimation,
//     Widget child,
//   ) {
//     return child;
//   }
// }

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();
  @override
  Widget buildTransitions<T>(PageRoute<T>? route, BuildContext? context, Animation<double> animation, Animation<double> secondaryAnimation, Widget? child) {
    return child!;
  }
}
