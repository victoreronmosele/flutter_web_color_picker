/// A Flutter widget that displays the HTML color input element for use in  Flutter Web apps.
library html_color_input;

/// The mock_ui_web.dart file is used to prevent builds from failing on non-web
/// platforms.
import 'dart:ui_web' if (dart.library.io) 'src/mock_ui_web.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_color_input/src/util.dart';
import 'package:uuid/uuid.dart';
import 'package:universal_html/html.dart' as html;

/// The default border box dimension of the color input element as rendered by Chrome
/// and Edge.
///
/// See: [Color Inputs: A Deep Dive into Cross-Browser Differences | Css Tricks](https://css-tricks.com/color-inputs-a-deep-dive-into-cross-browser-differences/#:~:text=the%20border%2Dbox%20is%2050pxx27px%20in%20Chrome%20and%20Edge)
const defaultSize = Size(50.0, 27.0);

/// Signature for callbacks for color input element's events: [HtmlColorInput.onInput] and [HtmlColorInput.onChange].
typedef ColorInputEventCallback = void Function(Color color, html.Event event);

/// A Flutter widget that displays the HTML color input element for use in Flutter
/// Web apps.
///
/// ## Sample code:
///
/// ```dart
/// HtmlColorInput(
///   initialColor: Colors.deepPurple,
///   width: 100,
///   height: 50,
///   onInput: (color, event) {
///     print('onInput: $color');
///   },
///   onChange: (color, event) {
///    print('onChange: $color');
///   },
/// )
/// ```
///
/// See: [MDN Documentation: HTML Color Input Element Overview](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/color)
class HtmlColorInput extends StatefulWidget {
  /// The initial color of the color input element as rendered by the browser.
  ///
  /// If this is not specified, the default color will be black.
  ///
  /// See: [MDN Documentation: Default Color Value for HTML Color Input](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/color#using_color_inputs:~:text=a%20value%2C%20the-,default%20is%20%23000000%2C,-which%20is%20black)
  final Color? initialColor;

  /// The width of the color input element.
  ///
  /// If this is not specified, the default width will be 50.0.
  ///
  /// See: [defaultSize].
  final double? width;

  /// The height of the color input element.
  ///
  /// If this is not specified, the default height will be 27.0.
  ///
  /// See: [defaultSize].
  final double? height;

  /// Called when the color input element's `onInput` event is fired, that is,
  /// each time you select a color.
  final ColorInputEventCallback? onInput;

  /// Called when the color input element's `onChange` event is fired, that is,
  /// when you confirm a color selection by dismissing the color picker.
  final ColorInputEventCallback? onChange;

  /// Creates a Flutter widget that displays the HTML color input element for use in Flutter Web apps.
  ///
  /// See: [MDN Documentation: HTML <input type="color"> Element Overview](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/color)
  // ignore: prefer_const_constructors_in_immutables
  HtmlColorInput({
    super.key,
    this.initialColor,
    this.width,
    this.height,
    this.onInput,
    this.onChange,
  }) : assert(kIsWeb, 'HtmlColorInput can only be used in Flutter Web apps.');

  @override
  State<HtmlColorInput> createState() => _HtmlColorInputState();
}

class _HtmlColorInputState extends State<HtmlColorInput> {
  static const colorInputElementType = 'color';
  static const oneHundredPercent = '100%';

  /// Unique identifier for the color input element.
  final String viewType = const Uuid().v4();

  @override
  void initState() {
    super.initState();

    registerColorInputViewAndSetUpListeners();
  }

  /// Registers the color input element with the platform view registry and adds
  /// the event listeners for the color input element.
  void registerColorInputViewAndSetUpListeners() {
    platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final inputElement = html.InputElement(type: colorInputElementType);

      final initialColor = widget.initialColor;

      if (initialColor != null) {
        inputElement.value = colorToHexString(initialColor);
      }

      inputElement.onInput.listen((event) {
        final inputElementValue = inputElement.value;

        if (inputElementValue != null) {
          final color = hexStringToColor(inputElementValue);

          widget.onInput?.call(color, event);
        }
      });

      inputElement.onChange.listen((event) {
        final inputElementValue = inputElement.value;

        if (inputElementValue != null) {
          final color = hexStringToColor(inputElementValue);

          widget.onChange?.call(color, event);
        }
      });

      /// Ensure that the color input element takes up the entire size constraint
      /// of the widget.
      inputElement.style
        ..width = oneHundredPercent
        ..height = oneHundredPercent;

      return inputElement;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? defaultSize.width,
      height: widget.height ?? defaultSize.height,
      child: HtmlElementView(
        viewType: viewType,
      ),
    );
  }
}
