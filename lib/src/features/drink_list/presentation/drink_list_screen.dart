import 'package:flutter/material.dart';
import 'package:p15_firestore_repository/src/data/database_repository.dart';
import 'package:p15_firestore_repository/src/data/firebase_auth.dart';
import 'package:p15_firestore_repository/src/domain/drink.dart';
import 'package:p15_firestore_repository/src/features/add_drink/presentation/add_drink_screen.dart';

class DrinkListScreen extends StatefulWidget {
  final DatabaseRepository databaseRepository;

  const DrinkListScreen({
    super.key,
    required this.databaseRepository,
    required AuthRepository authRepository,
  });

  @override
  DrinkListScreenState createState() => DrinkListScreenState();
}

class DrinkListScreenState extends State<DrinkListScreen> {
  late Stream<List<Drink>> _drinksStream;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _drinksStream = widget.databaseRepository.drinksStream();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drink List'),
        actions: const [
          SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by drink type...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _query = '';
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<Drink>>(
        stream: _drinksStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No drinks available'));
          }

          final drinks = snapshot.data!;
          final filteredDrinks = _filterDrinks(drinks);

          return ListView.builder(
            itemCount: filteredDrinks.length,
            itemBuilder: (context, index) {
              final drink = filteredDrinks[index];
              return ListTile(
                title: Text(drink.type),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(drink.name),
                    Text(drink.brand),
                    // Hier die Brand anzeigen
                  ],
                ),
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
            MaterialPageRoute(
              builder: (context) => AddDrinkScreen(
                databaseRepository: widget.databaseRepository,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Drink> _filterDrinks(List<Drink> drinks) {
    if (_query.isEmpty) {
      return drinks;
    } else {
      final queryLowerCase = _query.toLowerCase();
      return drinks
          .where((drink) =>
              drink.type.toLowerCase().contains(queryLowerCase) ||
              drink.name.toLowerCase().contains(queryLowerCase) ||
              drink.brand.toLowerCase().contains(queryLowerCase))
          .toList();
    }
  }

  void _removeDrink(int drinkId) async {
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

  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search Drinks'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Enter Drink Name',
            ),
            onChanged: (value) {
              setState(() {
                _query = value;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Search'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
