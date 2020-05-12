import 'package:budairy/controller/diary/DiaryController.dart';
import 'package:budairy/model/diary/DiaryRecordModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'DiaryEdit.dart';

class AddDiary extends KFDrawerContent {
  @override
  _AddDiaryState createState() => _AddDiaryState(title: 'Flutter Calendar Carousel Example');
}

class _AddDiaryState extends State<AddDiary> with TickerProviderStateMixin {
  String title;

  _AddDiaryState({this.title});


  List<DiaryRecordModel> events=[];
  AnimationController _animationController;
  CalendarController _calendarController;
  DateTime _selectedDate;
  DiaryController dc;
  final dateFormat = DateFormat("MMMM-d-yyyy");

  getRecords(DateTime dateTime) async {
    String dt=dateFormat.format(dateTime);
    List l=dt.split("-");
    events=await dc.getSpecificRecords(l[2], l[0], l[1]);
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();

     dc= new DiaryController();

     getRecords(DateTime.now());

    _selectedDate=DateTime.now();

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
       getRecords(day);
      _selectedDate=day;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last,
      CalendarFormat format) {
  }

  void _onCalendarCreated(DateTime first, DateTime last,
      CalendarFormat format) {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text('Diary'),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: widget.onMenuPressed,

          )),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          _buildButtons(),
          _buildTableCalendar(),

          Stack(
            children: <Widget>[
              Positioned.fill(
                  child: Align(
                      alignment:Alignment.center
                      ,child: Divider(thickness: 2,color: Colors.black45,))),
              Align(
                alignment: Alignment.centerRight,
                child: RaisedButton(
                  color: Colors.pink,
                  shape: CircleBorder(),
                  onPressed: () async {
                    String dt=dateFormat.format(_selectedDate);
                    List l=dt.split("-");
                    await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DiaryEdit(model: DiaryRecordModel(year: l[2],month: l[0],date: l[1],recordId: '',title: '',time: '',notes: '')))
                    );
                    getRecords(_selectedDate);
                  },
                  child: Icon(Icons.add,size: 56,color: Colors.white,),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16.0),
          Expanded(child: events.isEmpty?
          Container(child: Text('No Records'),):
          _buildEventList()),
        ],
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.green[400],
        todayColor: Colors.blue[200],
        markersColor: Colors.redAccent[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle().copyWith(
            color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      initialSelectedDay: _selectedDate,
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }


  Widget _buildEventList() {
    return ListView(
      shrinkWrap: true,
      children: events
          .map((event) =>
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 0.8),
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              title: Text(event.title),
              subtitle: Text(event.time),
              trailing: IconButton(
                icon: Icon(Icons.delete,color: Colors.red,size: 32,),
                onPressed: () async {
                  if(await delete()){
                    dc.deleteRecord(event.recordId);
                    getRecords(_selectedDate);
                  }
                },
              ),
              onTap: () async {
                await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DiaryEdit(model: event))
                );
                getRecords(_selectedDate);
              },
            ),
          ))
          .toList(),
    );
  }


  Widget _buildButtons() {

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left:16.0,right: 16.0,top: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    _calendarController.setSelectedDay(
                      DateTime(_selectedDate.year-1, _selectedDate.month, _selectedDate.day),
                      runCallback: true,
                    );
                  });
                },
              child: Icon(Icons.arrow_back_ios),
              ),

              Text('Year',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
              InkWell(
                onTap: () {
                  setState(() {
                    _calendarController.setSelectedDay(
                      DateTime(_selectedDate.year+1, _selectedDate.month, _selectedDate.day),
                      runCallback: true,
                    );
                  });
                },
                child: Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> delete() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Delete ?'),
        content: new Text("can't be undone "),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Close'),
          ),
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              },
            child: new Text('Delete',style: TextStyle(color: Colors.red),),
          ),
        ],
      ),
    )) ?? false;
  }
}

