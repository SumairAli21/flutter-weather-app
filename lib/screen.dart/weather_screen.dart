import 'package:flutter/material.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/widgets/weather_api.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<WeatherScreen> {
  TextEditingController cityCont = TextEditingController();
  WeatherModel? weatherData;

  bool isLoading = false;

  final String apiKey = '7b3b73136f46fc58b8e6d4e5c15dab50';
  late GetWeatherApi weatherApi;

  @override
  void initState() {
    super.initState();
    weatherApi = GetWeatherApi(apiKey);
  }

  Future<void> fetchWeather() async {
    String cityName = cityCont.text.trim();
    cityCont.clear();

    setState(() {
      isLoading = true;
    });

    try {
      WeatherModel weather = await weatherApi.getWeatherApi(cityName);
      setState(() {
        weatherData = weather;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to load weather data :('),
      ));
    }
  }

  String getWeatherImage(String? mainCondition) {
    if (mainCondition == null) return 'assets/images/default.jpg';

    switch (mainCondition.toLowerCase()) {
      case 'mist':
        return 'assets/images/foggy.jpg';
      case 'smoke':
        return 'assets/images/smoke.jpg';
      case 'haze':
        return 'assets/images/haze.jpg';
      case 'fog':
        return 'assets/images/foggy.jpg';
      case 'clouds':
        return 'assets/images/cloudy.jpg';
      case 'drizzle':
        return 'assets/images/drizz.jpg';
      case 'rain':
      case 'shower rain':
        return 'assets/images/rain.jpg';
      case 'snow':
        return 'assets/images/snow.jpg';
      case 'clear':
        return 'assets/images/sunny.jpg';
      case 'thunderstorm':
        return 'assets/images/thunder.jpg';
      default:
        return 'assets/images/default.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (weatherData != null)
              Positioned.fill(
                child: Image.asset(
                  getWeatherImage(weatherData!.mainCondition),
                  fit: BoxFit.cover,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: cityCont,
                          decoration: InputDecoration(
                            hintText: "Enter (City, State, or Country)",
                            hintStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.white70,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox.square(
                        dimension: 50,
                        child: FloatingActionButton(
                          onPressed: fetchWeather,
                          backgroundColor: Colors.white,
                          child: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : weatherData != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.location_on,
                                size: 24, color: Colors.white),
                            Text(
                              weatherData!.cityName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                      color: Colors.white.withOpacity(
                                          0.9)), // Increased brightness
                            ),
                            const SizedBox(height: 10),
                            Text(
                              weatherData!.mainCondition,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                      color: Colors.white.withOpacity(
                                          0.9)), // Increased brightness
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "${weatherData!.temperature.toString()} °C",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: Colors.white.withOpacity(0.9)),
                            ),
                          ],
                        )
                      : const Text(
                          "Enter a State/city or country to get the weather",
                          style: TextStyle(color: Colors.white),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
