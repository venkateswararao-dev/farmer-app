enum DeviceType { xs, sm, md, lg, xl }

class AppBreakpoints {
  static const double xs = 0;
  static const double sm = 360;
  static const double md = 600;
  static const double lg = 840;
  static const double xl = 1200;

  static DeviceType classify(double width) {
    if (width >= xl) return DeviceType.xl;
    if (width >= lg) return DeviceType.lg;
    if (width >= md) return DeviceType.md;
    if (width >= sm) return DeviceType.sm;
    return DeviceType.xs;
  }

  static int gridColumns(double width) {
    if (width >= xl) return 4;
    if (width >= lg) return 3;
    if (width >= md) return 2;
    return 1;
  }

  static double pagePadding(double width) {
    if (width >= lg) return 24.0;
    if (width >= md) return 16.0;
    return 14.0;
  }

  static double maxContentWidth(double width) {
    if (width >= xl) return 1140.0;
    if (width >= lg) return 840.0;
    return width;
  }
}
