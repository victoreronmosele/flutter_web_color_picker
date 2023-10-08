import 'package:flutter/material.dart';
import 'package:html_color_input/html_color_input.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTML Color Input Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const initialColor = Colors.deepPurple;

  Color textColor = initialColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HtmlColorInput(
              initialColor: textColor,
              width: 100,
              height: 50,
              onInput: (color, event) {
                setState(() {
                  textColor = color;
                });
              },
              onChange: (color, event) {
                print('Changed color: $color');
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            SelectableText(
              'The quick brown fox jumps over the lazy dog.',
              style: TextStyle(
                fontSize: 20.0,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
