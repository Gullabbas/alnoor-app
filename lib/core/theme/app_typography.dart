import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle display(bool isUrdu, {Color? color}) {
    if (isUrdu) {
      return GoogleFonts.notoNastaliqUrdu(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.6,
        color: color ?? AppColors.ink,
      );
    }
    return GoogleFonts.plusJakartaSans(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.8,
      height: 1.25,
      color: color ?? AppColors.ink,
    );
  }

  static TextStyle h1(bool isUrdu, {Color? color}) {
    if (isUrdu) {
      return GoogleFonts.notoNastaliqUrdu(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.5,
        color: color ?? AppColors.ink,
      );
    }
    return GoogleFonts.plusJakartaSans(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      height: 1.25,
      color: color ?? AppColors.ink,
    );
  }

  static TextStyle h2(bool isUrdu, {Color? color}) {
    if (isUrdu) {
      return GoogleFonts.notoNastaliqUrdu(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: color ?? AppColors.ink,
      );
    }
    return GoogleFonts.plusJakartaSans(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.3,
      height: 1.3,
      color: color ?? AppColors.ink,
    );
  }

  static TextStyle h3(bool isUrdu, {Color? color}) {
    if (isUrdu) {
      return GoogleFonts.notoSansArabic(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        height: 1.4,
        color: color ?? AppColors.ink,
      );
    }
    return GoogleFonts.plusJakartaSans(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      height: 1.3,
      color: color ?? AppColors.ink,
    );
  }

  static TextStyle title(bool isUrdu, {Color? color, FontWeight? weight}) {
    if (isUrdu) {
      return GoogleFonts.notoSansArabic(
        fontSize: 15,
        fontWeight: weight ?? FontWeight.w600,
        height: 1.4,
        color: color ?? AppColors.ink,
      );
    }
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: weight ?? FontWeight.w600,
      letterSpacing: -0.2,
      height: 1.4,
      color: color ?? AppColors.ink,
    );
  }

  static TextStyle body(bool isUrdu, {Color? color, FontWeight? weight}) {
    if (isUrdu) {
      return GoogleFonts.notoSansArabic(
        fontSize: 14,
        fontWeight: weight ?? FontWeight.w400,
        height: 1.5,
        color: color ?? AppColors.inkSoft,
      );
    }
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: weight ?? FontWeight.w400,
      height: 1.5,
      color: color ?? AppColors.inkSoft,
    );
  }

  static TextStyle caption(bool isUrdu, {Color? color, FontWeight? weight}) {
    if (isUrdu) {
      return GoogleFonts.notoSansArabic(
        fontSize: 12,
        fontWeight: weight ?? FontWeight.w400,
        height: 1.4,
        color: color ?? AppColors.inkLighter,
      );
    }
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: weight ?? FontWeight.w400,
      letterSpacing: 0.1,
      height: 1.4,
      color: color ?? AppColors.inkLighter,
    );
  }

  static TextStyle button(bool isUrdu, {Color? color}) {
    if (isUrdu) {
      return GoogleFonts.notoSansArabic(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.white,
      );
    }
    return GoogleFonts.plusJakartaSans(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
      color: color ?? Colors.white,
    );
  }
}
