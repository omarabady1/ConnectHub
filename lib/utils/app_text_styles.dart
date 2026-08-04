import 'dart:ui';

import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyles {
  static final appBarTitle = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static final cardTitle = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static final cardSubtitle = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static final bodyText = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static final caption = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static final smallLabel = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static final chipLabel = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static final loginTitle = GoogleFonts.inter(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    height: 1.12,
  );

  static final loginSubtitle = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: const Color(0xFF6B7280),
  );

  static final inputLabel = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    height: 1.4,
    color: const Color(0xFF4B5563),
  );

  static final inputText = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: const Color(0xFF111827),
  );

  static final loginButton = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: const Color(0xFFFFFFFF),
  );

  static final linkText = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: const Color(0xFF6366F1),
  );

  static final secondaryText = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: const Color(0xFF6B7280),
  );

  static final splashHeading = GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.18,
  );

  static final splashSlogan = GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.6,
    color: const Color(0xFF6B7280),
  );

  static final homeHeaderTitle = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    color: const Color(0xFF4648D4),
  );

  static final postAuthorName = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF1B1B23),
  );

  static final postAuthorNameSemibold = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF1B1B23),
  );

  static final postSubtitle = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF5C5F61),
  );

  static final postTitleHeading = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: const Color(0xFF1B1B23),
  );

  static final postBody = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: const Color(0xFF464554),
  );

  static final yourPostBadgeText = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: const Color(0xFF4648D4),
  );

  static final hashtagChipText = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF4648D4),
  );

  static final actionCounterText = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF5C5F61),
  );

  static final bentoStatValue = GoogleFonts.inter(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    color: const Color(0xFFFFFBFF),
  );

  static final bentoStatLabel = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: const Color(0xFFFFFBFF),
  );
}
