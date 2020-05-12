import 'package:budairy/view/Help/helpScreen.dart';
import 'package:budairy/view/budget/BudgetUI.dart';
import 'package:budairy/view/diary/AddDiary.dart';
import 'package:budairy/view/settings/SettingsUI.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:toast/toast.dart';

class MainWidget extends StatefulWidget {
  MainWidget({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> with TickerProviderStateMixin {
  KFDrawerController _drawerController;

  var currentBackPressTime;

  @override
  void initState() {
    super.initState();
    _drawerController = KFDrawerController(
      initialPage: BudgetPage(),
      items: [
        KFDrawerItem.initWithPage(
          text: Text('Budget', style: TextStyle(color: Colors.white)),
          icon: Icon(FontAwesomeIcons.rupeeSign, color: Colors.white),
          page: BudgetPage(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Diary',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(FontAwesomeIcons.book, color: Colors.white),
          page: AddDiary(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'SETTINGS',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.settings, color: Colors.white),
          page:Settings(),
        ),
        KFDrawerItem.initWithPage(
          text: Text(
            'Help',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.help, color: Colors.white),
          page:HelpScreen(),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: onWillPop,
        child: KFDrawer(
//        borderRadius: 0.0,
//        shadowBorderRadius: 0.0,
//        menuPadding: EdgeInsets.all(0.0),
//        scrollable: true,
          controller: _drawerController,
          header: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              width: MediaQuery.of(context).size.width * 0.6,
              color: Colors.teal,
            ),
          ),
          footer: KFDrawerItem(
            text: Text(
              'v 0.0.1',
              style: TextStyle(color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromRGBO(255, 255, 255, 1.0), Color.fromRGBO(44, 72, 171, 1.0)],
              tileMode: TileMode.repeated,
            ),
          ),
        ),
      ),
    );
  }
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Toast.show("press back again to exit", context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
      return Future.value(false);
    }
    return Future.value(true);
  }
}