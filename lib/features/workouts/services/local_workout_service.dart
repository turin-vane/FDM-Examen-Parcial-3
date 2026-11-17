import 'package:aplicacion2/core/database/database_helper.dart';
import 'package:aplicacion2/features/workouts/models/workout_model.dart';

class LocalWorkoutService {
  final dbHelper = DatabaseHelper.instance;

  //Crear
  Future<int> insertWorkout(WorkoutModel workout) async{
    final db = await dbHelper.database;
    return await db.insert('workouts', workout.toMap());
  }

  //lectura
  Future<List<WorkoutModel>> getWorkouts() async{
    final db = await dbHelper.database;

    final List<Map<String, dynamic>> maps = await db.query('workouts');

    return List.generate(maps.length, (i){
      return WorkoutModel.fromMap(maps[i]);
    });
  }

  //Eliminación
  Future<int> deleteWorkout(int id) async{
    final db = await dbHelper.database;

    return await db.delete(
      'workouts',
      where:'id = ?',
      whereArgs: [id]
    );
  }
  // Actualización
  Future<int> updateWorkout(WorkoutModel workout) async {
    final db = await dbHelper.database;
    return await db.update(
      'workouts',
      workout.toMap(),
      where: 'id = ?',
      whereArgs: [workout.localId]
    );
  }
}