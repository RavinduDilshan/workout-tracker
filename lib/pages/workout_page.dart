import 'package:flutter/material.dart';
import 'package:fresh/components/exercise_tile.dart';
import 'package:fresh/data/workout_data.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;

  WorkoutPage({required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
//text controllers
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  //check box was tapped
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
        .checkOffExercise(workoutName, exerciseName);
  }

  //save exercise
  void save() {
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;
    Provider.of<WorkoutData>(context, listen: false)
        .addExercise(widget.workoutName, newExerciseName, weight, reps, sets);
    Navigator.pop(context);
    clear();
  }

  //cancel exercise
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  //clear text controller
  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

//create a new exercise
  void createNewExercise() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add a new exercise'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //exercise name
                    TextField(
                      controller: exerciseNameController,
                    ),

                    //weights
                    TextField(
                      controller: weightController,
                    ),

                    //reps
                    TextField(
                      controller: repsController,
                    ),

                    //sets
                    TextField(
                      controller: setsController,
                    )
                  ],
                ),
              ),
              actions: [
                //save button
                MaterialButton(
                  onPressed: save,
                  child: const Text('save'),
                ),

                //cancel button
                MaterialButton(
                  onPressed: cancel,
                  child: const Text('cancel'),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.workoutName),
        ),
        body: ListView.builder(
          itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
          itemBuilder: (context, index) => ExerciseTile(
            exerciseName: value
                .getReleventWorkout(widget.workoutName)
                .exercises[index]
                .name,
            weight: value
                .getReleventWorkout(widget.workoutName)
                .exercises[index]
                .weight,
            reps: value
                .getReleventWorkout(widget.workoutName)
                .exercises[index]
                .reps,
            sets: value
                .getReleventWorkout(widget.workoutName)
                .exercises[index]
                .sets,
            isCompleted: value
                .getReleventWorkout(widget.workoutName)
                .exercises[index]
                .isCompleted,
            onCheckboxChanged: (bool) => onCheckBoxChanged(
                widget.workoutName,
                value
                    .getReleventWorkout(widget.workoutName)
                    .exercises[index]
                    .name),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
