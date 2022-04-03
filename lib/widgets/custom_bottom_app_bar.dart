import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:music_tagger/router/routes.gr.dart';

class AutoTabsScaffoldPage extends StatelessWidget {
  const AutoTabsScaffoldPage({Key? key}) : super(key: key);


  @override
  Widget build(context) {
    return AutoTabsScaffold(
      routes:  [
         HomeRouter(),
        TagRouter(),
        ProfileRouter()
      ],

    bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          backgroundColor: Colors.indigo,
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tag),
              label: 'Tags',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: 'Profile',
            ),
          ],
        );
      },
    );
  }
}