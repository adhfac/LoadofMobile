import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contoh Stateful Widget'),
        ),
        body: const CounterWidget(),
      ),
    );
  }
}


class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Anda telah menekan tombol sebanyak $_counter kali'),
          const SizedBox(height: 18,),
          Row(
            children: [
              ElevatedButton(
                onPressed: _incrementCounter,

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  // Ubah warna background button
                  backgroundColor: Colors.blue,
                ),

                child: const Text('+', style: TextStyle(color: Colors.white),),
              ),

              ElevatedButton(
                  onPressed: _decrementCounter,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    // Ubah warna background button
                    backgroundColor: Colors.red,
                  ),
                child: const Text('-', style: TextStyle(color: Colors.white),)
              )
            ],
          ),

        ],
      ),
    );
  }


}