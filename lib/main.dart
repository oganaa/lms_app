import 'package:flutter/material.dart';
import 'package:lms_app/services/navigation_service.dart';
import 'package:lms_app/ui/router.dart';
import 'package:lms_app/ui/views/canvas.dart';
import 'package:lms_app/ui/views/intro_view.dart';
import 'package:lms_app/ui/views/login_view.dart';
import 'package:lms_app/ui/views/quiz.dart';
import 'package:lms_app/ui/views/quiz/quiz_screen.dart';
import 'dart:io';

import 'package:lms_app/constants.dart';
import 'package:lms_app/screens/room/room.dart';
import 'package:lms_app/screens/room/room_modules.dart';
import 'package:lms_app/screens/welcome/welcome.dart';
import 'package:lms_app/features/signaling/room_client_repository.dart';
import 'package:lms_app/features/me/bloc/me_bloc.dart';
import 'package:lms_app/features/media_devices/bloc/media_devices_bloc.dart';
import 'package:lms_app/features/peers/bloc/peers_bloc.dart';
import 'package:lms_app/features/producers/bloc/producers_bloc.dart';
import 'package:lms_app/features/room/bloc/room_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_string/random_string.dart';
import 'locator.dart';

import 'app_modules/app_modules.dart';
class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new DevHttpOverrides();
  setupLocator();
  runApp(
    MultiBlocProvider(
      providers: getAppModules(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      navigatorKey: locator<NavigationService>().navigationKey,
      // home: QuistionScreen(),
      // home: QuizScreen(),
      home: Welcome(),
      // initialRoute: '/',
      // home: Slide(),
      // home: CanvasPainting(),QuizScreen
      //IntroView(),
      onGenerateRoute: generateRoute,
    );
  }
}

