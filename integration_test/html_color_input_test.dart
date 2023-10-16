import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:html_color_input/html_color_input.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:universal_html/html.dart' as html;

abstract class OnColorInputEvent {
  void call(Color color, html.Event event);
}

class MockOnColorInputEvent extends Mock implements OnColorInputEvent {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(html.Event(''));
  });

  group('$HtmlColorInput,', () {
    const colorInputTypeSelector = 'input[type="color"]';

    testWidgets(
        'when the color input\'s "input" event is triggered, calls the onInput callback with the right color',
        (tester) async {
      final onInputCallback = MockOnColorInputEvent();

      await tester.pumpWidget(
        Center(
          child: HtmlColorInput(
            onInput: onInputCallback,
          ),
        ),
      );

      await tester.pumpAndSettle();

      final inputElement = html.document.querySelector(colorInputTypeSelector)
          as html.InputElement;

      /// Change the color
      inputElement.value = '#ffff00';

      /// Trigger the input event
      inputElement.dispatchEvent(html.Event('input'));

      await tester.pumpAndSettle();

      verify(() => onInputCallback.call(
          const Color(0xffffff00),
          any(
              that: isA<html.Event>().having(
                  (event) => event.type, 'type', equals('input'))))).called(1);
    });

    testWidgets(
        'when the color input\'s "change" event is triggered, calls the onChange callback with the right color',
        (tester) async {
      final onChangeCallback = MockOnColorInputEvent();

      await tester.pumpWidget(
        Center(
          child: HtmlColorInput(
            onChange: onChangeCallback,
          ),
        ),
      );

      await tester.pumpAndSettle();

      final inputElement = html.document.querySelector(colorInputTypeSelector)
          as html.InputElement;

      /// Change the color
      inputElement.value = '#ffff00';

      /// Trigger the change event
      inputElement.dispatchEvent(html.Event('change'));

      await tester.pumpAndSettle();

      verify(() => onChangeCallback.call(
          const Color(0xffffff00),
          any(
              that: isA<html.Event>().having(
                  (event) => event.type, 'type', equals('change'))))).called(1);
    });

    testWidgets(
        'when initial color is null, renders the color input element with black',
        (tester) async {
      await tester.pumpWidget(
        Center(
          child: HtmlColorInput(),
        ),
      );

      await tester.pumpAndSettle();

      final inputElement = html.document.querySelector(colorInputTypeSelector)
          as html.InputElement;

      final inputElementValue = inputElement.value;

      expect(
        inputElementValue,
        '#000000',
      );
    });

    testWidgets(
        'when passed an initial color, renders the color input element with the passed color',
        (tester) async {
      await tester.pumpWidget(
        Center(
          child: HtmlColorInput(
            initialColor: const Color(0xffff0000),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final inputElement = html.document.querySelector(colorInputTypeSelector)
          as html.InputElement;

      final inputElementValue = inputElement.value;

      expect(
        inputElementValue,
        '#ff0000',
      );
    });
  });
}
