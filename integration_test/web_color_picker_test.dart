import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_color_picker/web_color_picker.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:universal_html/html.dart' as html;

/// Signature for a function that creates a [WebColorPicker].
typedef WebColorPickerCreator = WebColorPicker Function({
  Color? initialColor,
  OnColorInputEvent? onInput,
  OnColorInputEvent? onChange,
});

abstract class OnColorInputEvent {
  void call(Color color, html.Event event);
}

class MockOnColorInputEvent extends Mock implements OnColorInputEvent {}

const colorInputTypeSelector = 'input[type="color"]';

void runColorInputEventsTest({
  required WebColorPickerCreator webColorPickerCreator,
}) {
  testWidgets(
      'when the color input\'s "input" event is triggered, calls the onInput callback with the right color',
      (tester) async {
    final onInputCallback = MockOnColorInputEvent();

    await tester.pumpWidget(
      Center(
        child: webColorPickerCreator.call(
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
        child: webColorPickerCreator.call(
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
        child: webColorPickerCreator.call(),
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
        child: webColorPickerCreator.call(
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
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(html.Event(''));
  });

  group('WebColorPicker, ', () {
    runColorInputEventsTest(
      webColorPickerCreator: ({initialColor, onInput, onChange}) {
        return WebColorPicker(
          initialColor: initialColor,
          onInput: (color, event) => onInput?.call(color, event),
          onChange: (color, event) => onChange?.call(color, event),
        );
      },
    );
  });

  group('WebColorPicker.builder, ', () {
    runColorInputEventsTest(
      webColorPickerCreator: ({initialColor, onInput, onChange}) {
        return WebColorPicker.builder(
          initialColor: initialColor,
          onInput: (color, event) => onInput?.call(color, event),
          onChange: (color, event) => onChange?.call(color, event),
          builder: (_, __) => Container(),
        );
      },
    );

    testWidgets(
        '''triggers the input element's click event when the builder '''
        '''function widget is tapped''', (tester) async {
      final builderKey = UniqueKey();

      await tester.pumpWidget(
        Center(
          child: WebColorPicker.builder(
            builder: (context, color) => Center(
              child: Container(
                key: builderKey,
                height: 30,
                width: 60,
                color: color,
              ),
            ),
          ),
        ),
      );

      final builderWidgetFinder = find.byKey(builderKey);

      expect(
        builderWidgetFinder,
        findsWidgets,
      );

      final htmlColorPicker = html.document
          .querySelector(colorInputTypeSelector) as html.InputElement;

      bool clickEventTriggered = false;

      htmlColorPicker.addEventListener('click', (event) {
        clickEventTriggered = true;
      });

      await tester.tap(builderWidgetFinder, warnIfMissed: false);

      await tester.pumpAndSettle();

      expect(
        clickEventTriggered,
        isTrue,
        reason: 'The click event should be triggered',
      );
    });
  });
}
