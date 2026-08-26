import 'dart:math';
import 'package:flutter/material.dart';

import 'cuisine_food_screen.dart';
import 'search_results_screen.dart';
import 'shared_widgets.dart';

void main() {
  runApp(const CookSmarterApp());
}

class CookSmarterApp extends StatelessWidget {
  const CookSmarterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cook Smarter Not Harder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const CookSmarterScreen(),
    );
  }
}

/// ----------------------------------------------------------------------
/// Home screen
/// ----------------------------------------------------------------------
class CookSmarterScreen extends StatefulWidget {
  const CookSmarterScreen({super.key});

  @override
  State<CookSmarterScreen> createState() => _CookSmarterScreenState();
}

class _CookSmarterScreenState extends State<CookSmarterScreen> {
  late final String _backgroundUrl;
  late final String _japaneseUrl;
  late final String _filipinoUrl;
  late final String _europeanUrl;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _backgroundUrl = randomImageUrl(800, 1600);
    _japaneseUrl = randomImageUrl(500, 500);
    _filipinoUrl = randomImageUrl(500, 500);
    _europeanUrl = randomImageUrl(500, 500);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFAQ() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const FAQScreen()),
    );
  }

  void _submitSearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SearchResultsScreen(query: trimmed)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AssetOrFallback(
            //
            //
            // dito background image
            assetPath: 'assets/images/home_background.jpg',
            placeholder: Image.network(_backgroundUrl, fit: BoxFit.cover),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.40),
                  Colors.black.withOpacity(0.15),
                  Colors.black.withOpacity(0.45),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: _submitSearch,
                    textInputAction: TextInputAction.search,
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Search by ingredient…',
                      hintStyle: const TextStyle(color: Colors.black45),
                      prefixIcon:
                          const Icon(Icons.search, color: Colors.black54),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward,
                            color: Colors.black54),
                        onPressed: () => _submitSearch(_searchController.text),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.92),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('🍅', style: TextStyle(fontSize: 36)),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'COOK SMARTER\nNOT HARDER',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      height: 1.15,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: Colors.black87,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                // Three cuisine badges arrange like a revolver cylinder.

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return _RevolverCuisineWheel(
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        onSelect: (item) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => CuisineFoodScreen(
                                cuisineName: item.label.replaceAll('\n', ' '),
                              ),
                            ),
                          );
                        },
                        items: [
                          _CuisineItem(
                            label: 'Japanese\nCuisine',
                            imageUrl: _japaneseUrl,
                            assetPath: 'assets/images/japanese_cuisine.jpg',
                            homeAngle: -pi / 2, // top
                          ),
                          _CuisineItem(
                            label: 'Filipino\nCuisine',
                            imageUrl: _filipinoUrl,
                            assetPath: 'assets/images/filipino_cuisine.jpg',
                            homeAngle: 5 * pi / 6, // bottom-left
                          ),
                          _CuisineItem(
                            label: 'European\nCuisine',
                            imageUrl: _europeanUrl,
                            assetPath: 'assets/images/european_cuisine.jpg',
                            homeAngle: pi / 6, // bottom-right
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // "?" button opens the FAQ screen.
          Positioned(
            bottom: 20,
            right: 18,
            child: HelpButton(onTap: _openFAQ),
          ),
        ],
      ),
    );
  }
}

class _CuisineBadge extends StatelessWidget {
  const _CuisineBadge({
    required this.size,
    required this.label,
    required this.imageUrl,
    required this.assetPath,
  });

