import 'package:flutter/material.dart';
import 'package:p15_firestore_repository/src/data/database_repository.dart';
import 'package:p15_firestore_repository/src/data/firebase_auth.dart';
import 'package:p15_firestore_repository/src/domain/drink.dart';
import 'package:p15_firestore_repository/src/features/add_drink/presentation/add_drink_screen.dart';

class DrinkListScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;

  const DrinkListScreen(
      {super.key,
      required this.databaseRepository,
      required AuthRepository authRepository});

  @override
  _DrinkListScreenState createState() => _DrinkListScreenState();
}

class _DrinkListScreenState extends State<DrinkListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drink List'),
      ),
      body: StreamBuilder<List<Drink>>(
        stream: widget.databaseRepository.drinksStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No drinks available'));
          }

          final drinks = snapshot.data!;

          return ListView.builder(
            itemCount: drinks.length,
            itemBuilder: (context, index) {
              final drink = drinks[index];
              return ListTile(
                title: Text(drink.type),
                subtitle: Text(drink.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _removeDrink(drink.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return AddDrinkScreen(
                  databaseRepository: widget.databaseRepository);
            }),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _removeDrink(int drinkId) async {
    try {
      await widget.databaseRepository.removeDrink(drinkId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Drink removed successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint('Failed to remove drink: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to remove drink. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
