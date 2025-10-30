import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ClimaScreen extends StatefulWidget {
  const ClimaScreen({super.key});

  @override
  State<ClimaScreen> createState() => _ClimaScreenState();
}

class _ClimaScreenState extends State<ClimaScreen> {
  Map<String, dynamic>? _weatherData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await ApiService.getWeather();
      setState(() {
        _weatherData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  IconData _getWeatherIcon(String? main) {
    switch (main?.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.umbrella;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'drizzle':
        return Icons.grain;
      default:
        return Icons.wb_sunny;
    }
  }

  Color _getWeatherColor(String? main) {
    switch (main?.toLowerCase()) {
      case 'clear':
        return Colors.orange;
      case 'clouds':
        return Colors.blueGrey;
      case 'rain':
        return Colors.blue;
      case 'snow':
        return Colors.lightBlue;
      case 'thunderstorm':
        return Colors.deepPurple;
      case 'drizzle':
        return Colors.teal;
      default:
        return const Color(0xFFFFBE0B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherMain = _weatherData?['weather']?[0]?['main'];
    final weatherColor = _getWeatherColor(weatherMain);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima en República Dominicana'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              weatherColor.withOpacity(0.1),
              const Color(0xFFFFF5EE),
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFFBE0B),
                  ),
                )
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Error al cargar el clima',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.red.shade700,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _loadWeather,
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadWeather,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(30),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: weatherColor.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: weatherColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _getWeatherIcon(weatherMain),
                                      size: 80,
                                      color: weatherColor,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    _weatherData?['name'] ?? 'Santo Domingo',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'República Dominicana',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    '${_weatherData?['main']?['temp']?.toStringAsFixed(1) ?? '0'}°C',
                                    style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      color: weatherColor,
                                    ),
                                  ),
                                  Text(
                                    _weatherData?['weather']?[0]?['description'] ?? '',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'Sensación térmica: ${_weatherData?['main']?['feels_like']?.toStringAsFixed(1) ?? '0'}°C',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildInfoCard(
                                    icon: Icons.water_drop,
                                    title: 'Humedad',
                                    value: '${_weatherData?['main']?['humidity'] ?? 0}%',
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildInfoCard(
                                    icon: Icons.air,
                                    title: 'Viento',
                                    value: '${_weatherData?['wind']?['speed'] ?? 0} m/s',
                                    color: Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildInfoCard(
                                    icon: Icons.thermostat,
                                    title: 'Mínima',
                                    value: '${_weatherData?['main']?['temp_min']?.toStringAsFixed(1) ?? '0'}°C',
                                    color: Colors.cyan,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildInfoCard(
                                    icon: Icons.thermostat,
                                    title: 'Máxima',
                                    value: '${_weatherData?['main']?['temp_max']?.toStringAsFixed(1) ?? '0'}°C',
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: weatherColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: weatherColor.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.update,
                                    size: 16,
                                    color: weatherColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Desliza hacia abajo para actualizar',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: weatherColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 30,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}