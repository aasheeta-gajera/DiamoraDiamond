
import 'package:daimo/Library/AppColour.dart';
import 'package:flutter/material.dart';
import 'Authentication/Splash.dart';
import 'package:get/get.dart';
import 'Controller/ConnectivityController.dart';
import 'Library/SharedPrefService.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefService.init();
  Get.put(ConnectivityController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColour),
        useMaterial3: true,
      ),
      home: const Splash(),
    );
  }
}
