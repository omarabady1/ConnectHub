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
}
