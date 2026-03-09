import 'dart:ui';
import 'package:flutter/material.dart';

class LiquidGlassNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const LiquidGlassNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<LiquidGlassNavBar> createState() => _LiquidGlassNavBarState();
}

class _LiquidGlassNavBarState extends State<LiquidGlassNavBar>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;
  late List<AnimationController> _bounceControllers;
  late List<Animation<double>> _bounceAnimations;
  int _previousIndex = 0;

  static const _items = [
    _NavItem(icon: Icons.catching_pokemon_rounded, label: 'Pokédex'),
    _NavItem(icon: Icons.favorite_rounded, label: 'Favourites'),
    _NavItem(icon: Icons.auto_awesome_mosaic_rounded, label: 'Types'),
    _NavItem(icon: Icons.shield_rounded, label: 'Team'),
  ];

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.currentIndex;

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 380),
      vsync: this,
    );
    _slideAnimation = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOutCubicEmphasized,
    );

    _bounceControllers = List.generate(
      _items.length,
      (_) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );
    _bounceAnimations = _bounceControllers
        .map(
          (c) => TweenSequence<double>([
            TweenSequenceItem(
              tween: Tween<double>(begin: 1.0, end: 1.28),
              weight: 40,
            ),
            TweenSequenceItem(
              tween: Tween<double>(begin: 1.28, end: 0.92),
              weight: 30,
            ),
            TweenSequenceItem(
              tween: Tween<double>(begin: 0.92, end: 1.0),
              weight: 30,
            ),
          ]).animate(CurvedAnimation(parent: c, curve: Curves.easeOut)),
        )
        .toList();
  }

  @override
  void didUpdateWidget(LiquidGlassNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _previousIndex = oldWidget.currentIndex;
      _slideController
        ..reset()
        ..forward();
      _bounceControllers[widget.currentIndex]
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    for (var c in _bounceControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: safeBottom + 16,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(36),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.38),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Animated pill indicator
                AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, _) {
                    final itemWidth =
                        (MediaQuery.of(context).size.width - 40) /
                            _items.length;
                    final fromX = _previousIndex * itemWidth;
                    final toX = widget.currentIndex * itemWidth;
                    final currentX =
                        fromX + (toX - fromX) * _slideAnimation.value;
                    return Positioned(
                      left: currentX + 8,
                      top: 10,
                      child: Container(
                        width: itemWidth - 16,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.42),
                              Colors.white.withValues(alpha: 0.22),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.55),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.20),
                              blurRadius: 12,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Nav items
                Row(
                  children: List.generate(_items.length, (index) {
                    final isSelected = index == widget.currentIndex;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => widget.onTap(index),
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedBuilder(
                          animation: _bounceAnimations[index],
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _bounceAnimations[index].value,
                              child: child,
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: Icon(
                                  _items[index].icon,
                                  key: ValueKey(isSelected),
                                  size: isSelected ? 24 : 22,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.55),
                                ),
                              ),
                              const SizedBox(height: 3),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: TextStyle(
                                  fontSize: isSelected ? 10.5 : 10,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.55),
                                  letterSpacing: 0.2,
                                ),
                                child: Text(_items[index].label),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
