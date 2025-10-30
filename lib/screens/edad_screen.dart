import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/button.dart';

class EdadScreen extends StatefulWidget {
  const EdadScreen({super.key});

  @override
  State<EdadScreen> createState() => _EdadScreenState();
}

class _EdadScreenState extends State<EdadScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _result;
  String? _error;

  Future<void> _checkAge() async {
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _error = 'Por favor, ingresa un nombre';
        _result = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      final result = await ApiService.getAge(_nameController.text.trim());
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String get _ageCategory {
    if (_result == null || _result!['age'] == null) return '';
    
    final age = _result!['age'] as int;
    if (age <= 25) return 'Joven';
    if (age <= 60) return 'Adulto';
    return 'Anciano';
  }

  String get _ageEmoji {
    if (_result == null || _result!['age'] == null) return 'S';
    
    final age = _result!['age'] as int;
    if (age <= 25) return '=v';
    if (age <= 60) return '=h';
    return '=t';
  }

  Color get _ageColor {
    if (_result == null || _result!['age'] == null) {
      return const Color(0xFFFFB074);
    }
    
    final age = _result!['age'] as int;
    if (age <= 25) return Colors.green.shade400;
    if (age <= 60) return Colors.blue.shade400;
    return Colors.purple.shade400;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediccion de Edad'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFF5EE),
              _ageColor.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _ageColor.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cake,
                        size: 60,
                        color: _ageColor,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'Ingresa un nombre',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: _ageColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Predecir Edad',
                        onPressed: _checkAge,
                        isLoading: _isLoading,
                        backgroundColor: _ageColor,
                        icon: Icons.search,
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
                if (_result != null) ...[
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _ageColor.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: _ageColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            _ageEmoji,
                            style: const TextStyle(fontSize: 50),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _result!['name'] ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_result!['age'] != null) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: _ageColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${_result!['age']} años',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: _ageColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _ageColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              _ageCategory,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _ageColor,
                              ),
                            ),
                          ),
                        ],
                        if (_result!['count'] != null) ...[
                          const SizedBox(height: 15),
                          Text(
                            'Basado en ${_result!['count']} datos',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: _ageColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: _ageColor.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCategoryInfo('=v', 'Joven', '0-25 años', Colors.green),
                        _buildCategoryInfo('=h', 'Adulto', '26-60 años', Colors.blue),
                        _buildCategoryInfo('=t', 'Anciano', '60+ años', Colors.purple),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryInfo(String emoji, String category, String range, Color color) {
    final isActive = _ageCategory == category;
    return Column(
      children: [
        Text(
          emoji,
          style: TextStyle(
            fontSize: isActive ? 30 : 25,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          category,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? color : Colors.grey[600],
          ),
        ),
        Text(
          range,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}