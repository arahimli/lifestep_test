/// The app's themes.
/// This class is just there to connect readable names
/// to integer theme IDs.
class AppThemes {
  static const int lightBlue = 0;
  static const int darkBlue = 2;

  static String toStr(int themeId) {
    switch (themeId) {
      case lightBlue:
        return "Light Blue";
      case darkBlue:
        return "Dark Blue";
      default:
        return "Unknown";
    }
  }
}
