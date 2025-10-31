import 'package:flutter/material.dart';
import '../widgets/button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFF5EE),
              const Color(0xFFFFB074).withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFB074).withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.construction,
                        size: 80,
                        color: const Color(0xFFFFB074),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Caja de Herramientas',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Tu kit de utilidades todo en uno',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      ToolButton(
                        title: 'Genero',
                        icon: Icons.person_outline,
                        color: const Color(0xFF6C63FF),
                        onTap: () => Navigator.pushNamed(context, '/genero'),
                      ),
                      ToolButton(
                        title: 'Edad',
                        icon: Icons.cake_outlined,
                        color: const Color(0xFFFF6B6B),
                        onTap: () => Navigator.pushNamed(context, '/edad'),
                      ),
                      ToolButton(
                        title: 'Universidades',
                        icon: Icons.school_outlined,
                        color: const Color(0xFF4ECDC4),
                        onTap: () => Navigator.pushNamed(context, '/universidad'),
                      ),
                      ToolButton(
                        title: 'Clima',
                        icon: Icons.wb_sunny_outlined,
                        color: const Color(0xFFFFBE0B),
                        onTap: () => Navigator.pushNamed(context, '/clima'),
                      ),
                      ToolButton(
                        title: 'Pokemon',
                        icon: Icons.catching_pokemon,
                        color: const Color(0xFFFF006E),
                        onTap: () => Navigator.pushNamed(context, '/pokemon'),
                      ),
                      ToolButton(
                        title: 'Noticias',
                        icon: Icons.newspaper_outlined,
                        color: const Color(0xFF8338EC),
                        onTap: () => Navigator.pushNamed(context, '/noticias'),
                      ),
                      ToolButton(
                        title: 'Acerca de',
                        icon: Icons.info_outline,
                        color: const Color(0xFF3A86FF),
                        onTap: () => Navigator.pushNamed(context, '/acercade'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}