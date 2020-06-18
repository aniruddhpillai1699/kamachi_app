import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kamachiapp/Drawer/completed_report.dart';
import 'package:kamachiapp/Drawer/pending_report.dart';
import 'package:kamachiapp/Pages/FormPage.dart';
import 'package:kamachiapp/Services/authentication.dart';
import 'package:kamachiapp/model/report.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Report> list;
  final dbRef = FirebaseDatabase.instance.reference().child("Report");
  StreamSubscription<Event> _onReportAddedSubscription;
  StreamSubscription<Event> _onReportChangedSubscription;
  Query reportQuery;
  @override
  void initState() {
    super.initState();

    //_checkEmailVerification();

    list = new List();
    reportQuery = dbRef
        .reference()
        .child("Report")
        .orderByChild("complaint")
        .equalTo("Av");
    _onReportAddedSubscription = dbRef.onChildAdded.listen(_onReportAdded);
    _onReportChangedSubscription =
        dbRef.onChildChanged.listen(_onReportUpdated);
  }

  _onReportAdded(Event event) {
    setState(() {
      list.add(new Report.fromSnapshot(event.snapshot));
    });
  }

  void _deleteReport(BuildContext context, Report report, int index) async {
    await dbRef.child(report.key).remove().then((_) {
      setState(() {
        list.removeAt(index);
      });
    });
  }

  _onReportUpdated(Event event) {
    var oldNoteValue =
        list.singleWhere((note) => note.key == event.snapshot.key);
    setState(() {
      list[list.indexOf(oldNoteValue)] =
          new Report.fromSnapshot(event.snapshot);
    });
  }

  @override
  void dispose() {
    _onReportAddedSubscription.cancel();
    _onReportChangedSubscription.cancel();
    super.dispose();
  }

  Widget showReportList() {
    if (list.length > 0) {
      return ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Date of Complaint: " + list[index].date)),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                          'Complaint Registered By: ' + list[index].complaint)),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Department:' + list[index].department)),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Username:' + list[index].username)),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Nature of Complaint: ' +
                        list[index].natureofcomplaints),
                  ),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Attended By: ' + list[index].attendedby)),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Duration: ' + list[index].duration)),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Action Taken: ' + list[index].actiontaken)),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Status: ' + list[index].status)),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Status Date: ' + list[index].statusdate)),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Remarks:' + list[index].remarks)),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Changes If Any: ' + list[index].changes)),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteReport(context, list[index], index),
                  )
                ],
              ),
            ),
          );
        },
      );
    } else {
      return Center(
          child: Text(
        "Welcome. Your list is empty",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Kamachi'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: () {
                  showAlertDialog(context);
                })
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/download.png"),
                        fit: BoxFit.cover),
                    color: Colors.blueAccent),
                child: Text(''),
              ),
              Divider(
                height: 10.0,
              ),
              ListTile(
                title: Text('Completed Report'),
                leading: Icon(Icons.report),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompletedReport()));
                },
              ),
              Divider(
                height: 5,
              ),
              ListTile(
                title: Text('Pending Report'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PendingReport()));
                },
                leading: Icon(Icons.report),
              ),
              Divider(
                height: 5,
              )
            ],
          ),
        ),
        body: showReportList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => FormPage()));
          },
          backgroundColor: Colors.blueAccent,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ));
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        signOut();
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Log Out"),
      content: Text("Do you want to Log Out?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }
}
