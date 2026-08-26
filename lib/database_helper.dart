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
_row('Filipino Cuisine', 'Adobo',
    'Chicken or pork, Soy sauce, Vinegar, Garlic, Bay leaves, Whole peppercorns, Water, Cooking oil',
    'assets/images/adobo.jpg'),
_row('Filipino Cuisine', 'Sinigang',
    'Pork, shrimp, or fish, Tamarind or sinigang mix, Tomatoes, Onion, Radish, Eggplant, String beans, Water spinach (kangkong)',
    'assets/images/sinigang.jpg'),
_row('Filipino Cuisine', 'Kare-Kare',
    'Oxtail or beef, Peanut butter, Ground rice, Eggplant, String beans, Bok choy (pechay), Annatto powder, Bagoong (shrimp paste)',
    'assets/images/kare_kare.jpg'),
_row('Filipino Cuisine', 'Lechon',
    'Whole pig, Salt, Pepper, Garlic, Lemongrass, Onion, Cooking oil',
    'assets/images/lechon.jpg'),
_row('Filipino Cuisine', 'Laing',
    'Dried taro leaves, Coconut milk, Pork, Shrimp paste, Garlic, Onion, Ginger, Chili peppers',
    'assets/images/laing.jpg'),
_row('Filipino Cuisine', 'Sisig',
    'Pork face or pork belly, Onion, Garlic, Chili peppers, Calamansi, Soy sauce, Mayonnaise (optional), Cooking oil',
    'assets/images/sisig.jpg'),
_row('Filipino Cuisine', 'Tinola',
    'Chicken, Ginger, Garlic, Onion, Green papaya, Chili leaves, Fish sauce, Water',
    'assets/images/tinola.jpg'),
_row('Filipino Cuisine', 'Lumpiang Sariwa',
    'Fresh lumpia wrapper, Carrots, Cabbage, Green beans, Sweet potato, Bean sprouts, Garlic, Onion, Peanuts, Lumpia sauce, Cooking oil',
    'assets/images/lumpiang_sariwa.jpg'),
_row('Filipino Cuisine', 'Dinuguan',
    'Pork, Pork blood, Vinegar, Garlic, Onion, Chili peppers, Bay leaves, Peppercorns',
    'assets/images/dinuguan.jpg'),
_row('Filipino Cuisine', 'Tortang Talong',
    'Eggplant, Eggs, Onion, Garlic, Salt, Black pepper, Cooking oil, Ground pork (optional)',
    'assets/images/tortang_talong.jpg'),

// --- European Cuisine ---
    _row(
    'European Cuisine',
    'Moussaka',
    'Eggplant, Ground beef or lamb Potatoes, Tomatoes, Onion, Garlic, Béchamel sauce, Cheese',
    'assets/images/moussaka.jpg',
    ),

    _row(
    'European Cuisine',
    'Beef Bourguignon',
    'Beef Chuck, Red Wine, Carrot, Pearl Onion, Mushroom, Garlic, Herbs, Beef Stock',
    'assets/images/beef_bourguignon.jpg',
    ),

    _row(
    'European Cuisine',
    'Pizza Margherita',
    'Pizza Dough, Tomato Sauce, Mozzarella, Basil, Olive Oil, Salt',
    'assets/images/margherita_pizza.jpg',
    ),

    _row(
    'European Cuisine',
    'Paella',
    'Rice, Saffron, Chicken, Shrimp, Bell Pepper, Tomatoes, Squid, Olive Oil',
    'assets/images/paella.jpg',
    ),

    _row(
    'European Cuisine',
    'Fish and Chips',
    'White fish, Potatoes, Flour, Eggs, Cooking oil, Salt, Vinegar, Mustard',
    'assets/images/fish_and_chips.jpg',
    ),

    _row(
    'European Cuisine',
    'Bratwurst',
    'Pork or beef sausage, Onion, Garlic, Mustard, Sauerkraut, Salt, Black pepper',
    'assets/images/bratwurst.jpg',
    ),

    _row(
    'European Cuisine',
    'Pierogi',
    'Flour, Potatoes, Cheese, Onion, Butter, Salt, Black pepper',
    'assets/images/pierogi.jpg',
    ),

    _row(
    'European Cuisine',
    'Bacalhau',
    'Salted cod, Potatoes, Onion, Garlic, Eggs, Olive oil, Black olives',
    'assets/images/bacalhau.jpg',
    ),

    _row(
    'European Cuisine',
    'Goulash',
    'Beef, Onion, Paprika, Tomatoes, Potatoes, Carrots, Garlic, Beef broth',
    'assets/images/goulash.jpg',
    ),

    _row(
    'European Cuisine',
    'Wiener Schnitzel',
    'Veal or pork, Flour, Eggs, Breadcrumbs, Salt, Black pepper, Cooking oil, Lemon',
    'assets/images/wiener_schnitzel.jpg',
    ),

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
