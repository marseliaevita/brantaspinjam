import 'package:flutter/material.dart';
import 'package:brantaspinjam/services/supabase_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brantaspinjam/screen/login/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brantas Pinjam',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),

        primarySwatch: Colors.blue,

        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          titleTextStyle: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: GoogleFonts.poppins(),
          ),
        ),
      ),

      home: SplashScreen()
    );
  }
}
