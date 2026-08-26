import 'package:flutter/material.dart';

import 'database_helper.dart';
import 'dish.dart';
import 'shared_widgets.dart';

/// Shown after a cuisine is picked on the home screen. Loads every dish
/// for [cuisineName] from SQLite and shows it as a grid of [DishCard]s.
/// Starts by showing 6 cards; "Load more" reveals up to 4 additional ones
/// (10 total, capped by however many rows actually exist for this
/// cuisine) and then relabels itself "See less" to collapse back to 6.
class CuisineFoodScreen extends StatefulWidget {
  const CuisineFoodScreen({super.key, required this.cuisineName});

  /// e.g. "Filipino Cuisine" — shown as the page title and used as the
  /// SQLite `WHERE cuisine = ?` filter.
  final String cuisineName;

  @override
  State<CuisineFoodScreen> createState() => _CuisineFoodScreenState();
}

class _CuisineFoodScreenState extends State<CuisineFoodScreen> {
  late final String _backgroundUrl;
  late final Future<List<Dish>> _dishesFuture;

  static const int _baseCount = 6;
  static const int _extraCount = 4;

  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _backgroundUrl = randomImageUrl(800, 1600);
    _dishesFuture = DatabaseHelper.instance.getByCuisine(widget.cuisineName);
  }

  void _toggleExpanded() {
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AssetOrFallback(
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
                Text(
                  widget.cuisineName,
                  style: const TextStyle(
                    fontSize: 20,
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
                const SizedBox(height: 18),
                Expanded(
                  child: FutureBuilder<List<Dish>>(
                    future: _dishesFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }

                      final allDishes = snapshot.data!;
                      if (allDishes.isEmpty) {
                        return const Center(
                          child: Text(
                            'No dishes found for this cuisine yet.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      final maxCount =
                          allDishes.length < (_baseCount + _extraCount)
                              ? allDishes.length
                              : _baseCount + _extraCount;
                      final baseCount = allDishes.length < _baseCount
                          ? allDishes.length
                          : _baseCount;
                      final itemCount = _expanded ? maxCount : baseCount;
                      final visibleDishes = allDishes.take(itemCount).toList();
                      final canLoadMore = allDishes.length > _baseCount;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: visibleDishes.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                                childAspectRatio: 0.95,
                              ),
                              itemBuilder: (context, index) {
                                final dish = visibleDishes[index];
                                return DishCard(
                                  dish: dish,
                                  onTap: () => showDishDetail(context, dish),
                                );
                              },
                            ),
                            if (canLoadMore) ...[
                              const SizedBox(height: 18),
                              _LoadMoreButton(
                                label: _expanded ? 'See less' : 'Load more',
                                onTap: _toggleExpanded,
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Extra clearance so the button/grid sits well above the
                // "?" button's row instead of level with it.
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

          // Explicit back control — always returns to the home page this
          // screen was opened from.
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

class _LoadMoreButton extends StatelessWidget {
  const _LoadMoreButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.75),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
