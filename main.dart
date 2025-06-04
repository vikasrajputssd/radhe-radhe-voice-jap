import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const RadheApp());
}

class RadheApp extends StatelessWidget {
  const RadheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radhe Radhe Counter',
      home: VoiceCounterPage(),
    );
  }
}

class VoiceCounterPage extends StatefulWidget {
  @override
  _VoiceCounterPageState createState() => _VoiceCounterPageState();
}

class _VoiceCounterPageState extends State<VoiceCounterPage> {
  int _counter = 0;
  late SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _loadCounter();
    _speech = SpeechToText();
  }

  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('radheCount') ?? 0;
    });
  }

  void _saveCounter() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('radheCount', _counter);
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          if (result.recognizedWords.toLowerCase().contains('radhe')) {
            setState(() => _counter++);
            _saveCounter();
          }
        },
      );
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  void _resetCounter() {
    setState(() => _counter = 0);
    _saveCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🌸 Radhe Radhe Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('जप गिनती:', style: TextStyle(fontSize: 24)),
            Text('$_counter', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isListening ? _stopListening : _startListening,
              child: Text(_isListening ? 'सुनना बंद करें' : 'राधे बोलिए'),
            ),
            TextButton(onPressed: _resetCounter, child: Text("Reset"))
          ],
        ),
      ),
    );
  }
}
