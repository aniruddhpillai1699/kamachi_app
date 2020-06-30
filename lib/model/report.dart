import 'package:firebase_database/firebase_database.dart';

class Report {
  String key;
  String dateofcomplaint;
  String complaint;
  String department;
  String username;
  String natureofcomplaints;
  String attendedby;
  String duration;
  String actiontaken;
  String status;
  String statusdate;
  String remarks;
  String changes;
  String userId;
  String token;

  Report(
      this.dateofcomplaint,
      this.complaint,
      this.department,
      this.username,
      this.natureofcomplaints,
      this.attendedby,
      this.duration,
      this.actiontaken,
      this.status,
      this.statusdate,
      this.remarks,
      this.changes,
      this.userId,
      this.token);

  Report.map(dynamic obj) {
    this.dateofcomplaint = obj["date"];
    this.complaint = obj["complaint"];
    this.department = obj["department"];
    this.username = obj["username"];
    this.natureofcomplaints = obj["nature of complaints"];
    this.attendedby = obj["attended by"];
    this.duration = obj["duration"];
    this.actiontaken = obj["action taken"];
    this.status = obj["status"];
    this.statusdate = obj["status date"];
    this.remarks = obj["remarks"];
    this.changes = obj["changes"];
    this.userId = obj["userId"];
    this.token = obj["token"];
  }

  // get _key => key;
  //get _date => date;
  //get _complaint => complaint;
  // String get _department => department;
  //get _username => username;
  //String get _natureofcomplaints => natureofcomplaints;
  //get _attendedby => attendedby;
  //get _duration => duration;
  //get _actiontaken => actiontaken;
  //String get _status => status;
  // get _statusdate => statusdate;
  //get _remarks => remarks;
  //get _changes => changes;

  Report.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    dateofcomplaint = snapshot.value["date"];
    complaint = snapshot.value["complaint"];
    department = snapshot.value["department"];
    username = snapshot.value["username"];
    natureofcomplaints = snapshot.value["nature of complaints"];
    attendedby = snapshot.value["attended by"];
    duration = snapshot.value["duration"];
    actiontaken = snapshot.value["action taken"];
    status = snapshot.value["status"];
    statusdate = snapshot.value["status date"];
    remarks = snapshot.value["remarks"];
    changes = snapshot.value["changes if any"];
    userId = snapshot.value["userId"];
    token = snapshot.value["token"];
  }

  toJson() {
    return {
      "date": dateofcomplaint,
      "complaint": complaint,
      "department": department,
      "username": username,
      "nature of complaints": natureofcomplaints,
      "attended by": attendedby,
      "duration": duration,
      "action taken": actiontaken,
      "status": status,
      "status date": statusdate,
      "remarks": remarks,
      "changes if any": changes,
      "userId": userId,
      "token": token
    };
  }
}
