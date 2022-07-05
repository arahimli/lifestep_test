
import 'package:health/health.dart';

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_NOT_ADDED,
  STEPS_READY,
}


final TypesAndroid = [
  // HealthDataType.BLOOD_GLUCOSE,
  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.MOVE_MINUTES,
  HealthDataType.DISTANCE_DELTA,
  HealthDataType.STEPS,
];
final TypesIOS = [
  HealthDataType.STEPS,
  // HealthDataType.BLOOD_GLUCOSE,
  HealthDataType.BASAL_ENERGY_BURNED,
  // Uncomment this line on iOS - only available on iOS

  HealthDataType.ACTIVE_ENERGY_BURNED,
  HealthDataType.DISTANCE_WALKING_RUNNING,
];

final TypesAndroidOnlySteps = [
  HealthDataType.STEPS,
];
final TypesIOSOnlySteps = [
  HealthDataType.STEPS,
];