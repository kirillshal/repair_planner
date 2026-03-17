import 'package:flutter/material.dart';
import '../models/room.dart';
import 'result_screen.dart';

class RoomFormScreen extends StatefulWidget {
  const RoomFormScreen({super.key});

  @override
  State<RoomFormScreen> createState() => _RoomFormScreenState();
}

class _RoomFormScreenState extends State<RoomFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _wasteController = TextEditingController(text: '10');

  String _selectedMaterial = 'Ламинат';
  final List<String> _materialTypes = ['Ламинат', 'Плитка'];

  @override
  void dispose() {
    _nameController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _wasteController.dispose();
    super.dispose();
  }

  void _calculateAndNavigate() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      double length = double.parse(_lengthController.text);
      double width = double.parse(_widthController.text);
      double waste = double.parse(_wasteController.text);

      var result = Room.calculateMaterials(
        length: length,
        width: width,
        materialType: _selectedMaterial,
        wastePercentage: waste,
      );

      Room room = Room(
        name: name,
        length: length,
        width: width,
        materialType: _selectedMaterial,
        wastePercentage: waste,
        calculatedArea: result['calculatedArea'],
        tilesNeeded: result['tilesNeeded'],
        laminateNeeded: result['laminateNeeded'],
        createdAt: DateTime.now(),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(room: room),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новый проект'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Название комнаты',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.room),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите название комнаты';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _lengthController,
                decoration: const InputDecoration(
                  labelText: 'Длина (м)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.straighten),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите длину';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Введите число';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Длина должна быть больше 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _widthController,
                decoration: const InputDecoration(
                  labelText: 'Ширина (м)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.straighten),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите ширину';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Введите число';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Ширина должна быть больше 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedMaterial,
                decoration: const InputDecoration(
                  labelText: 'Тип материала',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _materialTypes.map((String material) {
                  return DropdownMenuItem<String>(
                    value: material,
                    child: Text(material),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMaterial = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _wasteController,
                decoration: const InputDecoration(
                  labelText: 'Запас материала (%)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.percent),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Введите процент запаса';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Введите число';
                  }
                  if (double.parse(value) < 0) {
                    return 'Запас не может быть отрицательным';
                  }
                  if (double.parse(value) > 100) {
                    return 'Запас не может быть больше 100%';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _calculateAndNavigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Рассчитать материалы',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}