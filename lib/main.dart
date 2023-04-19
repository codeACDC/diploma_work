import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  try {
    List<CameraDescription> listOfCameras = await availableCameras();
    runApp(MyApp(cameras: listOfCameras));
  } on CameraException catch (e) {
    debugPrint('Error: $e.code');
  }

}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 786),
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: MyHomePage(cameras: cameras),
        );
      },
    );
  }
}
