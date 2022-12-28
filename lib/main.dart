import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAhoAEU0Af7SdzQdHDUtQJ9L0SavYa-V-A",
            appId: "1:1012003201460:web:26d3930e85c15c008712e1",
            messagingSenderId: "1012003201460",
            projectId: "instagram-5a05e",
            storageBucket: "instagram-5a05e.appspot.com"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
    //   home: ResponsiveLayout(
    //     mobileScreenLayout: MobileScrenLayout(),
    //     webScreenLayout: WebScreenLayout(),
    //   ),
    // );
  // home: SignupScreen()

  // handles checking of userstate
  home: StreamBuilder(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.active){
        if(snapshot.hasData){
        return const  ResponsiveLayout(
        mobileScreenLayout: MobileScrenLayout(),
        webScreenLayout: WebScreenLayout(),
      );
        }else if(snapshot.hasError){
          return Center(child: Text('${snapshot.error}'));
        }
      }if(snapshot.connectionState == ConnectionState.waiting){
        return const Center(child: CircularProgressIndicator(color: primaryColor)
        );
      }
      return const LoginScreen();
    } 
    
  )
  
  )
  ;} 
}
