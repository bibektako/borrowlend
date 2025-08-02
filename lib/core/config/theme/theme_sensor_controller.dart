import 'dart:async';
import 'package:borrowlend/core/config/theme/theme_cubit.dart';
import 'package:light/light.dart';

class ThemeSensorController {
  final ThemeCubit _themeCubit;
  StreamSubscription? _lightSubscription;

  ThemeSensorController(this._themeCubit);

  /// Starts listening to the ambient light sensor.
  void init() {
    try {
      // Get a stream of lux values from the sensor.
      final lightStream = Light().lightSensorStream;
      
      _lightSubscription = lightStream.listen(
        (luxValue) {
          // Pass the sensor data to the cubit.
          _themeCubit.updateThemeFromSensor(luxValue);
        },
        onError: (error) {
          print("Error reading light sensor: $error");
          dispose(); // Stop listening on error
        },
      );
    } catch (e) {
      print("Light sensor not available: $e");
    }
  }

  /// Stops listening to the sensor to prevent memory leaks.
  void dispose() {
    _lightSubscription?.cancel();
  }
}