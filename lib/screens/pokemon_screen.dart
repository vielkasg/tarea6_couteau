import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/api_service.dart';
import '../widgets/button.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _pokemonData;
  bool _isLoading = false;
  String? _error;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    _searchController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _searchPokemon() async {
    if (_searchController.text.trim().isEmpty) {
      setState(() {
        _error = 'Por favor, ingresa el nombre del Pok�mon';
        _pokemonData = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _pokemonData = null;
    });

    try {
      final data = await ApiService.getPokemon(_searchController.text.trim());
      setState(() {
        _pokemonData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Pok�mon no encontrado';
        _isLoading = false;
      });
    }
  }

  void _playCry() async {
    if (_pokemonData?['cries']?['latest'] != null) {
      try {
        await _audioPlayer.play(UrlSource(_pokemonData!['cries']['latest']));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo reproducir el sonido'),
          ),
        );
      }
    }
  }

  Color _getTypeColor(String type) {
    final typeColors = {
      'normal': const Color(0xFFA8A878),
      'fire': const Color(0xFFF08030),
      'water': const Color(0xFF6890F0),
      'grass': const Color(0xFF78C850),
      'electric': const Color(0xFFF8D030),
      'ice': const Color(0xFF98D8D8),
      'fighting': const Color(0xFFC03028),
      'poison': const Color(0xFFA040A0),
      'ground': const Color(0xFFE0C068),
      'flying': const Color(0xFFA890F0),
      'psychic': const Color(0xFFF85888),
      'bug': const Color(0xFFA8B820),
      'rock': const Color(0xFFB8A038),
      'ghost': const Color(0xFF705898),
      'dark': const Color(0xFF705848),
      'dragon': const Color(0xFF7038F8),
      'steel': const Color(0xFFB8B8D0),
      'fairy': const Color(0xFFEE99AC),
    };
    return typeColors[type] ?? const Color(0xFF68A090);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscador de Pok�mon'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF5EE),
              Color(0xFFFFE0EC),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF006E).withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.catching_pokemon,
                        size: 60,
                        color: Color(0xFFFF006E),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _searchController,
                        textCapitalization: TextCapitalization.none,
                        decoration: const InputDecoration(
                          hintText: 'Nombre del Pok�mon (ej: pikachu)',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFFFF006E),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Buscar Pok�mon',
                        onPressed: _searchPokemon,
                        isLoading: _isLoading,
                        backgroundColor: const Color(0xFFFF006E),
                        icon: Icons.catching_pokemon,
                      ),
                    ],
                  ),
                ),
                if (_error != null) ...[  
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade400),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _error!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (_pokemonData != null) ...[  
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        if (_pokemonData!['sprites']?['other']?['official-artwork']?['front_default'] != null)
                          CachedNetworkImage(
                            imageUrl: _pokemonData!['sprites']['other']['official-artwork']['front_default'],
                            height: 200,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          )
                        else if (_pokemonData!['sprites']?['front_default'] != null)
                          CachedNetworkImage(
                            imageUrl: _pokemonData!['sprites']['front_default'],
                            height: 150,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        const SizedBox(height: 20),
                        Text(
                          (_pokemonData!['name'] as String).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        Text(
                          '#${_pokemonData!['id'].toString().padLeft(4, '0')}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 15),
                        if (_pokemonData!['types'] != null)
                          Wrap(
                            spacing: 10,
                            children: (_pokemonData!['types'] as List).map<Widget>((type) {
                              final typeName = type['type']['name'] as String;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getTypeColor(typeName),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  typeName.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStat('Altura', '${(_pokemonData!['height'] / 10).toStringAsFixed(1)} m'),
                            _buildStat('Peso', '${(_pokemonData!['weight'] / 10).toStringAsFixed(1)} kg'),
                            _buildStat('Exp. Base', _pokemonData!['base_experience'].toString()),
                          ],
                        ),
                        if (_pokemonData!['cries']?['latest'] != null) ...[  
                          const SizedBox(height: 20),
                          CustomButton(
                            text: 'Reproducir Grito',
                            onPressed: _playCry,
                            backgroundColor: const Color(0xFFFF006E),
                            icon: Icons.volume_up,
                            width: 200,
                            height: 45,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (_pokemonData!['abilities'] != null) ...[  
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Habilidades',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: (_pokemonData!['abilities'] as List).map<Widget>((ability) {
                              final abilityName = ability['ability']['name'] as String;
                              final isHidden = ability['is_hidden'] as bool;
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isHidden
                                      ? Colors.purple.withOpacity(0.1)
                                      : const Color(0xFFFF006E).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: isHidden
                                        ? Colors.purple.withOpacity(0.3)
                                        : const Color(0xFFFF006E).withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      abilityName.replaceAll('-', ' ').toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isHidden ? Colors.purple : const Color(0xFFFF006E),
                                      ),
                                    ),
                                    if (isHidden) ...[
                                      const SizedBox(width: 5),
                                      const Icon(
                                        Icons.visibility_off,
                                        size: 14,
                                        color: Colors.purple,
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}