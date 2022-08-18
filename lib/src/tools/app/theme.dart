/// The app's themes.
/// This class is just there to connect readable names
/// to integer theme IDs.
class AppThemes {
  static const int LightBlue = 0;
  static const int DarkBlue = 2;

  static String toStr(int themeId) {
    switch (themeId) {
      case LightBlue:
        return "Light Blue";
      case DarkBlue:
        return "Dark Blue";
      default:
        return "Unknown";
    }
  }
}
