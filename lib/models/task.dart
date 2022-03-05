class Task
{

  late String userID;
late String title;
late String time;
late String date;
bool isChecked ;
late String docName;

Task({
  required this.title,
  required this.time,
  required this.date,
  required this.docName,
  this.isChecked = false,
});

}

