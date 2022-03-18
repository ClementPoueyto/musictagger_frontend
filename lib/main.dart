import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:user_repository/user_repository.dart';
import 'app/app.dart';
import 'app/bloc_observer.dart';
import 'package:url_strategy/url_strategy.dart';


Future<void> main() async {

  await DotEnv.dotenv.load(fileName: ".env");

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
          measurementId: "G-J5N1VVBTLF"
      ),
      );
      WidgetsFlutterBinding.ensureInitialized();
      setPathUrlStrategy();
      final authenticationRepository = AuthenticationRepository();
      await authenticationRepository.user.first;

      runApp(App(authenticationRepository: authenticationRepository,userRepository: UserRepository()));
    },
    blocObserver: AppBlocObserver(),
  );
}