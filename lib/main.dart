import 'package:flutter/material.dart';

import './my_strings.dart';
import './new_gallery_page.dart' as newPage;
import './popular_gallery_page.dart' as popularPage;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gallery Flutter',
        debugShowCheckedModeBanner: false,
        home: MyGalleryPage()
    );
  }
}

class MyGalleryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyGalleryState();
}

class MyGalleryState extends State<MyGalleryPage> with SingleTickerProviderStateMixin{
  TabController controller ;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Material(
        color: Colors.white,
        child: TabBar(
          controller: controller,
          labelColor: Color(0xffed5992),
          unselectedLabelColor: Colors.grey,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.description),
              text: MyStrings.newPage,
            ),
            Tab(
              icon: Icon(Icons.whatshot),
              text: MyStrings.popularPage,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          newPage.NewGalleryPage(),
          popularPage.PopularGalleryPage(),
        ],
      ),
    );
  }
}

// todo сделать pool refresh;
// todo check connect;
// todo result connect;
// todo pagination;
// todo cash image;
// todo more details ui;
// //todo мб переделать как тут https://flutter.io/docs/cookbook/networking/background-parsing
// contact list пример
// todo исправить и понять почему миллион запросов отправляется

