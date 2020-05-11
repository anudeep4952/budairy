import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:budairy/view/budget/previous.dart';
import 'package:budairy/view/budget/records.dart';
import 'package:budairy/view/budget/usage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kf_drawer/kf_drawer.dart';


class BudgetPage extends KFDrawerContent {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
      title: Text('Budget'),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: widget.onMenuPressed,

      )),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: <Widget>[
            new Usage(),
            new Previous(),
            new Records(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        iconSize: 32,
        showElevation: true,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(FontAwesomeIcons.shoppingCart),
            title: Text('Usage'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.history),
            title: Text('Previous'),
            activeColor: Colors.green,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.layers),
            title: Text('Records'),
            activeColor: Colors.indigo,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

