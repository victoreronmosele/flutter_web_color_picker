@TestOn('browser')

import 'package:flutter_test/flutter_test.dart';
import 'package:html_color_input/html_color_input.dart';

void main() {
  testWidgets('asserts on non-web platforms', (widgetTester) async {
    widgetTester.pumpWidget(
      const HtmlColorInput(),
    );

    expect(
      widgetTester.takeException(),
      isAssertionError.having(
        (error) => error.message,
        'message',
        'HtmlColorInput can only be used in Flutter Web apps.',
      ),
    );
  });
}
