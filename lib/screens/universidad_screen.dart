import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../widgets/button.dart';

class UniversidadScreen extends StatefulWidget {
  const UniversidadScreen({super.key});

  @override
  State<UniversidadScreen> createState() => _UniversidadScreenState();
}

class _UniversidadScreenState extends State<UniversidadScreen> {
  final TextEditingController _countryController = TextEditingController();
  bool _isLoading = false;
  List<dynamic> _universities = [];
  String? _error;

  Future<void> _searchUniversities() async {
    if (_countryController.text.trim().isEmpty) {
      setState(() {
        _error = 'Por favor, ingresa un país en inglés';
        _universities = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _universities = [];
    });

    try {
      final result = await ApiService.getUniversities(_countryController.text.trim());
      setState(() {
        _universities = result;
        _isLoading = false;
        if (_universities.isEmpty) {
          _error = 'No se encontraron universidades para este país';
        }
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _launchURL(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir el enlace'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Universidades'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF5EE),
              Color(0xFFE8F5F5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4ECDC4).withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.school,
                        size: 60,
                        color: Color(0xFF4ECDC4),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _countryController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'País en inglés (ej: Dominican Republic)',
                          prefixIcon: Icon(
                            Icons.public,
                            color: Color(0xFF4ECDC4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Buscar Universidades',
                        onPressed: _searchUniversities,
                        isLoading: _isLoading,
                        backgroundColor: const Color(0xFF4ECDC4),
                        icon: Icons.search,
                      ),
                    ],
                  ),
                ),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
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
                ),
              if (_universities.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4ECDC4).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          '${_universities.length} universidades encontradas',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4ECDC4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _universities.length,
                  itemBuilder: (context, index) {
                    final university = _universities[index];
                    final name = university['name'] ?? 'Sin nombre';
                    final domains = university['domains'] as List? ?? [];
                    final webPages = university['web_pages'] as List? ?? [];
                    final country = university['country'] ?? '';
                    final stateProvince = university['state-province'] ?? '';
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: webPages.isNotEmpty
                              ? () => _launchURL(webPages[0])
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4ECDC4).withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.school,
                                        size: 25,
                                        color: Color(0xFF4ECDC4),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF2C3E50),
                                            ),
                                          ),
                                          if (stateProvince.isNotEmpty) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              '$stateProvince, $country',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (domains.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.language,
                                        size: 16,
                                        color: Colors.grey[500],
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        domains[0],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                if (webPages.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4ECDC4),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: const Row(
                                          children: [
                                            Text(
                                              'Visitar sitio',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Icon(
                                              Icons.arrow_forward,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}