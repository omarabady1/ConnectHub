import 'package:connect_hub/features/create_post/presentation/views/create_post_view.dart';
import 'package:flutter/material.dart';
import '../../../../../constants.dart';

class HomeBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onItemTapped;

  const HomeBottomNavBar({
    super.key,
    this.selectedIndex = 0,
    this.onItemTapped,
  });

  @override
  State<HomeBottomNavBar> createState() => _HomeBottomNavBarState();
}

class _HomeBottomNavBarState extends State<HomeBottomNavBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  void _onItemClick(int index) {
    if (index == 1) {
      Navigator.of(context).pushNamed(CreatePostView.routeName);
      return;
    }
    setState(() {
      _currentIndex = index;
    });
    if (widget.onItemTapped != null) {
      widget.onItemTapped!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final navItems = [
      Icons.home_rounded,
      Icons.add_circle_outline_rounded,
      Icons.auto_awesome_outlined,
      Icons.person_outline_rounded,
    ];

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: kHomeBackgroundColor.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: kBrandIndigo.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final isSelected = _currentIndex == index;
          return InkWell(
            onTap: () => _onItemClick(index),
            borderRadius: BorderRadius.circular(22),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    navItems[index],
                    color: isSelected
                        ? kBrandIndigo
                        : kTextDarkColor.withValues(alpha: 0.5),
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isSelected ? 4 : 0,
                    height: isSelected ? 4 : 0,
                    decoration: const BoxDecoration(
                      color: kBrandIndigo,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
