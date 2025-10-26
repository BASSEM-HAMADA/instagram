import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled6/Logic_profile_edit/cubit.dart';
import 'package:untitled6/Logic_sign_up/cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled6/ui/Instagram_Profile_Edit.dart';
import 'package:untitled6/ui/home_page.dart';
import 'package:untitled6/ui/sign_in.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://sacheilezjqyzozbncfn.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNhY2hlaWxlempxeXpvemJuY2ZuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcwNzYxNzgsImV4cCI6MjA3MjY1MjE3OH0.SoJs6TANaFw0fWMxvDs9QYUSM7Jy754Kpb29ZR_r1qY",
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignUpCubit(Supabase.instance.client),
        ),
        BlocProvider(
          create: (context) => ProfileEditCubit(Supabase.instance.client),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
        ),
        themeMode: _themeMode,
        home:HomePage(), // دي الشاشة الصح
      ),
    );
  }
}
