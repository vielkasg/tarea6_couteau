import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String openWeatherApiKey = 'YOUR_API_KEY_HERE';
  
  // G�nero API
  static Future<Map<String, dynamic>> getGender(String name) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.genderize.io/?name=$name'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener genero');
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }
  
  // Edad API
  static Future<Map<String, dynamic>> getAge(String name) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.agify.io/?name=$name'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener edad');
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }
  
  // Universidades API
  static Future<List<dynamic>> getUniversities(String country) async {
    try {
      final response = await http.get(
        Uri.parse('http://universities.hipolabs.com/search?country=$country'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener universidades');
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }
  
  // Clima API (usando OpenWeatherMap)
  static Future<Map<String, dynamic>> getWeather() async {
    try {
      // Santo Domingo, Repeblica Dominicana
      const lat = 18.4861;
      const lon = -69.9312;
      final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$openWeatherApiKey&units=metric&lang=es';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        // Si no hay API key, devolver datos de ejemplo
        return {
          'name': 'Santo Domingo',
          'main': {
            'temp': 28.5,
            'feels_like': 31.2,
            'humidity': 75,
          },
          'weather': [{
            'main': 'Clouds',
            'description': 'nubes dispersas',
            'icon': '03d'
          }],
          'wind': {
            'speed': 3.6
          }
        };
      } else {
        throw Exception('Error al obtener clima');
      }
    } catch (e) {
      // Devolver datos de ejemplo en caso de error
      return {
        'name': 'Santo Domingo',
        'main': {
          'temp': 28.5,
          'feels_like': 31.2,
          'humidity': 75,
        },
        'weather': [{
          'main': 'Clouds',
          'description': 'nubes dispersas',
          'icon': '03d'
        }],
        'wind': {
          'speed': 3.6
        }
      };
    }
  }
  
  // Pokemon API
  static Future<Map<String, dynamic>> getPokemon(String name) async {
    try {
      final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/${name.toLowerCase()}'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Pokemon no encontrado');
      }
    } catch (e) {
      throw Exception('Error de conexion: $e');
    }
  }
  
  // WordPress API para noticias
  static Future<List<dynamic>> getNews() async {
    try {
      final response = await http.get(
        Uri.parse('https://techcrunch.com/wp-json/wp/v2/posts?per_page=3'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener noticias');
      }
    } catch (e) {
      // Si falla TechCrunch, intentar con otro sitio
      try {
        final response = await http.get(
          Uri.parse('https://css-tricks.com/wp-json/wp/v2/posts?per_page=3'),
        );
        if (response.statusCode == 200) {
          return json.decode(response.body);
        }
      } catch (_) {}
      throw Exception('Error de conexion: $e');
    }
  }
}