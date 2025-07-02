import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class ConfiguracionPage extends StatefulWidget {
  const ConfiguracionPage({super.key});

  @override
  State<ConfiguracionPage> createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends State<ConfiguracionPage> {
  String _tema = 'claro';
  double _tamano = 16.0;
  String _fuente = 'Roboto';
  String _idioma = 'es';

  final List<String> fuentes = ['Roboto', 'Courier', 'Times New Roman'];

  final Map<String, String> idiomasDisplay = {
    'es': 'Español',
    'en': 'Inglés',
  };

  void _guardarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tema', _tema);
    await prefs.setDouble('tamano', _tamano);
    await prefs.setString('fuente', _fuente);
    await prefs.setString('idioma', _idioma);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
  }

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
  }

  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tema = prefs.getString('tema') ?? 'claro';
      _tamano = prefs.getDouble('tamano') ?? 16.0;
      _fuente = prefs.getString('fuente') ?? 'Roboto';
      _idioma = prefs.getString('idioma') ?? 'es';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _tema == 'oscuro';

    return Scaffold(
      appBar: AppBar(
        title: Text(_idioma == 'en' ? 'Settings' : 'Configuración'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? Colors.grey[900] : Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildSectionTitle(_idioma == 'en' ? 'Language' : 'Idioma'),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _idioma,
                          onChanged: (value) => setState(() => _idioma = value!),
                          items: idiomasDisplay.entries
                              .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                              .toList(),
                          icon: const Icon(Icons.language),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle(_idioma == 'en' ? 'Theme' : 'Tema'),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _tema,
                          onChanged: (value) => setState(() => _tema = value!),
                          items: [
                            DropdownMenuItem(value: 'claro', child: Text(_idioma == 'en' ? 'Light' : 'Claro')),
                            DropdownMenuItem(value: 'oscuro', child: Text(_idioma == 'en' ? 'Dark' : 'Oscuro')),
                          ],
                          icon: const Icon(Icons.color_lens_outlined),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle(_idioma == 'en' ? 'Font Size' : 'Tamaño de letra'),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Slider(
                        value: _tamano,
                        min: 12,
                        max: 32,
                        divisions: 10,
                        label: _tamano.round().toString(),
                        onChanged: (value) => setState(() => _tamano = value),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionTitle(_idioma == 'en' ? 'Font' : 'Fuente'),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _fuente,
                          onChanged: (value) => setState(() => _fuente = value!),
                          items: fuentes.map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                          icon: const Icon(Icons.font_download_outlined),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      onPressed: _guardarPreferencias,
                      child: Text(_idioma == 'en' ? 'Save and continue' : 'Guardar y continuar'),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '© Kevin Butrón',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        texto,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 0.7),
      ),
    );
  }
}
