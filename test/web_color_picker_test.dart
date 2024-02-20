/// It is assumed that all tests (with the exception of the non-web test) are
/// run on web.
///
/// Non-web tests are tagged with [nonWebTestTag].

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_color_picker/web_color_picker.dart';

/// Run tests that are not web tests.
const nonWebTestTag = 'non_web';

/// Signature for a function that creates a [WebColorPicker].
///
/// It is used in the tests to pass a function that creates a [WebColorPicker]
/// to test if assertion errors are thrown.
typedef WebColorPickerCreator = WebColorPicker Function();

/// Tests that the [WebColorPicker] throws an assertion error on non-web
/// platforms when the [WebColorPicker] is constructed.
///
/// Pass a function that calls a [WebColorPicker] constructor as the
/// [webColorPickerCreator] argument.
///
/// Like this:
/// ```dart
///  testThrowsAssertionErrorOnNonWebPlatforms(
///    webColorPickerCreator: () => WebColorPicker(),
///  );
/// ```
///
/// Do not pass a function that returns an already created [WebColorPicker] since
/// the assertion being tested needs to be thrown in the context of the test.
void testThrowsAssertionErrorOnNonWebPlatforms(
    {required WebColorPickerCreator webColorPickerCreator}) {
  test(
    'on non-web platforms throws assertion error on construction',
    () async {
      expect(
        (() {
          webColorPickerCreator.call();
        }),
        throwsA(isAssertionError.having(
          (error) => error.message,
          'message',
          'WebColorPicker can only be used in Flutter Web apps.',
        )),
      );
    },
    tags: nonWebTestTag,
  );
}

/// Tests that the [WebColorPicker] does not throw an assertion error on web
/// platforms when the [WebColorPicker] is constructed.
///
/// Pass a function that calls a [WebColorPicker] constructor as the
/// [webColorPickerCreator] argument.
///
/// Like this:
///
/// ```dart
/// testDoesNotThrowAssertionErrorOnWebPlatforms(
///  webColorPickerCreator: () => WebColorPicker(),
/// );
/// ```
///
/// Do not pass a function that returns an already created [WebColorPicker] since
/// the assertion being tested needs to be thrown in the context of the test.
void testDoesNotThrowAssertionErrorOnWebPlatforms(
    {required WebColorPickerCreator webColorPickerCreator}) {
  test(
    'on web plaforms does not throw assertion error on construction',
    () async {
      expect((() {
        webColorPickerCreator.call();
      }), isNot(throwsA(isAssertionError)));
    },
  );
}

void main() {
  group('WebColorPicker ', () {
    testThrowsAssertionErrorOnNonWebPlatforms(
      webColorPickerCreator: () => WebColorPicker(),
    );

    group('on web platforms', () {
      final webColorPickerFinder = find.byType(WebColorPicker);

      testDoesNotThrowAssertionErrorOnWebPlatforms(
        webColorPickerCreator: () => WebColorPicker(),
      );

      testWidgets(
        'when not passed dimensions, renders the color input element with default dimensions',
        (tester) async {
          await tester.pumpWidget(
            Center(
              child: WebColorPicker(),
            ),
          );

          final webColorPickerSize = tester.getSize(webColorPickerFinder);

          expect(
            webColorPickerSize,
            defaultSize,
          );
        },
      );

      testWidgets(
        'when passed height, renders the color input element with height argument',
        (tester) async {
          const height = 50.0;

          await tester.pumpWidget(
            Center(
              child: WebColorPicker(
                height: height,
              ),
            ),
          );

          final webColorPickerSize = tester.getSize(webColorPickerFinder);

          final webColorPickerHeight = webColorPickerSize.height;

          expect(
            webColorPickerHeight,
            height,
          );
        },
      );

      testWidgets(
          'when passed width, renders the color input element with width argument',
          (tester) async {
        const width = 100.0;

        await tester.pumpWidget(
          Center(
            child: WebColorPicker(
              width: width,
            ),
          ),
        );

        final webColorPickerSize = tester.getSize(webColorPickerFinder);

        final webColorPickerWidth = webColorPickerSize.width;

        expect(
          webColorPickerWidth,
          width,
        );
      });
    });
  });

  group('WebColorPicker.builder ', () {
    testThrowsAssertionErrorOnNonWebPlatforms(
      webColorPickerCreator: () => WebColorPicker.builder(
        builder: (_, __) => Container(),
      ),
    );

    group('on web platforms', () {
      testDoesNotThrowAssertionErrorOnWebPlatforms(
        webColorPickerCreator: () => WebColorPicker.builder(
          builder: (context, _) => Container(),
        ),
      );

      testWidgets('renders builder function widget', (tester) async {
        /// Use a [UniqueKey] to ensure that there are no false positives.
        final builderWidgetKey = UniqueKey();

        await tester.pumpWidget(
          Center(
            child: WebColorPicker.builder(
              builder: (_, __) => Container(
                key: builderWidgetKey,
              ),
            ),
          ),
        );

        final builderWidgetFinder = find.byKey(builderWidgetKey);

        expect(
          builderWidgetFinder,
          findsOneWidget,
        );
      });
    });
  });
}