  final double size;
  final String label;
  final String imageUrl;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [
            AssetOrFallback(
              assetPath: assetPath,
              placeholder: Image.network(imageUrl, fit: BoxFit.cover),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 0.9,
                  colors: [
                    Colors.black.withOpacity(0.05),
                    Colors.black.withOpacity(0.55),
                  ],
                ),
              ),
            ),
            Center(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: max(11, size * 0.09),
                  height: 1.2,
                  shadows: const [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 6,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CuisineItem {
  const _CuisineItem({
    required this.label,
    required this.imageUrl,
    required this.assetPath,
    required this.homeAngle,
  });

  final String label;
  final String imageUrl;
  final String assetPath;
  final double homeAngle;
}

class _PlacedBadge {
  _PlacedBadge({
    required this.item,
    required this.dx,
    required this.dy,
    required this.size,
    required this.closeness,
  });

  final _CuisineItem item;
  final double dx;
  final double dy;
  final double size;
  final double closeness;
}

// display cusine
class _RevolverCuisineWheel extends StatefulWidget {
  const _RevolverCuisineWheel({
    required this.items,
    required this.size,
    required this.onSelect,
  });

  final List<_CuisineItem> items;
  final Size size;
  final void Function(_CuisineItem item) onSelect;

  @override
  State<_RevolverCuisineWheel> createState() => _RevolverCuisineWheelState();
}

class _RevolverCuisineWheelState extends State<_RevolverCuisineWheel>
    with SingleTickerProviderStateMixin {
  static const double _topAngle = -pi / 2;

  late final AnimationController _controller;
  double _rotation = 0;
  double _rotationStart = 0;
  double _rotationEnd = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(() {
        final t = Curves.easeOutBack.transform(_controller.value);
        setState(() {
          _rotation = _rotationStart + (_rotationEnd - _rotationStart) * t;
        });
      });
  }

// rotate
  void _spinTo(_CuisineItem item) {
    final desired = _topAngle - item.homeAngle;
    final diff = desired - _rotation;
    final wrapped = diff - (2 * pi) * (diff / (2 * pi)).roundToDouble();

    _rotationStart = _rotation;
    _rotationEnd = _rotation + wrapped;
    _controller.forward(from: 0);
  }

  /// If [item] is already sitting at the top, treat the tap as a
  /// selection. Otherwise spin it up to the top first.
  void _handleTap(_CuisineItem item) {
    final currentAngle = _rotation + item.homeAngle;
    final closeness = (cos(currentAngle - _topAngle) + 1) / 2;
    if (closeness > 0.999) {
      widget.onSelect(item);
    } else {
      _spinTo(item);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.size.width;
    final h = widget.size.height;
    final shortSide = min(w, h);
    final baseBadgeSize = shortSide * 0.42;
    final radius = shortSide * 0.32;
    final center = Offset(w / 2, h / 2);

    final placed = widget.items.map((item) {
      final angle = _rotation + item.homeAngle;
      final closeness = (cos(angle - _topAngle) + 1) / 2;
      final scale = 0.82 + 0.36 * closeness;
      final size = baseBadgeSize * scale;
      final dx = center.dx + radius * cos(angle) - size / 2;
      final dy = center.dy + radius * sin(angle) - size / 2;
      return _PlacedBadge(
        item: item,
        dx: dx,
        dy: dy,
        size: size,
        closeness: closeness,
      );
    }).toList()
      ..sort((a, b) => a.closeness.compareTo(b.closeness));

    return Stack(
      children: [
        for (final p in placed)
          Positioned(
            left: p.dx,
            top: p.dy,
            child: GestureDetector(
              onTap: () => _handleTap(p.item),
              child: _CuisineBadge(
                size: p.size,
                label: p.item.label,
                imageUrl: p.item.imageUrl,
                assetPath: p.item.assetPath,
              ),
            ),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 2,
          child: Center(
            child: Text(
              'tap to bring forward · tap again to explore',
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ----------------------------------------------------------------------
/// FAQ screen
/// ----------------------------------------------------------------------
class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  late final String _backgroundUrl;

  // null = nothing selected, every button is at its normal size.
  int? _expandedIndex;

  // Fixed copy — only the background photo behind it is randomized.
  static const List<String> _questions = [
    '1. Privacy & Data Security',
    '2. Functionality & Customization',
    '3. Storage & Installation',
  ];

  @override
  void initState() {
    super.initState();
    _backgroundUrl = randomImageUrl(800, 1600);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AssetOrFallback(
            //
            //
            // image sa background sa FAQ section
            assetPath: 'assets/images/faq_background.jpg',
            placeholder: Image.network(_backgroundUrl, fit: BoxFit.cover),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.55),
                  Colors.black.withOpacity(0.35),
                  Colors.black.withOpacity(0.60),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text('🍅', style: TextStyle(fontSize: 34)),
                        SizedBox(height: 8),
                        Text(
                          'FAQ',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black87,
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  for (var i = 0; i < _questions.length; i++) ...[
                    _FAQButton(
                      label: _questions[i],
                      state: _expandedIndex == null
                          ? _FAQButtonState.normal
                          : (_expandedIndex == i
                              ? _FAQButtonState.expanded
                              : _FAQButtonState.shrunk),
                      onTap: () {
                        setState(() {
                          // Tapping the already-expanded button collapses
                          // everything back to normal size.
                          _expandedIndex = _expandedIndex == i ? null : i;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),

          // Tapping "?" here goes back to the previous screen.
          Positioned(
            bottom: 20,
            right: 18,
            child: HelpButton(
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ),
        ],
      ),
    );
  }
}

enum _FAQButtonState { normal, expanded, shrunk }

class _FAQButton extends StatelessWidget {
  const _FAQButton({
    required this.label,
    required this.state,
    required this.onTap,
  });

  final String label;
  final _FAQButtonState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isExpanded = state == _FAQButtonState.expanded;
    final isShrunk = state == _FAQButtonState.shrunk;

    final verticalPadding = isExpanded ? 20.0 : (isShrunk ? 8.0 : 16.0);
    final fontSize = isShrunk ? 12.0 : 15.0;
    final textOpacity = isShrunk ? 0.55 : 1.0;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      elevation: isExpanded ? 6 : 3,
      shadowColor: Colors.black45,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: verticalPadding,
                horizontal: 22,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      color: Colors.black87.withOpacity(textOpacity),
                      fontWeight: FontWeight.w600,
                      fontSize: fontSize,
                    ),
                    child: Text(label),
                  ),
                  // Answer area is intentionally left blank for now — this
                  // is where the actual FAQ answer content goes later.
                  if (isExpanded) ...[
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: Colors.black12),
                    const SizedBox(height: 90),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
