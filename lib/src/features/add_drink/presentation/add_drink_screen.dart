import 'package:flutter/material.dart';
import 'package:p15_firestore_repository/src/data/database_repository.dart';
import 'package:p15_firestore_repository/src/domain/drink.dart';

class AddDrinkScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;

  const AddDrinkScreen({super.key, required this.databaseRepository});

  @override
  AddDrinkScreenState createState() => AddDrinkScreenState();
}

class AddDrinkScreenState extends State<AddDrinkScreen> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();

  Future<void> _addDrink() async {
    String type = _typeController.text.trim();
    String name = _nameController.text.trim();
    String brand = _brandController.text.trim();

    if (type.isEmpty) {
      _showSnackbar('Please enter the drink type');
      return;
    }

    final drink = Drink(
      id: DateTime.now().millisecondsSinceEpoch,
      type: type,
      name: name,
      brand: brand,
    );

    try {
      await widget.databaseRepository.addDrink(drink);
      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Failed to add drink: $e');
      _showSnackbar('Failed to add drink. Please try again.');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Drink'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(
                labelText: 'Drink Type',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Drink Name',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(
                labelText: 'Drink Brand',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addDrink,
              child: const Text('Add Drink'),
            ),
          ],
        ),
      ),
    );
  }
}
