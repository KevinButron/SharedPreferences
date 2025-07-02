import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'configuracion.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  String tema = 'claro';
  double tamano = 16.0;
  String fuente = 'Roboto';
  String idioma = 'es';

  late AnimationController _animationController;

  Future<void> cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tema = prefs.getString('tema') ?? 'claro';
      tamano = prefs.getDouble('tamano') ?? 16.0;
      fuente = prefs.getString('fuente') ?? 'Roboto';
      idioma = prefs.getString('idioma') ?? 'es';
    });
    _animationController.forward();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    cargarPreferencias();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String getTexto() {
    if (idioma == 'en') {
      return '''
Then the fox appeared:
—Good morning —said the fox.
—Good morning —politely replied the little prince, who turned but saw nothing.
—I’m here —said the voice—, under the apple tree…
—Who are you? —asked the little prince—. You are very pretty…
—I am a fox —said the fox.

—Come play with me —proposed the little prince—. I’m so sad…
—I cannot play with you —said the fox—. I am not tamed.''';
    }
    return '''Fue entonces cuando apareció el zorro:
—Buenos días —dijo el zorro.
—Buenos días —respondió cortésmente el principito, que se volvió pero no vio nada.
—Estoy aquí —dijo la voz—, bajo el manzano…
—¿Quién eres tú? —dijo el principito—. Eres muy bonito…
—Soy un zorro —dijo el zorro.

—Ven a jugar conmigo —le propuso el principito—. Estoy tan triste…
—No puedo jugar contigo —dijo el zorro—. No estoy domesticado.''';
  }

  @override
  Widget build(BuildContext context) {
    final bool oscuro = tema == 'oscuro';
    final Color backgroundColor = oscuro ? Colors.black : Colors.white;
    final Color cardColor = oscuro ? Colors.grey[850]! : Colors.grey[100]!;
    final Color textColor = oscuro ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(idioma == 'en' ? 'Main Screen' : 'Pantalla Principal'),
        backgroundColor: oscuro ? Colors.grey[900] : Colors.blue,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _animationController.drive(CurveTween(curve: Curves.easeIn)),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 6,
                    color: cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            getTexto(),
                            style: TextStyle(
                              fontSize: tamano,
                              fontFamily: fuente,
                              color: textColor,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.settings),
                            label: Text(
                              idioma == 'en' ? 'Change settings' : 'Cambiar configuración',
                              style: const TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: oscuro ? Colors.blueAccent : Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const ConfiguracionPage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '© Kevin Butrón',
                style: TextStyle(
                  color: textColor.withOpacity(0.6),
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
