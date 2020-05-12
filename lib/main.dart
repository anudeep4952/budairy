import 'dart:async';

import 'package:budairy/MainPage.dart';
import 'package:device_id/device_id.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rflutter_alert/rflutter_alert.dart' as ralert;
import 'package:toast/toast.dart';
import 'package:xxtea/xxtea.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Password(),
    );
  }
}

class Password extends StatefulWidget {

  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  String pass;
  TextStyle style = TextStyle(fontStyle: FontStyle.italic,fontSize: 20.0);
  EncryptedSharedPreferences encryptedSharedPreferences;
  String phoneNumber,appName;
  var onTapRecognizer;
  var onTapRecognizer1;

  TextEditingController textEditingController = TextEditingController();

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    encryptedSharedPreferences = EncryptedSharedPreferences();
    this.phoneNumber="918096297339";
    this.appName="BUDIARY";
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("requesting developer"),
          duration: Duration(seconds: 2),
        ));
        new Future.delayed(const Duration(seconds: 2),(){
          requestDeveloper("request for initial password");
        }); //recommend
      };

    onTapRecognizer1 = TapGestureRecognizer()
      ..onTap = () async {
       await encryptedSharedPreferences.setString("password", "");
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text("initial password cleared"),
          duration: Duration(seconds: 2),
        ));
        new Future.delayed(const Duration(seconds: 2),(){
          requestDeveloper("request for new password");
        }); //recommend
      };


    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 70),
          Image(image: AssetImage("assets/images/logo.jpg"),
            height: MediaQuery.of(context).size.height/4,
            width: MediaQuery.of(context).size.width/8,
            )
              ,
              SizedBox(height: 8),

              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: this.appName,
                      style: TextStyle(color: Color.fromRGBO(139,0,0,1), fontSize: 36,fontWeight: FontWeight.bold,letterSpacing:3, )),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: PinCodeTextField(
                    length: 6,
                    textStyle: TextStyle(fontSize: 8),
                    obsecureText: true,
                    animationType:AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      inactiveFillColor: Colors.grey,
                      inactiveColor: Colors.grey,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.white,
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    onCompleted: (v) {
                    },
                    onChanged: (value) {
                      setState(() {
                        currentText = value;
                      });
                    },
                  )
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*incorrect pin" : "",
                  style: TextStyle(color: Colors.red.shade300, fontSize: 15),
                ),
              ),
              SizedBox(
                height: 8,
              ),

              Container(
                margin:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: FlatButton(
                    onPressed: () async {
                      await verifyPassword().then((val){
                        this.pass=val;
                      });
                      if (currentText.length != 6 || currentText != this.pass ) {
                        errorController.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() {
                          hasError = true;
                        });
                      } else {

                     String value=await encryptedSharedPreferences.getString('password');
                       if(value.length==0) {
                        alertWidget();
                       }
                       else {
                         Navigator.of(context).pushReplacement(
                           MaterialPageRoute(builder: (context) =>
                               MainWidget()),
                         );
                       }
                        setState(() {
                          hasError = false;

                        });
                      }
                    },
                    child: Center(
                        child: Text(
                          "VERIFY".toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(-1, 2),
                          blurRadius: 5)
                    ]),
              ),
              SizedBox(
                height: 16,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Didn't have the code? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                    children: [
                      TextSpan(
                          text: "request developer",
                          recognizer: onTapRecognizer,
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 16))
                    ]),
              ),

              SizedBox(height: 16,),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Forgot password ?",
                    style: TextStyle(color: Colors.red, fontSize: 15),
                    children: [
                      TextSpan(
                          text: " request developer ",
                          recognizer: onTapRecognizer1,
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16))
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> requestDeveloper(String msg) async {
    String deviceid = await DeviceId.getID;
    await FlutterOpenWhatsapp.sendSingleMessage(this.phoneNumber, deviceid+"\n\n"+msg);
  }

  Future<String> verifyPassword() async{
    String v;
    String value=await encryptedSharedPreferences.getString('password');
    if(value.length==0){
      String str = await DeviceId.getID;
      String key = DateTime.now().year.toString()+DateTime.now().month.toString()+DateTime.now().day.toString()+DateTime.now().hour.toString();
      String encryptData = xxtea.encryptToString(str, key);
      v=encryptData[0]+encryptData[1]+encryptData[2]+encryptData[24]+encryptData[25]+encryptData[26];
      print(key + " "+ encryptData+" "+v);
      return v;
    }
    else{
     return value;
    }
  }

  alertWidget(){
    String pass1,pass2;
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
                 Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) =>
                    MainWidget()),);
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

}
// export PATH='/home/bazigar/Documents/flutter_linux_v1.12.13 hotfix.8-stable/flutter/bin':$PATH