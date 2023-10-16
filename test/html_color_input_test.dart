import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:html_color_input/html_color_input.dart';

/// It is assumed that all tests (with the exception of the non-web test) are
/// run on web.
///
/// Non-web tests are tagged with [nonWebTestTag].

/// Run tests that are not web tests.
const nonWebTestTag = 'non_web';

void main() {
  group('$HtmlColorInput ', () {
    group('on non-web platforms', () {
      test(
        'throws assertion error on non-web platforms on construction',
        () async {
          expect(
            (() {
              HtmlColorInput();
            }),
            throwsA(isAssertionError.having(
              (error) => error.message,
              'message',
              'HtmlColorInput can only be used in Flutter Web apps.',
            )),
          );
        },
        tags: nonWebTestTag,
      );
    });

    group('on web platforms', () {
      final htmlColorInputFinder = find.byType(HtmlColorInput);

      test(
        'does not throw assertion error on construction',
        () async {
          expect((() {
            HtmlColorInput();
          }), isNot(throwsA(isAssertionError)));
        },
      );

      testWidgets(
        'when not passed dimensions, renders the color input element with default dimensions',
        (tester) async {
          await tester.pumpWidget(
            Center(
              child: HtmlColorInput(),
            ),
          );

          final htmlColorInputSize = tester.getSize(htmlColorInputFinder);

          expect(
            htmlColorInputSize,
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
              child: HtmlColorInput(
                height: height,
              ),
            ),
          );

          final htmlColorInputSize = tester.getSize(htmlColorInputFinder);

          final htmlColorInputHeight = htmlColorInputSize.height;

          expect(
            htmlColorInputHeight,
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
            child: HtmlColorInput(
              width: width,
            ),
          ),
        );

        final htmlColorInputSize = tester.getSize(htmlColorInputFinder);

        final htmlColorInputWidth = htmlColorInputSize.width;

        expect(
          htmlColorInputWidth,
          width,
        );
      });
    });
  });
}
