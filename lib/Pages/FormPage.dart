import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final dateofcompcontroller = TextEditingController();
  final compcontroller = TextEditingController();
  final departcontroller = TextEditingController();
  final usercontroller = TextEditingController();
  final attendcontroller = TextEditingController();
  final duracontroller = TextEditingController();
  final actioncontroller = TextEditingController();
  final statuscontroller = TextEditingController();
  final stdatecontroller = TextEditingController();
  final remarkcontroller = TextEditingController();
  final changecontroller = TextEditingController();
  DateTime date;
  DateTime _date;
  @override
  void initState() {
    super.initState();
    date = DateTime.now();
    _date = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
    dateofcompcontroller.dispose();
    compcontroller.dispose();
    usercontroller.dispose();
    attendcontroller.dispose();
    duracontroller.dispose();
    actioncontroller.dispose();
    statuscontroller.dispose();
    stdatecontroller.dispose();
    remarkcontroller.dispose();
    changecontroller.dispose();
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
    "4th Floor",
    "3rd Floor Accounts",
    "3rd Floor logistics",
    "3rd Floor IT",
    "Reception",
    "Director"
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
    "Others"
  ];
  String dropDownValue = '1st Floor';
  String dropDownValue1 = 'Intercom';
  String dropDownValue2 = 'Pending';

  final dbRef = FirebaseDatabase.instance.reference().child("Report");

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IT Incident Report'),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
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
                trailing: Icon(Icons.calendar_today),
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
              padding: EdgeInsets.all(25.0),
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
                trailing: Icon(Icons.calendar_today),
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
                  color: Colors.blueAccent,
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      dbRef.push().set({
                        "date": dateofcompcontroller.text,
                        "complaint": compcontroller.text,
                        "department": dropDownValue,
                        "username": usercontroller.text,
                        "nature of complaints": dropDownValue1,
                        "attended by": attendcontroller.text,
                        "duration": duracontroller.text,
                        "action taken": actioncontroller.text,
                        "status": dropDownValue2,
                        "status date": stdatecontroller.text,
                        "remarks": remarkcontroller.text,
                        "changes if any": changecontroller.text
                      }).then((_) async {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Report Successfully Registered',
                            style: TextStyle(color: Colors.white),
                          ),
                          duration: Duration(seconds: 3),
                        ));
                        compcontroller.clear();
                        usercontroller.clear();
                        attendcontroller.clear();
                        duracontroller.clear();
                        actioncontroller.clear();
                        statuscontroller.clear();
                        remarkcontroller.clear();
                        changecontroller.clear();
                      }).catchError((onError) {
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text(onError)));
                        print(onError);
                      });
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
