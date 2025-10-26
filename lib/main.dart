import 'package:flutter/material.dart';
import 'package:rip_college_app/screens/views/base_screen/calendar_screen.dart';
import 'package:rip_college_app/screens/views/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
 
Future<void> main() async {
  // Ensure widgets are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://fecmtybgfvrnurwxbjog.supabase.co/',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZlY210eWJnZnZybnVyd3hiam9nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc2MDU2NjksImV4cCI6MjA1MzE4MTY2OX0.bf-72P5iaRPH9fl6lDM_cz8cjP4cWlpshVYL9HIagWA', // Replace with your Supabase Anon Key
  );


  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotifications(); 

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(                                                                       
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.themeMode,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}


