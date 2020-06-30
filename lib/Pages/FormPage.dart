import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kamachiapp/Services/authentication.dart';
import 'package:kamachiapp/model/report.dart';

class FormPage extends StatefulWidget {
  FormPage({Key key, this.auth, this.userId, this.logoutCallback, this.report})
      : super(key: key);
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final Report report;
  @override
  _FormPageState createState() => _FormPageState();
}

final dbRef = FirebaseDatabase.instance;

class _FormPageState extends State<FormPage> {
  TextEditingController dateofcompcontroller;
  TextEditingController compcontroller;
  TextEditingController usercontroller;
  TextEditingController attendcontroller;
  TextEditingController duracontroller;
  TextEditingController actioncontroller;
  TextEditingController statuscontroller;
  TextEditingController stdatecontroller;
  TextEditingController remarkcontroller;
  TextEditingController changecontroller;
  DateTime date;
  DateTime _date;

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    _date = DateTime.now();
    dateofcompcontroller =
        TextEditingController(text: widget.report.dateofcomplaint);
    compcontroller = TextEditingController(text: widget.report.complaint);
    usercontroller = TextEditingController(text: widget.report.username);
    attendcontroller = TextEditingController(text: widget.report.attendedby);
    duracontroller = TextEditingController(text: widget.report.duration);
    actioncontroller = TextEditingController(text: widget.report.actiontaken);
    statuscontroller = TextEditingController(text: widget.report.status);
    stdatecontroller = TextEditingController(text: widget.report.statusdate);
    remarkcontroller = TextEditingController(text: widget.report.remarks);
    changecontroller = TextEditingController(text: widget.report.changes);
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
                      value: dropDownValue,
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
                      onChanged: (String newValue) {
                        setState(() {
                          dropDownValue = newValue;
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Select a Department';
                        }
                        return null;
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
                      value: dropDownValue1,
                      icon: Icon(Icons.arrow_downward),
                      decoration: InputDecoration(
                        labelText: "Nature of Complaints",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      items: listofComplaints.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          dropDownValue1 = newValue;
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Select a nature of complaint';
                        }
                        return null;
                      },
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
                    child: TextFormField(
                      controller: duracontroller,
                      decoration: InputDecoration(
                          labelText: 'Duration',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: TextFormField(
                      controller: actioncontroller,
                      decoration: InputDecoration(
                          labelText: 'Action Taken',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: DropdownButtonFormField(
                      value: dropDownValue2,
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
                      onChanged: (String newValue) {
                        setState(() {
                          dropDownValue2 = newValue;
                        });
                      },
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
                      controller: remarkcontroller,
                      decoration: InputDecoration(
                          labelText: 'Remarks',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(25.0),
                    child: TextFormField(
                      controller: changecontroller,
                      decoration: InputDecoration(
                          labelText: 'Changes if Any',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Builder(
                      builder: (context) => RaisedButton(
                        child: (widget.report.key != null)
                            ? Text('Update',
                                style: TextStyle(color: Colors.white))
                            : Text(
                                'Add',
                                style: TextStyle(color: Colors.white),
                              ),
                        color: Colors.blueAccent,
                        onPressed: () {
                          if (widget.report.key != null) {
                            dbRef
                                .reference()
                                .child("reports")
                                .child(widget.report.key)
                                .set({
                              "date": dateofcompcontroller.text.toString(),
                              "complaint": compcontroller.text.toString(),
                              "department": dropDownValue.toString(),
                              "username": usercontroller.text.toString(),
                              "nature of complaints": dropDownValue1.toString(),
                              "attended by": attendcontroller.text.toString(),
                              "duration": duracontroller.text.toString(),
                              "action taken": actioncontroller.text.toString(),
                              "status": dropDownValue2.toString(),
                              "status date": stdatecontroller.text.toString(),
                              "remarks": remarkcontroller.text.toString(),
                              "changes if any":
                                  changecontroller.text.toString(),
                              "userId": widget.userId
                            }).then((_) {
                              Navigator.pop(context);
                            });
                          } else {
                            dbRef.reference().child("reports").push().set({
                              "date": dateofcompcontroller.text.toString(),
                              "complaint": compcontroller.text.toString(),
                              "department": dropDownValue.toString(),
                              "username": usercontroller.text.toString(),
                              "nature of complaints": dropDownValue1.toString(),
                              "attended by": attendcontroller.text.toString(),
                              "duration": duracontroller.text.toString(),
                              "action taken": actioncontroller.text.toString(),
                              "status": dropDownValue2.toString(),
                              "status date": stdatecontroller.text.toString(),
                              "remarks": remarkcontroller.text.toString(),
                              "changes if any":
                                  changecontroller.text.toString(),
                              "userId": widget.userId
                            }).then((_) {
                              Navigator.pop(context);
                            });
                          }
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
