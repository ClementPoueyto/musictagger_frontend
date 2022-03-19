import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../home/widgets/custom_app_bar.dart';


class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';

  static Route route() {
    return MaterialPageRoute<dynamic>(
      settings: RouteSettings(name: routeName),
      builder: (context) => ProfileScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'PROFILE', function: (){},
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(3, 3),
                      blurRadius: 3,
                      spreadRadius: 3,
                    ),
                  ],

                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.1),
                      Theme.of(context).primaryColor.withOpacity(0.9),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),

                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleWithIcon(title: 'Biography', icon: Icons.edit),

                TitleWithIcon(title: 'Pictures', icon: Icons.edit),
                SizedBox(
                  height: 125,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Container(
                            height: 125,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),

                            ),
                          ),
                        );
                      }),
                ),
                TitleWithIcon(title: 'Location', icon: Icons.edit),
                Text(
                  'Singapore, 1 Suntec City',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(height: 1.5),
                ),
                TitleWithIcon(title: 'Interest', icon: Icons.edit),

              ],
            ),
          )
        ],
      ),
    );
  }
}

class TitleWithIcon extends StatelessWidget {
  final String title;
  final IconData icon;

  const TitleWithIcon({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headline3,
        ),
        IconButton(
          icon: Icon(icon),
          onPressed: () {},
        ),
      ],
    );
  }
}
