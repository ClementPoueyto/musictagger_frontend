import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/bloc/swipe_bloc.dart';


class UsersScreen extends StatelessWidget {
  static const String routeName = '/users';

  static Route route({required User user}) {
    return MaterialPageRoute<dynamic>(
      settings: const RouteSettings(name: routeName),
      builder: (context) => UsersScreen(user: user),
    );
  }

  final User user;

  const UsersScreen({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.9,
            child: Stack(
              children: [
                Hero(
                  tag: 'user_card',
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 45.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(user.photoURL!),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 60,
                    ),
                    child: BlocBuilder<SwipeBloc, SwipeState>(
                      builder: (context, state) {

                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }


                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${user.displayName}, ${user.email}',
                    style: Theme.of(context).textTheme.headline2),

                SizedBox(height: 15),
                Text('About', style: Theme.of(context).textTheme.headline3),

                SizedBox(height: 15),
                Text('Interests', style: Theme.of(context).textTheme.headline3),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
