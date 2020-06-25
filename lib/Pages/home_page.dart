import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kamachiapp/Pages/FormPage.dart';
import 'package:kamachiapp/model/report.dart';
import 'package:kamachiapp/Services/authentication.dart';

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
  List<Report> list = new List();
  final dbRef = FirebaseDatabase.instance;
  StreamSubscription<Event> _onReportAddedSubscription;
  StreamSubscription<Event> _onReportChangedSubscription;
  Query reportQuery;
  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    list = new List();
    _checkEmailVerification();
    reportQuery = dbRef
        .reference()
        .child("reports")
        .orderByChild("userId")
        .equalTo(widget.userId);
    _onReportAddedSubscription =
        reportQuery.onChildAdded.listen(_onReportAdded);
    _onReportChangedSubscription =
        reportQuery.onChildChanged.listen(_onReportUpdated);
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Verify your account"),
          content: new Text("Please verify account in the link sent to email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Resent link"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            child: AlertDialog(
              title: new Text("Verify your account"),
              content: new Text(
                  "Link to verify account has been sent to your email"),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Dismiss"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            onWillPop: () async => false);
      },
    );
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
                  Divider(height: 5.0),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                          "Date of Complaint: ${list[index].dateofcomplaint}")),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                          'Complaint Registered By: ${list[index].complaint} ')),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Department:${list[index].department}')),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Username: ${list[index].username}')),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                        'Nature of Complaint: ${list[index].natureofcomplaints}'),
                  ),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Attended By: ${list[index].attendedby}')),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Duration: ${list[index].duration}')),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Action Taken: ${list[index].actiontaken}')),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Status: ${list[index].status}')),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Status Date: ${list[index].statusdate}')),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Remarks: ${list[index].remarks}')),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text('Changes If Any: ${list[index].changes}')),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () =>
                            _navigateToReport(context, list[index]),
                      )
                    ],
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
          title: Text('IT Incident Report List'),
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
        body: showReportList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _createNewReport(context),
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

  _onReportAdded(Event event) {
    setState(() {
      list.add(new Report.fromSnapshot(event.snapshot));
    });
  }

  _onReportUpdated(Event event) {
    var oldReportValue =
        list.singleWhere((report) => report.key == event.snapshot.key);
    setState(() {
      list[list.indexOf(oldReportValue)] =
          new Report.fromSnapshot(event.snapshot);
    });
  }

  _navigateToReport(BuildContext context, Report report) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              FormPage(report: report, userId: widget.userId)),
    );
  }

  _createNewReport(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => FormPage(
                report:
                    Report('', '', '', '', '', '', '', '', '', '', '', '', ''),
                userId: widget.userId,
              )),
    );
  }
}
