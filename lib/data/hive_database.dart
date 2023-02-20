import 'package:fresh/datetime/date_time.dart';
import 'package:fresh/models/exercise.dart';
import 'package:fresh/models/workout.dart';
import 'package:hive/hive.dart';

class HiveDatabase {
  //reference our hive box
  final _myBox = Hive.box('workout_database1');

  //check if there is already data stored,if not record the start date
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      return true;
    }
  }

  //return start date as yyyymmdd
  String getStartDate() {
    return _myBox.get('START_DATE');
  }

  //write data
  void saveToDatabase(List<Workout> workouts) {
    //convert workout objects into list of workout string so we can save those inside hive
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    //check if any exercise have been done
    //we'll put a 0 or 1 for each yyyymmdd date

    if (exerciseIsCompleted(workouts)) {
      _myBox.put('COMPLETION_STATUS' + todaysDateYYYYMMDD(), 1);
    } else {
      _myBox.put('COMPLETION_STATUS' + todaysDateYYYYMMDD(), 0);
    }

    //save into hive
    _myBox.put('WORKOUTS', workoutList);
    _myBox.put('EXERCISES', exerciseList);
  }

  //read data and return list of workouts
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];
    List<String> workoutNames = _myBox.get('WORKOUTS');
    final exerciseDetails = _myBox.get('EXERCISES');

    for (int i = 0; i < workoutNames.length; i++) {
      List<Exercise> exercisesInEachWorkout = [];
      for (int j = 0; j < exerciseDetails[i]; j++) {
        exercisesInEachWorkout.add(Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == 'true' ? true : false));
      }
      Workout workout =
          Workout(name: workoutNames[i], exercises: exercisesInEachWorkout);
      mySavedWorkouts.add(workout);
    }

    return mySavedWorkouts;
  }

  //check if any exercise have been done
  bool exerciseIsCompleted(List<Workout> workouts) {
    //go thru each workout
    for (var workout in workouts) {
      //go thru each exercise in workout
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }

    return false;
  }

  //return completion status of a given data yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
    //return 0 or 1, if null return 0
    int completionStatus = _myBox.get('COMPLETION_STATUS' + yyyymmdd) ?? 0;
    return completionStatus;
  }

  //convert workout object into a list
  List<String> convertObjectToWorkoutList(List<Workout> workouts) {
    List<String> workoutList = [];
    for (int i = 0; i < workouts.length; i++) {
      workoutList.add(workouts[i].name);
    }

    return workoutList;
  }

  //converts the exercises in a workout object into a list of strings
  List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
    List<List<List<String>>> exerciseList = [];
    //go through each workout
    for (int i = 0; i < workouts.length; i++) {
      //get each exercise in workout
      List<Exercise> exercisesInWorkout = workouts[i].exercises;
      List<List<String>> individualWorkout = [];

      //go through each exercise
      for (int j = 0; j < exercisesInWorkout.length; i++) {
        List<String> individualExercise = [];
        individualExercise.addAll([
          exercisesInWorkout[j].name,
          exercisesInWorkout[j].weight,
          exercisesInWorkout[j].reps,
          exercisesInWorkout[j].sets,
          exercisesInWorkout[j].isCompleted.toString(),
        ]);

        individualWorkout.add(individualExercise);
      }
      exerciseList.add(individualWorkout);
    }

    return exerciseList;
  }
}
