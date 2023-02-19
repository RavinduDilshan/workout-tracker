import 'package:flutter/material.dart';
import 'package:fresh/data/workout_data.dart';
import 'package:fresh/pages/workout_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//text controller
  final newWorkoutNameController = TextEditingController();

  void createNewWorkout() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('create new dialog'),
              content: TextField(
                controller: newWorkoutNameController,
              ),
              actions: [
                //save button
                MaterialButton(
                  onPressed: save,
                  child: Text('save'),
                ),

                //cancel button
                MaterialButton(
                  onPressed: cancel,
                  child: Text('cancel'),
                )
              ],
            ));
  }

  //save workout
  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);
    Navigator.pop(context);
    clear();
  }

  //cancel workout
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  //clear text controller
  void clear() {
    newWorkoutNameController.clear();
  }

  void goToWorkoutPage(String workOutName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutPage(
                  workoutName: workOutName,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Workout Tracker'),
        ),
        body: ListView.builder(
            itemCount: value.workoutList.length,
            itemBuilder: (context, index) => ListTile(
                  title: Text(value.getWorkoutList()[index].name),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () =>
                        goToWorkoutPage(value.getWorkoutList()[index].name),
                  ),
                )),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
