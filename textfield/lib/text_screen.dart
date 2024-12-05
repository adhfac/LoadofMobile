import 'package:flutter/material.dart';

class TextScreen extends StatefulWidget {
  const TextScreen({super.key});

  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  TextEditingController _controller = TextEditingController();
  String? _inputText;

  void _printInputData() {
    setState(() {
      _inputText = _controller.text; // Perbarui teks yang ditampilkan di layar
    });
  }

  @override
  void dispose() {
    // Jangan lupa untuk membersihkan controller saat tidak dibutuhkan
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hell Break Loose'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  // Wrap TextField with Expanded
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter some text',
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _printInputData,
                    child: Text('Show Input'),
                  ),
                  ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: Text('Go to Home'),
            ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Input Data: $_inputText',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
