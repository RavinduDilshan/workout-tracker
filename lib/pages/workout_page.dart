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
                    .isCompleted)),
      ),
    );
  }
}
