import "package:flutter/material.dart";
import "package:sansadtv_app/home_screen.dart";
import "package:sansadtv_app/live_player_screen.dart";

void main() {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const STVApp());
}

class STVApp extends StatelessWidget {
  const STVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const STVHomeScreen(),
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(148, 43, 114, 1),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
