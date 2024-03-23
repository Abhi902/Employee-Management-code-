import 'package:CompanyDatabase/Pages/password.dart';
import 'package:CompanyDatabase/Provider/employee_provider.dart';
import 'package:CompanyDatabase/Provider/selected_page.dart';
import 'package:CompanyDatabase/firebase_options.dart';
import 'package:CompanyDatabase/utils/contants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'Pages/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "CompanyDatabase",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SelectedPageIndexProvider(),
          child: MyApp(), // Your app's root widget
        ),
        ChangeNotifierProvider(
          create: (context) => CommonFormProvider(),
          child: MyApp(), // Your app's root widget
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 748),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          canvasColor: Colors.white,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: themeColor,
            secondary: const Color(0xFFFFC107),
          ),
        ),
        home: PasswordVerifier(),
      ),
    );
  }
}
