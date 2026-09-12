/// App-wide design constants: Spacing grid, radius, limits, and animation durations.
class AppConstants {
  AppConstants._();

  // Spacing System (8px grid)
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;

  // Corner Radii
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusFull = 999.0;

  // Elevations
  static const double elevationLow = 1.0;
  static const double elevationMedium = 3.0;

  // Animation Durations
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animStandard = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);

  // Local Storage Keys
  static const String keyOnboardingComplete = 'taskflow_onboarding_completed';

  // Validation Limits
  static const int minPasswordLength = 6;
}
