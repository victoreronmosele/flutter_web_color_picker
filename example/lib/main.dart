import 'package:flutter/material.dart';
import 'package:web_color_picker/web_color_picker.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web Color Picker Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
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
  static const initialColor = Colors.red;

  Color previewTextColor = initialColor;
  Color textColor = initialColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'PREVIEW',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getEventDescriptionWidget(
                      event: 'onInput',
                      supportingText: ': Changes as the user selects a color.',
                      color: previewTextColor,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    _getEventDescriptionWidget(
                      event: 'onChange',
                      supportingText:
                          ': Changes when the user confirms a color.',
                      color: textColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        WebColorPicker(
                          initialColor: textColor,
                          width: 60,
                          height: 30,
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
                          height: 8.0,
                        ),
                        const Text(
                          'WebColorPicker()',
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        WebColorPicker.builder(
                          initialColor: textColor,
                          builder: (context, selectedColor) {
                            return ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 12,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: selectedColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const Text(
                                    'Select color',
                                  ),
                                ],
                              ),
                            );
                          },
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
                          height: 8.0,
                        ),
                        const Text(
                          'WebColorPicker.builder()',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getEventDescriptionWidget({
    required String event,
    required String supportingText,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: color,
          ),
        ),
        const SizedBox(
          width: 16.0,
        ),
        Text.rich(
          TextSpan(
            text: event,
            style: const TextStyle(
              decoration: TextDecoration.underline,
            ),
            children: [
              TextSpan(
                text: supportingText,
                style: const TextStyle(
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
