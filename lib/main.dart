import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/bloc_observer.dart';
import 'app/view/app.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  return BlocOverrides.runZoned(
    () async {
      try {
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp(name:kIsWeb?null:"mobile",
          options: FirebaseOptions(
              apiKey: "AIzaSyBK57uo9i34cf2G3XcpD_s7SwYeII-GzMc",
              authDomain: "music-tagger-f7265.firebaseapp.com",
              projectId: "music-tagger-f7265",
              storageBucket: "music-tagger-f7265.appspot.com",
              messagingSenderId: "744335785673",
              appId: "1:744335785673:web:820dc6802be6ddc2529718",
              measurementId: "G-J5N1VVBTLF"),
        );
      } on Exception catch (e) {
        print(e);
      }

      final authenticationRepository = AuthenticationRepository();
      await authenticationRepository.user.first;
      runApp(App(authenticationRepository: authenticationRepository));
    },
    blocObserver: AppBlocObserver(),
  );
}
