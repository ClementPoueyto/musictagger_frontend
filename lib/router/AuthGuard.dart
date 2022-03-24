import 'package:auto_route/auto_route.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:music_tagger/router/routes.gr.dart';

class AuthGuard extends AutoRedirectGuard {
  final AuthenticationRepository authenticationRepository = AuthenticationRepository();

  AuthGuard();
  late bool isAuthenticated;

  late UserAuth user;

  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    user = await authenticationRepository.user.first;
  isAuthenticated = user == UserAuth.empty;
    if (!isAuthenticated) {
      print("guard ok");
      resolver.next(true);
    } else {
      print("guard non ok");
      router.navigate(LoginRouter());
    }
  }
}