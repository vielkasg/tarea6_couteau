import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/button.dart';

class GeneroScreen extends StatefulWidget {
  const GeneroScreen({super.key});

  @override
  State<GeneroScreen> createState() => _GeneroScreenState();
}

class _GeneroScreenState extends State<GeneroScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  Map<String, dynamic>? _result;
  String? _error;

  Future<void> _checkGender() async {
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
      final result = await ApiService.getGender(_nameController.text.trim());
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

  Color get _genderColor {
    if (_result == null || _result!['gender'] == null) {
      return const Color(0xFFFFB074);
    }
    return _result!['gender'] == 'male' 
        ? Colors.blue.shade400 
        : Colors.pink.shade300;
  }

  String get _genderText {
    if (_result == null || _result!['gender'] == null) {
      return 'No determinado';
    }
    return _result!['gender'] == 'male' ? 'Masculino' : 'Femenino';
  }

  IconData get _genderIcon {
    if (_result == null || _result!['gender'] == null) {
      return Icons.help_outline;
    }
    return _result!['gender'] == 'male' ? Icons.male : Icons.female;
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
        title: const Text('Predicción de Género'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFFF5EE),
              _genderColor.withOpacity(0.1),
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
                        color: _genderColor.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_search,
                        size: 60,
                        color: _genderColor,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'Ingresa un nombre',
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: _genderColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Predecir Género',
                        onPressed: _checkGender,
                        isLoading: _isLoading,
                        backgroundColor: _genderColor,
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
                          color: _genderColor.withOpacity(0.2),
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
                            color: _genderColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _genderIcon,
                            size: 60,
                            color: _genderColor,
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: _genderColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _genderText,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: _genderColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        if (_result!['probability'] != null) ...[
                          Text(
                            'Probabilidad',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 5),
                          LinearProgressIndicator(
                            value: _result!['probability'],
                            backgroundColor: _genderColor.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(_genderColor),
                            minHeight: 8,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '${(_result!['probability'] * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _genderColor,
                            ),
                          ),
                        ],
                        if (_result!['count'] != null) ...[
                          const SizedBox(height: 10),
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
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}