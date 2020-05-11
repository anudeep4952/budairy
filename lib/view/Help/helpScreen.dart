import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';

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
 String contact="Gadi Srinivasa Sai Anudeep \nanudeep.insvirat@gmail.com \n8096297339";
 String updates="For updates keep visiting \nhttps://github.com/anudeep4952/budairyApk";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
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
                    helpWidget('Contact', contact),
                    SizedBox(height: 24,),
                    helpWidget('Updates', updates)
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

}
