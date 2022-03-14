import 'package:flutter/widgets.dart';
import 'package:music_tagger/app/app.dart';
import 'package:music_tagger/home/home.dart';
import 'package:music_tagger/login/login.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
  }
}