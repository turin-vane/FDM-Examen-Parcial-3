import 'package:aplicacion2/core/storage/local_storage_service.dart';
import 'package:aplicacion2/features/auth/screens/login_screen.dart';
import 'package:aplicacion2/features/workouts/models/workout_model.dart';
import 'package:aplicacion2/features/workouts/screens/add_workout_screen.dart';
import 'package:aplicacion2/features/workouts/services/local_workout_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState()=> _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final LocalWorkoutService _dbService = LocalWorkoutService();

  List<WorkoutModel> _workouts = [];
  bool _isLoading = false;

  @override
  void initState(){
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async{
    setState((){
      _isLoading = true;
    });

    final workouts = await _dbService.getWorkouts();

    setState(() {
      _workouts = workouts;
      _isLoading = false;
    });
  }

  void _logout() async{
    final storage = LocalStorageService();
    await storage.deleteToken();

    if(!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context)=> LoginScreen()), 
      (Route<dynamic> route)=> false,
      );
  }

  /*void _showAddWorkoutDialog(){
    final titleController = TextEditingController();
    final categoryController = TextEditingController();
    final durationMinutesController = TextEditingController();

    showDialog(
      context: context, 
      builder: (context)=> 
      AlertDialog(
        title: Text('Nueva Rutina'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Nombre"),
              ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: "Categoria"),
              ),
            TextField(
              controller: durationMinutesController,
              decoration: InputDecoration(labelText: "Duración (minutos)"),
              keyboardType: TextInputType.number,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text("Cancelar")),

            ElevatedButton(onPressed: () async {
              if(titleController.text.isNotEmpty && durationMinutesController.text.isNotEmpty && categoryController.text.isNotEmpty){
                final newWorkout = WorkoutModel(
                  title: titleController.text,
                  category: categoryController.text, 
                  durationMinutes: int.parse(durationMinutesController.text));

                  await _dbService.insertWorkout(newWorkout);

                  if(mounted){
                  Navigator.pop(context);
                  _loadWorkouts();
                  }
              }

            }, child:Text('Guardar')),
        ],
      ));
  }
*/

Future<void> _navigateToAddWorkout() async{
  final newWorkout = await Navigator.push(
    context, 
    MaterialPageRoute(builder: (context) => AddWorkoutScreen()),
    );
    if(newWorkout != null && newWorkout is WorkoutModel){
      await _dbService.insertWorkout(newWorkout);
      _loadWorkouts();

    if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rutina creada exitosamente'),
        backgroundColor: Colors.green,)
      );
    }
    }
}
  //modal edicion 
  void _showEditWorkoutDialog(WorkoutModel workout) {
    final titleController = TextEditingController(text: workout.title);
    final categoryController = TextEditingController(text: workout.category);
    final durationMinutesController = TextEditingController(text: workout.durationMinutes.toString());

    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Editar Rutina'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: "Categoria"),
            ),
            TextField(
              controller: durationMinutesController,
              decoration: InputDecoration(labelText: "Duración (minutos)"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text("Cancelar")
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty && durationMinutesController.text.isNotEmpty && categoryController.text.isNotEmpty) {
                // Instanciamos el modelo manteniendo el ID original
                final updatedWorkout = WorkoutModel(
                  localId: workout.localId, 
                  title: titleController.text,
                  category: categoryController.text, 
                  durationMinutes: int.parse(durationMinutesController.text)
                );

                await _dbService.updateWorkout(updatedWorkout);

                if (mounted) {
                  Navigator.pop(context);
                  _loadWorkouts();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Rutina actualizada'))
                  );
                }
              }
            }, 
            child: Text('Actualizar')
          ),
        ],
      )
    );
  }

// Modal de detalles
  void _showWorkoutDetailsDialog(WorkoutModel workout) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalles de la Rutina'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(workout.title, style: TextStyle(fontSize: 16)),
            SizedBox(height: 12),
            Text('Categoría:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(workout.category, style: TextStyle(fontSize: 16)),
            SizedBox(height: 12),
            Text('Duración:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('${workout.durationMinutes} minutos', style: TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cerrar"),
          ),
        ],
      )
    );
  }

  Future<void> _deleteWorkout(int id) async{
    await _dbService.deleteWorkout(id);
    if(mounted){
      _loadWorkouts();
      ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('Rutina eliminada')));
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis entrenamientos"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions:[ IconButton(
            onPressed: (){
              showDialog(
                context: context, 
                builder: (context)=> AlertDialog(
                  title: Text('¿Cerrar sesión?'),
                  content: Text('Tendrás que volver a ingresar tus datos'),
                  actions: [
                    TextButton(
                      onPressed: ()=> Navigator.pop(context), 
                      child: Text('Cancelar')),
                      ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                          _logout();
                        }, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Salir', style: TextStyle(color: Colors.white),
                        ),
                        ),
                  ],
                ),
                );
            },
            icon: Icon(Icons.logout))
        ],
      ),
      body: _isLoading 
      ? Center(child: CircularProgressIndicator(),)
      : _workouts.isEmpty
        ? Center(child:Text('No tienes rutinas creadas'),)
        : ListView.builder(
              itemCount: _workouts.length,
              itemBuilder: (context, index) {
                final workout = _workouts[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    onTap: () => _showWorkoutDetailsDialog(workout),
                    
                    leading: CircleAvatar(
                      child: Icon(Icons.fitness_center),
                    ),
                    title: Text(workout.title, style: TextStyle(fontWeight: FontWeight.bold,)),
                    subtitle: Text('${workout.category}\n${workout.durationMinutes} min'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _showEditWorkoutDialog(workout),
                          icon: Icon(Icons.edit, color: Colors.blueAccent),
                        ),
                        IconButton(
                          onPressed: () => _deleteWorkout(workout.localId!),
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  )
                );  
              },
            ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToAddWorkout, 
          child: Icon(Icons.add),
          ),
    );
  }
}
