
import 'package:health/health.dart';


final typesAndroid = [
  // HealthDataType.BLOOD_GLUCOSE,
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.MOVE_MINUTES,
  HealthDataType.DISTANCE_DELTA,
  HealthDataType.STEPS,
];
final typesIOS = [
  HealthDataType.STEPS,
  // HealthDataType.BLOOD_GLUCOSE,
  HealthDataType.BASAL_ENERGY_BURNED,
  // Uncomment this line on iOS - only available on iOS

  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.DISTANCE_WALKING_RUNNING,
];

final typesAndroidOnlySteps = [
  HealthDataType.STEPS,
];
final typesIOSOnlySteps = [
  HealthDataType.STEPS,
];