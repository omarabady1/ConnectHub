import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../constants.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onItemTapped;

  const HomeBottomNavBar({
    super.key,
    this.selectedIndex = 0,
    this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
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
        children: List.generate(3, (index) {
          final isSelected = selectedIndex == index;
          return InkWell(
            onTap: () => onItemTapped?.call(index),
            borderRadius: BorderRadius.circular(22),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIcon(index, isSelected),
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

  Widget _buildIcon(int index, bool isSelected) {
    final activeColor = kBrandIndigo;
    final inactiveColor = kTextDarkColor.withValues(alpha: 0.5);

    if (index == 1) {
      return SvgPicture.asset(
        'assets/icons/chatbot_icon.svg',
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(
          isSelected ? activeColor : inactiveColor,
          BlendMode.srcIn,
        ),
      );
    }

    final icons = [
      Icons.home_rounded,
      Icons.home_rounded,
      Icons.person_outline_rounded,
    ];

    return Icon(
      icons[index],
      color: isSelected ? activeColor : inactiveColor,
      size: 24,
    );
  }
}
