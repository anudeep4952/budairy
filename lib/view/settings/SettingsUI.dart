import 'package:budairy/controller/SettingsController.dart';
import 'package:budairy/model/diary/DiaryRecordModel.dart';
import 'package:budairy/view/widgets/progressbar.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:nice_button/nice_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';
import 'package:rflutter_alert/rflutter_alert.dart' as ralert;

class Settings extends KFDrawerContent {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  List<DiaryRecordModel> x = [];
  var json;
  String path1;
  SettingsController sc;
  bool isLoading=false;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  EncryptedSharedPreferences encryptedSharedPreferences;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            title: Text('Diary'),
            leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: widget.onMenuPressed,
            )),
        body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height*0.8,
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                NiceButton(
                  icon: Icons.backup,
                  text: 'share backup',
                  fontSize: 18,
                  background: Colors.blueGrey,
                  onPressed: () async {
                    Dialogs.showLoadingDialog(context, _keyLoader);
                    await sc.backup();
                    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                    setState(() {

                    });},
                ),
                NiceButton(
                  icon: Icons.phone_android,
                  text: 'local backup',
                  fontSize: 18,
                  background: Colors.blueGrey,
                  onPressed: () async {
                    Dialogs.showLoadingDialog(context, _keyLoader);
                    var msg = await sc.backUpToDevice();
                    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                    Toast.show(msg, context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  },
                ),
                NiceButton(
                  icon:Icons.cloud_download,
                  text: 'load backup',
                  fontSize: 18,
                  background: Colors.blueGrey,
                  onPressed: () async {
                    String _path = await _openFileExplorer();
                    Dialogs.showLoadingDialog(context, _keyLoader);
                    var msg = await sc.getbackup(_path);
                    Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                    Toast.show(msg, context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  },
                ),
                NiceButton(
                  icon: Icons.delete_forever,
                  text: 'clear diary',
                  fontSize: 18,
                  background: Colors.blueGrey,
                  onPressed: () async {
                    bool val=await deleteAlertWidget();
                    if(val) {
                      Dialogs.showLoadingDialog(context, _keyLoader);
                      var msg = await sc.deleteDiaryRecords();
                      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                      Toast.show(msg, context, duration: Toast.LENGTH_LONG,
                          gravity: Toast.BOTTOM);
                    }
                  },
                ),
                NiceButton(
                  icon: Icons.delete_outline,
                  fontSize: 18,
                  background: Colors.blueGrey,
                  text: 'clear budget',
                  onPressed: () async {
                    bool val=await deleteAlertWidget();
                    if(val) {
                      Dialogs.showLoadingDialog(context, _keyLoader);
                      var msg = await sc.deleteBudgetRecords();
                      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
                      Toast.show(msg, context, duration: Toast.LENGTH_LONG,
                          gravity: Toast.BOTTOM);
                    }
                  },
                ),
                NiceButton(
                      icon:Icons.lock,
                      background: Colors.blueGrey,
                      fontSize: 18,
                      text: 'change password',
                      onPressed: () async {
                        alertWidget();
//                        Toast.show("changed", context,duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                      },
                    ),

              ]),
            )));
  }


  Future<String> _openFileExplorer() async {
    String _fileName;
    String _path;
    String _extension;
    bool _loadingPath = false;
    bool _multiPick = false;
    FileType _pickingType = FileType.any;

    setState(() => _loadingPath = true);
    try {
      _path = await FilePicker.getFilePath(
          type: _pickingType,
          allowedExtensions: (_extension?.isNotEmpty ?? false)
              ? _extension?.replaceAll(' ', '')?.split(',')
              : null);
    } on PlatformException catch (e) {
      print(e.details);
    }
    if (!mounted) return "";
    setState(() {
      _loadingPath = false;
      _fileName = _path.split('/').last;
    });
    return _path;
  }

  @override
  void initState() {
    super.initState();
    sc = new SettingsController();
    encryptedSharedPreferences = EncryptedSharedPreferences();
  }

  alertWidget() async {
    String pass1,pass2,current,pass3;
    current=await encryptedSharedPreferences.getString("password");
    return ralert.Alert(
        style: ralert.AlertStyle(
          isCloseButton: false,
          isOverlayTapDismiss: false,
        ),
        context: context,
        title: "change password",
        content: Column(
          children: <Widget>[

            TextField(
              onChanged: (val){
                pass3=val;
              },
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'current password',
              ),
            ),

            TextField(
              onChanged: (val){
                pass1=val;
              },
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'password',
              ),
            ),
            TextField(
              onChanged: (val){
                pass2=val;
              },
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.lock),
                labelText: 'confirm password',
              ),
            ),
          ],
        ),
        buttons: [
          ralert.DialogButton(
            onPressed: () async {
              print(pass1);
              print(pass2);
              if(current!=pass3){
                Toast.show('enter correct current password', context,duration: Toast.LENGTH_LONG,gravity: Toast.TOP);
              }
              else{
              if(pass1!=pass2 ){
                Toast.show('passwords didnt match', context,duration: Toast.LENGTH_LONG,gravity: Toast.TOP);
              }
              else{
                if(pass1==null || pass2==null)
                {
                  Toast.show('password cannot be empty', context,duration: Toast.LENGTH_LONG,gravity: Toast.TOP);
                }
                else
                {
                  if(pass1.length!=6)
                    Toast.show('password should be exact 6 letters', context,duration: Toast.LENGTH_LONG,gravity: Toast.TOP);
                  else{
                    await encryptedSharedPreferences.setString("password", pass1);
                    Toast.show('password chnaged', context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
                    Navigator.of(context).pop();

                  }
                }
              }
            }
              },
            child: Text(
              "change password",
              style: TextStyle(
                  color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

 Future<bool> deleteAlertWidget() async{
   return ralert.Alert(
      context: context,
      closeFunction: (){
        return false;
      },
      type: AlertType.warning,
      title: "Are you sure ?",
      desc: "records cannot be retrived again",
      buttons: [
        DialogButton(
          child: Text(
            "cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: (){ Navigator.pop(context,false);
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "clear",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: (){
            Navigator.pop(context,true);},
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

}
