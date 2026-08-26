import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dish.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper instance = DatabaseHelper._internal();

  static const String _dbName = 'cook_smarter.db';
  static const int _dbVersion = 1;
  static const String table = 'dishes';

  Database? _db;

  Future<Database> get _database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbDir = await getDatabasesPath();
    final dbPath = join(dbDir, _dbName);

    return openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cuisine TEXT NOT NULL,
            food_name TEXT NOT NULL,
            ingredients TEXT NOT NULL,
            image_path TEXT NOT NULL
          )
        ''');
        await _seed(db);
      },
    );
  }

  ///
  ///
  ///dito kayo maglagay ng info sa cuuisine
  Future<void> _seed(Database db) async {
    final seedRows = <Map<String, Object?>>[
      /*
      
      _row('Filipino Cuisine', 'Pares ni Diwata', 'Tubig, Scrap Meat, Magic Sarap',
    'assets/images/pares_ni_diwata.jpg'),
    // 
    sa pang apat niyo ilalagay yung path ng image, kung marame ang ingredients
    ilagay niyo yung image path sa last kung ang ingredients
    ay 10 ang image path ay pang 11. PLEASE WAG TANGA
      
      */
// --- Japanese Cuisine ---
_row('Japanese Cuisine', 'Onigiri',
    'Japanese short-grain rice, Sea salt, Nori (seaweed), Filling (salmon, plum, or tuna)',
    'assets/images/onigiri.jpg'),
_row('Japanese Cuisine', 'Kare Raisu',
    'Steamed white rice, Curry roux, Beef or chicken, Potatoes, Carrots, Onion',
    'assets/images/kare_raisu.jpg'),
_row('Japanese Cuisine', 'Sushi',
    'Vinegared short-grain rice, Fresh seafood (salmon or tuna), Nori (seaweed), Wasabi, Soy sauce',
    'assets/images/sushi.jpg'),
_row('Japanese Cuisine', 'Sashimi',
    'Sashimi-grade raw fish, Soy sauce, Wasabi, Shredded daikon radish',
    'assets/images/sashimi.jpg'),
_row('Japanese Cuisine', 'Unagi',
    'Freshwater eel, Soy sauce, Mirin, Sugar, Steamed rice',
    'assets/images/unagi.jpg'),
_row('Japanese Cuisine', 'Ramen',
    'Wheat noodles, Pork or chicken broth, Chashu (braised pork belly), Soft-boiled egg, Green onions',
    'assets/images/ramen.jpg'),
_row('Japanese Cuisine', 'Udon',
    'Thick udon noodles, Dashi broth, Soy sauce, Mirin, Green onions',
    'assets/images/udon.jpg'),
_row('Japanese Cuisine', 'Sukiyaki',
    'Thinly sliced beef, Tofu, Mushrooms, Soy sauce, Sugar, Raw egg (for dipping)',
    'assets/images/sukiyaki.jpg'),
_row('Japanese Cuisine', 'Yakitori',
    'Chicken pieces, Soy sauce, Mirin, Sake, Sugar',
    'assets/images/yakitori.jpg'),
_row('Japanese Cuisine', 'Tonkatsu',
    'Pork cutlet, Flour, Egg, Panko breadcrumbs, Shredded cabbage, Tonkatsu sauce',
    'assets/images/tonkatsu.jpg'),

// --- Filipino Cuisine ---
_row('Filipino Cuisine', 'Pares ni Diwata',
    'Tubig, Scrap Meat, Magic Sarap', 'assets/images/dish_photo.jpg'),
_row('Filipino Cuisine', 'Chicken Adobo',
    'Chicken, Soy Sauce, Vinegar, Garlic, Bay Leaf', 'assets/images/dish_photo.jpg'),
_row('Filipino Cuisine', 'Sinigang na Baboy',
    'Pork, Tamarind, Kangkong, Radish, Tomato', 'assets/images/dish_photo.jpg'),
_row('Filipino Cuisine', 'Pancit Canton',
    'Egg Noodles, Cabbage, Carrot, Chicken, Soy Sauce', 'assets/images/dish_photo.jpg'),
_row('Filipino Cuisine', 'Lechon Kawali',
    'Pork Belly, Salt, Bay Leaf, Peppercorn, Garlic', 'assets/images/dish_photo.jpg'),
_row('Filipino Cuisine', 'Kare-Kare',
    'Oxtail, Peanut Sauce, Eggplant, Banana Heart, Bagoong', 'assets/images/dish_photo.jpg'),
_row('Filipino Cuisine', 'Tinolang Manok',
    'Chicken, Ginger, Green Papaya, Malunggay Leaves, Fish Sauce', 'assets/images/dish_photo.jpg'),
_row('Filipino Cuisine', 'Bicol Express',
    'Pork, Coconut Milk, Siling Labuyo, Shrimp Paste, Garlic', 'assets/images/dish_photo.jpg'),
_row('Filipino Cuisine', 'Pinakbet',
    'Bitter Gourd, Squash, Eggplant, Okra, Bagoong', 'assets/images/dish_photo.jpg'),
_row('Filipino Cuisine', 'Halo-Halo',
    'Shaved Ice, Sweet Beans, Leche Flan, Ube, Evaporated Milk', 'assets/images/dish_photo.jpg'),

// --- European Cuisine ---
_row('European Cuisine', 'Spaghetti Carbonara',
    'Spaghetti, Egg, Pancetta, Parmesan, Black Pepper', 'assets/images/dish_photo.jpg'),
_row('European Cuisine', 'Beef Bourguignon',
    'Beef Chuck, Red Wine, Carrot, Pearl Onion, Mushroom', 'assets/images/dish_photo.jpg'),
_row('European Cuisine', 'Margherita Pizza',
    'Pizza Dough, Tomato Sauce, Mozzarella, Basil, Olive Oil', 'assets/images/dish_photo.jpg'),
_row('European Cuisine', 'Paella',
    'Rice, Saffron, Chicken, Shrimp, Bell Pepper', 'assets/images/dish_photo.jpg'),
_row('European Cuisine', 'Beef Wellington',
    'Beef Tenderloin, Puff Pastry, Mushroom Duxelles, Prosciutto, Dijon Mustard', 'assets/images/dish_photo.jpg'),
_row('European Cuisine', 'Ratatouille',
    'Eggplant, Zucchini, Bell Pepper, Tomato, Herbs de Provence', 'assets/images/dish_photo.jpg'),
_row('European Cuisine', 'Fish and Chips',
    'Cod Fillet, Beer Batter, Potato, Malt Vinegar, Tartar Sauce', 'assets/images/dish_photo.jpg'),
_row('European Cuisine', 'Moussaka',
    'Eggplant, Ground Lamb, Bechamel Sauce, Tomato, Cinnamon', 'assets/images/dish_photo.jpg'),
_row('European Cuisine', 'Goulash',
    'Beef, Paprika, Onion, Bell Pepper, Caraway Seed', 'assets/images/dish_photo.jpg'),
_row('European Cuisine', 'Tiramisu',
    'Ladyfingers, Mascarpone, Espresso, Cocoa Powder, Egg Yolk', 'assets/images/dish_photo.jpg'),
    ];


    for (final row in seedRows) {
      await db.insert(table, row);
    }
  }

   Map<String, Object?> _row(
       String cuisine, String foodName, String ingredients, String imagePath) {
     return {
       'cuisine': cuisine,
       'food_name': foodName,
       'ingredients': ingredients,
       'image_path': imagePath,
     };
   }

  /// All dishes belonging to one cuisine, e.g. "Filipino Cuisine" — powers
  /// the grid on CuisineFoodScreen.
  Future<List<Dish>> getByCuisine(String cuisine) async {
    final db = await _database;
    final rows = await db.query(
      table,
      where: 'cuisine = ?',
      whereArgs: [cuisine],
      orderBy: 'id ASC',
    );
    return rows.map(Dish.fromMap).toList();
  }

  /// Dishes whose ingredient list contains [query] (case-insensitive,
  /// partial match) — powers the home screen's ingredient search.
  Future<List<Dish>> searchByIngredient(String query) async {
    final db = await _database;
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final rows = await db.query(
      table,
      where: 'ingredients LIKE ?',
      whereArgs: ['%$trimmed%'],
      orderBy: 'food_name ASC',
    );
    return rows.map(Dish.fromMap).toList();
  }
}
