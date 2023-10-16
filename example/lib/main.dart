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
  static const initialColor = Color(0xff40e0d0);

  Color previewTextColor = initialColor;
  Color textColor = initialColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getEventDescriptionText(
              event: 'onInput',
              supportingText: 'is called each time you select a color.',
              color: previewTextColor,
            ),
            const SizedBox(
              height: 120.0,
            ),
            HtmlColorInput(
              initialColor: textColor,
              width: 100,
              height: 50,
              onInput: (color, event) {
                setState(() {
                  previewTextColor = color;
                });
              },
              onChange: (color, event) {
                setState(() {
                  textColor = color;
                });
              },
            ),
            const SizedBox(
              height: 120.0,
            ),
            _getEventDescriptionText(
              event: 'onChange',
              supportingText: 'is called once the color picker is closed.',
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getEventDescriptionText({
    required String event,
    required String supportingText,
    required Color color,
  }) {
    return SelectableText.rich(
      TextSpan(
        text: event,
        style: TextStyle(
          fontSize: 20.0,
          color: color,
          decoration: TextDecoration.underline,
          decorationColor: color,
        ),
        children: [
          TextSpan(
            text: ' $supportingText',
            style: const TextStyle(
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
