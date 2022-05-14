import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:music_tagger/router/routes.gr.dart';

class AutoTabsScaffoldPage extends StatelessWidget {
  const AutoTabsScaffoldPage({Key? key}) : super(key: key);


  @override
  Widget build(context) {
    final theme = Theme.of(context);
    return AutoTabsScaffold(
      routes:  const [
         HomeRouter(),
        TagRouter(),
        ProfileRouter()
      ],

    bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          selectedFontSize: 16,
          unselectedItemColor: theme.colorScheme.primary,
          backgroundColor: theme.primaryColor,
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Tags',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.create),
              label: 'Generation',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: 'Profil',
            ),
          ],
        );
      },
    );
  }
}