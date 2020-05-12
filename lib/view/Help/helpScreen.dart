import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends KFDrawerContent {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  String version = "0.0.1";
  String localBackup =
      "When the local backup is invoked all the records will be stored in a file 'backup.json' in the downloads folder. This option is applicable only for android users.";
  String shareBackup =
      "When the share backup is invoked all the records can be shared as a file 'backup.json' . Later download this file to perform backup";
  String backup =
      "Click on load backup and select the 'backup.json' file. All your records will be restored. This is used when your moving to a new device ";
 String mailid="anudeep.insvirat@gmail.com";
 String updates="https://github.com/anudeep4952/budiaryApk";
 String mailto="mailto:anudeep.insvirat@gmail.com?subject=BUDIARY";


  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text('Help'),
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: widget.onMenuPressed,
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                    Text('Version : v$version'),
                    SizedBox(height: 24,),
                    helpWidget('Share Backup', shareBackup),
                    SizedBox(height: 24,),
                    helpWidget('Local Backup', localBackup),
                    SizedBox(height: 24,),
                    helpWidget('Load Backup', backup),
                    SizedBox(height: 24,),
                    GestureDetector(
                      child:helpWidget1('Contact', mailid),
                    onTap: () async {
                        if (await canLaunch(mailto)) {
                      await launch(mailto);
                      }
                    },),
                    SizedBox(height: 24,),
                GestureDetector(
                  child:helpWidget1('For updates visit', updates),
                  onTap: ()async {
                    if (await canLaunch(updates)) {
                      await launch(updates);
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }

  helpWidget(String label,String matter){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label,style:TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16)),
        Row(
          mainAxisSize:MainAxisSize.max,
          children: <Widget>[
            Expanded(child: RichText(text: TextSpan(text: matter,style:TextStyle(color: Colors.black54, fontSize: 15,)),textAlign: TextAlign.justify,
            )
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Divider(thickness: 2,)
      ],
    );
  }

  helpWidget1(String label,String matter){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label,style:TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16)),
        Row(
          mainAxisSize:MainAxisSize.max,
          children: <Widget>[
            Expanded(child: RichText(text: TextSpan(text: matter,style:TextStyle(color: Colors.blue, fontSize: 15,)),textAlign: TextAlign.justify,
            )
            ),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Divider(thickness: 2,)
      ],
    );
  }

}
