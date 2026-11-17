import 'package:flutter/material.dart';
import '../models/weight_model.dart';
import 'add_weight_screen.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({super.key});

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  List<WeightModel> registros = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Progreso'),
      ),
      body: registros.isEmpty
          ? const Center(
              child: Text(
                "No hay registros",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder( 
              itemCount: registros.length,
              itemBuilder: (context, index) {
                final registro = registros[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.monitor_weight),
                    title: Text(
                      '${registro.pesoKilos} kg',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(registro.fecha),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddWeightScreen(),
            ),
          );

          if (result != null && result is WeightModel) {
            setState(() {
              registros.add(result);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}