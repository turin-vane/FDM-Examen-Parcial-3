import 'package:flutter/material.dart';
import '../models/weight_model.dart';

class AddWeightScreen extends StatefulWidget {
  const AddWeightScreen({super.key});

  @override
  State<AddWeightScreen> createState() => _AddWeightScreenState();
}

class _AddWeightScreenState extends State<AddWeightScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String _fecha = '';
  double _pesoKilos = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Peso'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Fecha: ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La fecha no puede estar vacía';
                }
                return null;
              },
              onSaved: (value) {
                _fecha = value!;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Peso (kg)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El peso no puede estar vacío';
                }
                final peso = double.tryParse(value);
                if (peso == null || peso <= 0) {
                  return 'Debe ser un número mayor a 0';
                }
                return null;
              },
              onSaved: (value) {
                _pesoKilos = double.parse(value!);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  
                  final nuevoRegistro = WeightModel(
                    fecha: _fecha,
                    pesoKilos: _pesoKilos,
                  );
                  
                  Navigator.pop(context, nuevoRegistro);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}