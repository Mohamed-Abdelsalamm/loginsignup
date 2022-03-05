import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loginsignup/models/task.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<Task> tasks = [
  ];
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;
  bool isChecked = false;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  void addTask(Task newTask) {
    tasks.add(newTask);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(),
      body: ListView.separated(
          itemBuilder: (context, index) => Container(
                color: tasks[index].isChecked ? Colors.black12 : Colors.white,
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35.0,
                      child: Text(
                        '${tasks[index].time}',
                      ),
                    ),
                    SizedBox(
                      width: 25.0,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${tasks[index].title}',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: tasks[index].isChecked
                                  ? TextDecoration.lineThrough
                                  : null),
                        ),
                        Text(
                          '${tasks[index].date}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    IconButton(
                      onPressed: ()async {

                       await FirebaseFirestore.instance
                            .collection('Task')
                            .doc(tasks[index].docName).delete();
                       tasks.removeAt(index);
                       setState(() {

                       });
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.teal,
                      ),
                    ),
                    Checkbox(
                        value: tasks[index].isChecked,
                        onChanged: (bool? value)async {
                          await FirebaseFirestore.instance
                              .collection('Task')
                              .doc(tasks[index].docName)
                              .set({
                            'title':tasks[index].title,
                            'time':tasks[index].time,
                            'date':tasks[index].date,
                            'docName': tasks[index].docName,
                            'isChecked': value,
                          });
                          setState(() {
                            tasks[index].isChecked = value ?? false;
                          });

                        }),
                  ],
                ),
              ),
          separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey,
              ),
          itemCount: tasks.length),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isBottomSheetShown) {
            if(formKey.currentState!.validate()) {
              var task = Task(
                title: titleController.text,
                isChecked: false,
                time: timeController.text,
                date: dateController.text,
                docName: DateTime
                    .now()
                    .millisecondsSinceEpoch
                    .toString(),
              );
              await FirebaseFirestore.instance
                  .collection('Task')
                  .doc(task.docName)
                  .set({
                'title': task.title,
                'time': task.time,
                'date': task.date,
                'isChecked': task.isChecked,
                'docName': task.docName,
              });
              addTask(
                task,
              );
              timeController.clear();
              titleController.clear();
              dateController.clear();
              setState(() {});

              Navigator.pop(context);
              isBottomSheetShown = false;
            } } else {
          scaffoldKey.currentState!.showBottomSheet(

              (context) => Container(
                color: Colors.grey[200],
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                          labelText: 'Task Title',
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Title must not be empty';
                          }
                          return null;
                        },
                        controller: titleController,
                        onFieldSubmitted: (value) {
                          print(value);
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        onTap: () {
                          showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now())
                              .then((value) {
                            timeController.text =
                                value!.format(context).toString();
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.watch_later_outlined),
                          labelText: 'Task Time',
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Time must not be empty';
                          }
                          return null;
                        },
                        controller: timeController,
                        keyboardType: TextInputType.datetime,
                        onFieldSubmitted: (value) {
                          print(value);
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        onTap: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.parse('2022-12-12'),
                          ).then((value) {
                            dateController.text =
                                DateFormat.yMMMd().format(value!);
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                          labelText: 'Task Date',
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Date must not be empty';
                          }
                          return null;
                        },
                        controller: dateController,
                        keyboardType: TextInputType.datetime,
                        onFieldSubmitted: (value) {
                          print(value);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
            isBottomSheetShown = true;
          }
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
