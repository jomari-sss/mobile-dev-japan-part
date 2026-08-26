import 'dart:math';
import 'package:flutter/material.dart';

import 'dish.dart';

/// Shared random-photo helper, used by every screen. Only the images
/// change — every string of copy in this app is hard-coded and stays put.
final Random appRandom = Random();

String randomImageUrl(int width, int height) {
  final seed = appRandom.nextInt(1 << 32);
  return 'https://picsum.photos/seed/$seed/$width/$height';
}

/// Shows your own image from assets/images/ if it's there; otherwise shows
/// [placeholder] instead of crashing. This is what makes every "insert
/// your own image" slot in this app safe to leave empty — drop a file at
/// [assetPath] whenever you're ready and it takes over automatically, no
/// code changes needed.
class AssetOrFallback extends StatelessWidget {
  const AssetOrFallback({
    super.key,
    required this.assetPath,
    required this.placeholder,
    this.fit = BoxFit.cover,
  });

  /// e.g. 'assets/images/home_background.jpg'
  final String assetPath;
  final Widget placeholder;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => placeholder,
    );
  }
}

/// Reused on every screen: a small dark circular "?" button.
class HelpButton extends StatelessWidget {
  const HelpButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.55),
          border: Border.all(color: Colors.white54, width: 1.5),
        ),
        child: const Text(
          '?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// A small dark circular back-arrow button, styled to match [HelpButton].
/// Named `CircleBackButton` (not `BackButton`) so it doesn't collide with
/// Flutter's own built-in `BackButton` widget from material.dart.
class CircleBackButton extends StatelessWidget {
  const CircleBackButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.55),
          border: Border.all(color: Colors.white54, width: 1.5),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}

/// One dish tile: photo on top (from [Dish.imagePath], via
/// [AssetOrFallback] so a missing file never crashes the app), name below.
/// Reused by CuisineFoodScreen's grid and the ingredient search results.
class DishCard extends StatelessWidget {
  const DishCard({super.key, required this.dish, required this.onTap});

  final Dish dish;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      shadowColor: Colors.black45,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AssetOrFallback(
                    assetPath: dish.imagePath,
                    placeholder: const Center(
                      child: Text('🍅🍅', style: TextStyle(fontSize: 24)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                dish.foodName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Opens [dish]'s detail as a dialog floating over the current screen.
/// Closing it (via the "X" or tapping outside) just pops the dialog,
/// leaving whatever grid was underneath exactly as it was.
void showDishDetail(BuildContext context, Dish dish) {
  showDialog(
    context: context,
    builder: (_) => DishDetailDialog(dish: dish),
  );
}

class DishDetailDialog extends StatelessWidget {
  const DishDetailDialog({super.key, required this.dish});

  final Dish dish;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "X" closes the dialog, returning to the grid underneath.
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: AssetOrFallback(
                    assetPath: dish.imagePath,
                    placeholder: const Center(
                      child: Text('🍅🍅', style: TextStyle(fontSize: 46)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                dish.foodName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Recipes:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              for (final ingredient in dish.ingredients)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    ingredient,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
