import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kamachiapp/model/report.dart';

class CompletedReport extends StatefulWidget {
  @override
  _CompletedReportState createState() => _CompletedReportState();
}

class _CompletedReportState extends State<CompletedReport> {
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
    reportQuery = dbRef.reference().orderByChild("status").equalTo("Completed");
    _onReportAddedSubscription =
        reportQuery.onChildAdded.listen(_onReportAdded);
    _onReportChangedSubscription =
        reportQuery.onChildChanged.listen(_onReportUpdated);
  }

  _onReportAdded(Event event) {
    setState(() {
      list.add(new Report.fromSnapshot(event.snapshot));
    });
  }

  void _deleteNote(BuildContext context, Report report, int index) async {
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
                  Divider(height: 5.0),
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
                    onPressed: () => _deleteNote(context, list[index], index),
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
        title: Text('Completed Report'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: showReportList(),
    );
  }
}
