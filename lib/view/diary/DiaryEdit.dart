import 'package:budairy/controller/diary/DiaryController.dart';
import 'package:budairy/model/diary/DiaryRecordModel.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toast/toast.dart';

class DiaryEdit extends StatefulWidget {
  final DiaryRecordModel model;

  DiaryEdit({this.model});

  @override
  _DiaryEditState createState() => _DiaryEditState();
}

class _DiaryEditState extends State<DiaryEdit> {
  String title, notes;
  DiaryController dc;
  bool _readonly;

  FocusNode _focusNode;

  DiaryRecordModel drm;

  @override
  void initState() {
    super.initState();
    dc = new DiaryController();
    drm = widget.model;
    this.title = drm.title;
    this.notes = drm.notes;
    _focusNode = new FocusNode();
    this.drm.recordId.length==0 ? _readonly = false:_readonly=true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(!_readonly) {
          if(this.title.length==0 && this.notes.length==0){
          FocusScope.of(context).requestFocus(FocusNode());
          return true;
          }
       else{
         FocusScope.of(context).unfocus();
        String opt= await _onWillPop();
        if(opt=="save" || opt=="discard")
          return true;
        if (opt=="close")
          return false;
          }
        }
        else{
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            drm.year + "," + drm.month + " " + drm.date,
            textScaleFactor: 2,
            style: TextStyle(fontSize: 12),
          ),
          backgroundColor: Colors.green,
          actions: <Widget>[
            _readonly
                ? Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        iconSize: 36,
                        onPressed: () {
                          _readonly = false;
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        iconSize: 36,
                        onPressed: () {
                          _shareText(this.title, this.notes);
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete,color: Colors.white,),
                        iconSize: 36,
                        onPressed: () async {
                          if(await deleteAlertWidget()){
                          String msg= await dc.deleteRecord(drm.recordId);
                          Toast.show(msg, context,
                              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                          Navigator.of(context).pop();
                        }
                          },
                      )
                    ],
                  )
                : IconButton(
                    icon: Icon(Icons.save),
                    iconSize: 36,
                    onPressed: () async {

                      if(title.length==0 && notes.length==0)
                        {
                          Toast.show('no text to save',context,duration: Toast.LENGTH_LONG,gravity: Toast.CENTER);
                        }
                      else{

                      FocusScope.of(context).requestFocus(FocusNode());
                      if (drm.recordId.length==0){
                      drm = await dc.addRecord(drm.month, drm.date, drm.year,
                      this.title, this.notes);
                      setState(() {
                      _readonly = true;
                      });
                      Toast.show('saved', context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                      }
                      else{
                      drm.title=this.title;
                      drm.notes=this.notes;
                      String msg=await dc.updateRecord(drm);
                      setState(() {
                      _readonly = true;
                      });
                      Toast.show(msg, context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                      }
                      }
                    }
                  )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 32),
                child: TextFormField(
                  initialValue: this.title,
                  maxLength: 50,
                  maxLines: null,
                  readOnly: _readonly,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                  onChanged: (t) => this.title = t,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                      hintStyle: TextStyle(
                        color: Colors.black26,
                        fontSize: 22,
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18, bottom: 18),
                child: TextFormField(
                  maxLines: null,
                  readOnly: _readonly,
                  initialValue: this.notes,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  onChanged: (n) => notes = n,
                  keyboardType: TextInputType.multiline,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Notes',
                      hintStyle: TextStyle(
                        color: Colors.black26,
                        fontSize: 14,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Unsaved Text'),
        content: new Text('Do you want to save ?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop("close"),
            child: new Text('Close'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop("discard"),
            child: new Text('Discard',style: TextStyle(color: Colors.red)),
          ),
          new FlatButton(
            onPressed: () async{

              if(drm.recordId=="")
              await dc.addRecord(drm.month, drm.date, drm.year,
                  this.title, this.notes);
              else {
                drm.title=title;
                drm.notes=notes;
                await dc.updateRecord(drm);
              }

              Toast.show('saved', context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
              Navigator.of(context).pop("save");
            },
            child: new Text('Save',style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    )) ?? false;
  }
  Future<void> _shareText(String title,String notes) async {
    try {
      Share.text(title, notes, 'text/plain');
    } catch (e) {
      print('error: $e');
    }
  }

  Future<bool> deleteAlertWidget() async{
    return Alert(
      context: context,
      closeFunction: (){
        return false;
      },
      type: AlertType.warning,
      title: "Are you sure ?",
      desc: "notes cannot be retrived again",
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
