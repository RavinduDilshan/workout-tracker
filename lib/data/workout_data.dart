import 'package:fresh/models/exercise.dart';
import 'package:fresh/models/workout.dart';

class WorkoutData {
  List<Workout> workoutList = [
    Workout(name: 'Upper Body', exercises: [
      Exercise(name: 'Bicep Curls', weight: '10', reps: '10', sets: '3')
    ])
  ];

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
  }

  //add an exercise to a workout
  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    //find the relevent workout
    Workout releventWorkout = getReleventWorkout(workoutName);
    releventWorkout.exercises.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));
  }

  //check off exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    //find the relevent workout and exercise in that workout
    Exercise releventExercise = getReleventExercise(workoutName, exerciseName);

    //check off boolean to show user complete the exercise
    releventExercise.isCompleted = !releventExercise.isCompleted;
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
