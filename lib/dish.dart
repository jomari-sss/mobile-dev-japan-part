/// A single dish row from the `dishes` table.
///
/// Ingredients are stored in SQLite as one comma-separated TEXT column
/// (SQLite has no array type), and split back into a List<String> here.
class Dish {
  const Dish({
    required this.id,
    required this.cuisine,
    required this.foodName,
    required this.ingredients,
    required this.imagePath,
  });

  final int id;

  /// Matches the CuisineFoodScreen title exactly, e.g. "Filipino Cuisine".
  final String cuisine;

  final String foodName;
  final List<String> ingredients;

  /// Path under assets/images/ (or a network URL) for this dish's photo.
  final String imagePath;

  factory Dish.fromMap(Map<String, Object?> map) {
    final rawIngredients = map['ingredients'] as String? ?? '';
    return Dish(
      id: map['id'] as int,
      cuisine: map['cuisine'] as String,
      foodName: map['food_name'] as String,
      ingredients: rawIngredients
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      imagePath: map['image_path'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'cuisine': cuisine,
      'food_name': foodName,
      'ingredients': ingredients.join(', '),
      'image_path': imagePath,
    };
  }
}
