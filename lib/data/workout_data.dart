import 'package:flutter/material.dart';
import 'package:fresh/data/hive_database.dart';
import 'package:fresh/models/exercise.dart';
import 'package:fresh/models/workout.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();

  List<Workout> workoutList = [
    Workout(name: 'Upper Body', exercises: [
      Exercise(name: 'Bicep Curls', weight: '10', reps: '10', sets: '3')
    ]),
    Workout(name: 'Lower Body', exercises: [
      Exercise(name: 'Squats', weight: '10', reps: '10', sets: '3')
    ])
  ];

  //if there are workouts already in db,then get that workout list,otherwise get default workouts(for fist time for app)
  void initializeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    } else {
      db.saveToDatabase(workoutList);
    }
  }

  //get length of a given workout
  int numberOfExercisesInWorkout(String workoutName) {
    Workout releventWorkout = getReleventWorkout(workoutName);

    return releventWorkout.exercises.length;
  }

  //get workout list
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  //add a workout
  void addWorkout(String name) {
    //add workout with blank list of exercises
    workoutList.add(Workout(name: name, exercises: []));
    notifyListeners();
    db.saveToDatabase(workoutList);
  }

  //add an exercise to a workout
  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    //find the relevent workout
    Workout releventWorkout = getReleventWorkout(workoutName);
    releventWorkout.exercises.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));
    notifyListeners();
    db.saveToDatabase(workoutList);
  }

  //check off exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    //find the relevent workout and exercise in that workout
    Exercise releventExercise = getReleventExercise(workoutName, exerciseName);

    //check off boolean to show user complete the exercise
    releventExercise.isCompleted = !releventExercise.isCompleted;
    notifyListeners();
    db.saveToDatabase(workoutList);
  }

  //return relevent workout object, given workout name
  Workout getReleventWorkout(String workoutName) {
    Workout releventWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);

    return releventWorkout;
  }

  //return relevent exercise object,given workout name+exercise name
  Exercise getReleventExercise(String workoutName, String exerciseName) {
    //find relevent workout first
    Workout releventWorkout = getReleventWorkout(workoutName);

    //then find relevent exercise in that workout
    Exercise releventExercise = releventWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return releventExercise;
  }
}
