import 'package:firebase_database/firebase_database.dart';

class Report {
  String key;
  String date;
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

  Report(
      this.key,
      this.date,
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
      this.changes);

  Report.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    date = snapshot.value["date"];
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
  }
  toJson() {
    return {
      "date": date,
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
    };
  }
}
