import 'package:firebase_core/firebase_core.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:music_tagger/home/home.dart';
import 'app/bloc/app_bloc.dart';
import 'app/bloc_observer.dart';
import 'app/view/app.dart';
import 'config/theme.dart';
import 'login/view/login_page.dart';

Future<void> main() async {
  return BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBK57uo9i34cf2G3XcpD_s7SwYeII-GzMc",
            authDomain: "music-tagger-f7265.firebaseapp.com",
            projectId: "music-tagger-f7265",
            storageBucket: "music-tagger-f7265.appspot.com",
            messagingSenderId: "744335785673",
            appId: "1:744335785673:web:820dc6802be6ddc2529718",
            measurementId: "G-J5N1VVBTLF"),
      );
      final authenticationRepository = AuthenticationRepository();
      await authenticationRepository.user.first;
      runApp(App(authenticationRepository: authenticationRepository));
    },
    blocObserver: AppBlocObserver(),
  );
}


