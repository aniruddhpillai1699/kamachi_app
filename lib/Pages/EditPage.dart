import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kamachiapp/Services/authentication.dart';
import 'package:kamachiapp/model/report.dart';
import 'package:intl/intl.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key, this.auth, this.userId, this.logoutCallback, this.report})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final Report report;
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController dateofcompcontroller;
  TextEditingController compcontroller;
  TextEditingController departcontroller;
  TextEditingController usercontroller;
  TextEditingController naturecontroller;
  TextEditingController attendcontroller;
  TextEditingController duracontroller;
  TextEditingController actioncontroller;
  TextEditingController statuscontroller;
  TextEditingController stdatecontroller;
  TextEditingController remarkcontroller;
  TextEditingController changecontroller;
  DateTime date;
  DateTime _date;
  final dbRef = FirebaseDatabase.instance;
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  void initState() {
    super.initState();
    date = DateTime.now();
    _date = DateTime.now();
    dateofcompcontroller =
        TextEditingController(text: widget.report.dateofcomplaint);
    compcontroller = TextEditingController(text: widget.report.complaint);
    departcontroller = TextEditingController(text: widget.report.department);
    usercontroller = TextEditingController(text: widget.report.username);
    naturecontroller =
        TextEditingController(text: widget.report.natureofcomplaints);
    attendcontroller = TextEditingController(text: widget.report.attendedby);
    duracontroller = TextEditingController(text: widget.report.duration);
    actioncontroller = TextEditingController(text: widget.report.actiontaken);
    statuscontroller = TextEditingController(text: widget.report.status);
    stdatecontroller = TextEditingController(text: widget.report.statusdate);
    remarkcontroller = TextEditingController(text: widget.report.remarks);
    changecontroller = TextEditingController(text: widget.report.changes);
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);
    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) async {
        print(" onLaunch called ${(msg)}");
      },
      onResume: (Map<String, dynamic> msg) async {
        print(" onResume called ${(msg)}");
      },
      onMessage: (Map<String, dynamic> msg) async {
        showNotification(msg);
        print(" onMessage called ${(msg)}");
      },
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registered');
    });
  }

  showNotification(Map<String, dynamic> msg) async {
    var android = new AndroidNotificationDetails(
      'sdffds dsffds',
      "CHANNEL NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, "Report Edited", "Your Report Edited Successfully", platform);
  }

  update(String token) {
    print('User Token: $token');
    if (widget.report.key != null) {
      dbRef.reference().child("reports/").child(widget.report.key).set({
        "date": dateofcompcontroller.text.toString(),
        "complaint": compcontroller.text.toString(),
        "department": departcontroller.text.toString(),
        "username": usercontroller.text.toString(),
        "nature of complaints": naturecontroller.text.toString(),
        "attended by": attendcontroller.text.toString(),
        "duration": duracontroller.text.toString(),
        "action taken": actioncontroller.text.toString(),
        "status": statuscontroller.text.toString(),
        "status date": stdatecontroller.text.toString(),
        "remarks": remarkcontroller.text.toString(),
        "changes if any": changecontroller.text.toString(),
        "userId": widget.userId,
        "token": token
      }).then((_) {
        Navigator.pop(context);
      });
    }
  }

  pickedDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(1980),
        lastDate: DateTime(2100));
    String formatdate = new DateFormat.yMMMMEEEEd().format(picked);
    dateofcompcontroller.text = formatdate.toString();
    if (picked != null) {
      setState(() {
        date = picked;
      });
    }
  }

  _pickedDate1() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(1980),
        lastDate: DateTime(2100));
    String _formatdate = new DateFormat.yMMMMEEEEd().format(picked);
    stdatecontroller.text = _formatdate.toString();
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  final listofStatus = ["Completed", "Pending"];
  final listofDepartements = [
    "1st Floor",
    "TP Office",
    "4th Floor Marketing",
    "3rd Floor Accounts",
    "3rd Floor Black Gold",
    "3rd Floor Trezerro",
    "Reception",
    "Director",
    "4th Floor IT and Server Room"
  ];
  final listofComplaints = [
    "Intercom",
    "Computer",
    "Printer",
    "OS",
    "VPN",
    "Network",
    "Email",
    "Internet",
    "Power",
    "Network Drive",
    "MS Office",
    "AX 2012",
    "Feebo",
    "Server",
    "Switch",
    "Firewall",
    "CCTV",
    "DVR",
    "NVR",
    "EPBAX",
    "Others"
  ];

  String dropDownValue = '1st Floor';
  String dropDownValue1 = 'Intercom';
  String dropDownValue2 = 'Pending';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IT Incident Report'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Container(
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: ListTile(
                      title: TextFormField(
                        controller: dateofcompcontroller,
                        decoration: InputDecoration(
                            labelText: 'Date of Complaint:',
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      onTap: pickedDate,
                      leading: Icon(Icons.calendar_today),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: compcontroller,
                      decoration: InputDecoration(
                          labelText: 'Complaint Registered By',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: DropdownButtonFormField(
                      value: departcontroller.text,
                      icon: Icon(Icons.arrow_downward),
                      decoration: InputDecoration(
                        labelText: "Department",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      items: listofDepartements.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          departcontroller.text = newValue;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: TextFormField(
                      controller: usercontroller,
                      decoration: InputDecoration(
                          labelText: 'User Name',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: DropdownButtonFormField(
                      value: naturecontroller.text,
                      icon: Icon(Icons.arrow_downward),
                      decoration: InputDecoration(
                        labelText: "Nature of Complaints",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      items: listofComplaints.map((value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          naturecontroller.text = newValue;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: TextFormField(
                      enabled: true,
                      controller: remarkcontroller,
                      decoration: InputDecoration(
                          labelText: 'Remarks',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: TextFormField(
                      enabled: false,
                      controller: attendcontroller,
                      decoration: InputDecoration(
                          labelText: 'Attended By',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: TextFormField(
                      enabled: false,
                      controller: duracontroller,
                      decoration: InputDecoration(
                          labelText: 'Duration',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: TextFormField(
                      enabled: false,
                      controller: actioncontroller,
                      decoration: InputDecoration(
                          labelText: 'Action Taken',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: DropdownButtonFormField(
                      value: statuscontroller.text,
                      icon: Icon(Icons.arrow_downward),
                      decoration: InputDecoration(
                        labelText: "Status",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      items: listofStatus.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: null,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Select a Status';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: ListTile(
                      title: TextFormField(
                        enabled: false,
                        controller: stdatecontroller,
                        decoration: InputDecoration(
                          labelText: 'Status Date: ',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                      onTap: _pickedDate1,
                      leading: Icon(Icons.calendar_today),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: TextFormField(
                      enabled: false,
                      controller: changecontroller,
                      decoration: InputDecoration(
                          labelText: 'Changes if Any',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Builder(
                      builder: (context) => RaisedButton(
                        child: Text('Update',
                            style: TextStyle(color: Colors.white)),
                        color: Colors.blueAccent,
                        onPressed: () {
                          firebaseMessaging.getToken().then((token) {
                            update(token);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
