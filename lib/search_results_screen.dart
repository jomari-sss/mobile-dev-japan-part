import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'dish.dart';
import 'shared_widgets.dart';

/// Shown after submitting the home screen's ingredient search. Queries
/// SQLite for every dish whose ingredient list contains [query] (across
/// all cuisines) and displays the matches as a grid, reusing the exact
/// same DishCard/DishDetailDialog widgets as CuisineFoodScreen.
class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key, required this.query});

  final String query;

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late final String _backgroundUrl;
  late final Future<List<Dish>> _resultsFuture;

  @override
  void initState() {
    super.initState();
    _backgroundUrl = randomImageUrl(800, 1600);
    _resultsFuture = DatabaseHelper.instance.searchByIngredient(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AssetOrFallback(
            //
            // image dito
            // image dito
            // image dito
            assetPath: 'assets/images/food_list_background.jpg',
            placeholder: Image.network(_backgroundUrl, fit: BoxFit.cover),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.45),
                  Colors.black.withOpacity(0.25),
                  Colors.black.withOpacity(0.55),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 18),
                const Text('🍅', style: TextStyle(fontSize: 34)),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Results for "${widget.query}"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black87,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: FutureBuilder<List<Dish>>(
                    future: _resultsFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }

                      final results = snapshot.data!;
                      if (results.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'No dishes use "${widget.query}". Try another ingredient.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: results.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.95,
                          ),
                          itemBuilder: (context, index) {
                            final dish = results[index];
                            return DishCard(
                              dish: dish,
                              onTap: () => showDishDetail(context, dish),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 76),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 18,
            child: HelpButton(
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
          Positioned(
            top: 20,
            left: 18,
            child: CircleBackButton(
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
        ],
      ),
    );
  }
}
