/// A Flutter widget that displays the native web color picker for browsers for
/// use in Flutter Web apps.
library web_color_picker;

/// The mock_ui_web.dart file is used to prevent builds from failing on non-web
/// platforms.
import 'dart:ui_web' if (dart.library.io) 'src/mock_ui_web.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_color_picker/src/util.dart';
import 'package:uuid/uuid.dart';
import 'package:universal_html/html.dart' as html;

export 'package:universal_html/html.dart' show Event;

/// The default border box dimension of the color input element as rendered by
/// Chrome and Edge.
///
/// See: [Color Inputs: A Deep Dive into Cross-Browser Differences | Css Tricks](https://css-tricks.com/color-inputs-a-deep-dive-into-cross-browser-differences/#:~:text=the%20border%2Dbox%20is%2050pxx27px%20in%20Chrome%20and%20Edge)
const defaultSize = Size(50.0, 27.0);

/// Signature for the callback for color input element's events:
/// - [WebColorPicker.onInput] and
/// - [WebColorPicker.onChange].
typedef ColorInputEventCallback = void Function(Color color, html.Event event);

/// Signature for a function that creates a custom color picker selector for a
/// given color.
///
/// Used when you want to display a custom color picker widget instead of the
/// default color picker.
typedef CustomColorPickerSelectorBuilder = Widget Function(
    BuildContext context, Color? color);

/// The assert message for non-web platforms.
///
/// [WebColorPicker] can only be used in Flutter Web apps.
const _nonWebPlatformAssertMessage =
    'WebColorPicker can only be used in Flutter Web apps.';

/// A Flutter widget that displays the native web color picker for browsers for
/// use in Flutter Web apps.
///
/// There are two ways to construct a [WebColorPicker]:
///
/// 1. Using the default constructor:
///    This will display the browser's default color picker selector.
///
/// 2. Using the `WebColorPicker.builder` constructor:
///    This will display a custom color picker selector widget.
///
/// An example using the default constructor:
///
///   ```dart
///   WebColorPicker(
///     initialColor: Colors.red,
///     width: 60.0,
///     height: 30.0,
///     onInput: (selectedColor, event) {
///       print('Color selected: $selectedColor');
///     },
///     onChange: (confirmedColor, event) {
///       print('Color confirmed: $confirmedColor');
///     },
///   )
///   ```
///
///
/// An example using the `WebColorPicker.builder` constructor:
///
///   ```dart
///   WebColorPicker.builder(
///     initialColor: Colors.red,
///     builder: (context, selectedColor) {
///       return Container(
///         width: 60.0,
///         height: 30.0,
///         color: selectedColor,
///       );
///     },
///     onInput: (selectedColor, event) {
///       print('Color selected: $selectedColor');
///     },
///     onChange: (confirmedColor, event) {
///       print('Color confirmed: $confirmedColor');
///     },
///   );
///   ```
///
/// See: [MDN Documentation: HTML Color Input Element Overview](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/color)
class WebColorPicker extends StatefulWidget {
  /// The initial color of the color picker.
  ///
  /// This is the initial color of the color input element as rendered by the
  /// browser.
  ///
  /// If this is not specified, the default color will be black.
  ///
  /// See: [MDN Documentation: Default Color Value for HTML Color Input](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/color#using_color_inputs:~:text=a%20value%2C%20the-,default%20is%20%23000000%2C,-which%20is%20black)
  final Color? initialColor;

  /// The width of the color picker selector.
  ///
  /// If this is not specified, the default width will be `50.0`.
  ///
  /// See: [defaultSize].
  final double? width;

  /// The height of the color picker selector.
  ///
  /// If this is not specified, the default height will be `27.0`.
  ///
  /// See: [defaultSize].
  final double? height;

  /// Called each time a color is selected.
  ///
  /// This is called when the color input element's `onInput` event is fired.
  final ColorInputEventCallback? onInput;

  /// Called each time a color is confirmed by dismissing the color picker.
  ///
  /// This is called when the color input element's `onChange` event is fired.
  final ColorInputEventCallback? onChange;

  /// A function that returns a widget to be used creating a custom color picker
  /// selector.
  ///
  /// The widget returned by the function will be displayed instead of the
  /// default color picker selector.
  final CustomColorPickerSelectorBuilder? builder;

  /// The opacity of the color input element.
  ///
  /// This is determined by the constructor used to create the [WebColorPicker].
  ///
  /// If the `WebColorPicker()` constructor is used, the opacity will be 1.0
  /// in order to display the browser's default color picker selector.
  ///
  /// If the `WebColorPicker.builder()` constructor is used, the opacity will be
  /// `0.0` in order to hide the browser's default color picker selector and
  /// display the custom color picker selector set in [WebColorPicker.builder].
  final double _opacity;

  /// Creates a Flutter widget that displays the native web color picker for a
  /// browser.
  ///
  /// See: [MDN Documentation: HTML \<input type="color"> Element Overview](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/color)
  // ignore: prefer_const_constructors_in_immutables
  WebColorPicker({
    super.key,
    this.initialColor,
    this.width,
    this.height,
    this.onInput,
    this.onChange,
  })  : assert(kIsWeb, _nonWebPlatformAssertMessage),
        builder = null,
        _opacity = 1.0;

  /// Creates a Flutter widget that displays a custom color picker selector.
  ///
  /// Use this instead of the default constructor when you want to display a
  /// custom color picker seletor widget.
  const WebColorPicker.builder({
    super.key,
    this.initialColor,
    this.onInput,
    this.onChange,
    required this.builder,
  })  : assert(kIsWeb, _nonWebPlatformAssertMessage),
        width = null,
        height = null,
        _opacity = 0.0;

  @override
  State<WebColorPicker> createState() => _WebColorPickerState();
}

class _WebColorPickerState extends State<WebColorPicker> {
  static const colorInputElementType = 'color';
  static const oneHundredPercent = '100%';

  /// Unique identifier for the color input element.
  final String viewType = const Uuid().v4();
  final inputElement = html.InputElement(type: colorInputElementType);

  /// The currently selected color.
  ///
  /// This should only be updated when the color input element's `onInput` event
  /// is fired or the input element's value is set.
  final selectedColor = ValueNotifier<Color?>(null);

  @override
  void initState() {
    super.initState();

    registerColorInputViewAndSetUpListeners();
  }

  /// Registers the color input element with the platform view registry and adds
  /// the event listeners for the color input element.
  void registerColorInputViewAndSetUpListeners() {
    platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final initialColor = widget.initialColor;

      if (initialColor != null) {
        inputElement.value = colorToHexString(initialColor);
        selectedColor.value = initialColor;
      }

      inputElement.onInput.listen((event) {
        final inputElementValue = inputElement.value;

        if (inputElementValue != null) {
          final color = hexStringToColor(inputElementValue);

          widget.onInput?.call(color, event);

          selectedColor.value = color;
        }
      });

      inputElement.onChange.listen((event) {
        final inputElementValue = inputElement.value;

        if (inputElementValue != null) {
          final color = hexStringToColor(inputElementValue);

          widget.onChange?.call(color, event);
        }
      });

      /// Setting the width and height to `100%` ensures that the color input
      /// element takes up the entire size constraint of the widget.
      inputElement.style
        ..width = oneHundredPercent
        ..height = oneHundredPercent
        ..opacity = widget._opacity.toString();

      return inputElement;
    });
  }

  @override
  Widget build(BuildContext context) {
    final builder = widget.builder;

    final htmlColorInput = HtmlElementView(
      viewType: viewType,
    );

    /// ### When [builder] is `null`:
    ///
    /// The default color picker selector will be displayed using the
    /// [htmlColorInput] widget.
    ///
    /// ### When [builder] is not `null`:
    ///
    /// The default color picker selector, the [htmlColorInput] widget will be
    /// hidden and the custom color picker selector will be displayed and will
    /// open the browser's color picker when tapped.
    return builder == null
        ? SizedBox(
            width: widget.width ?? defaultSize.width,
            height: widget.height ?? defaultSize.height,
            child: htmlColorInput,
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.square(
                // Using a small dimension so that hidden color input element
                // does not affect the gesture detector's hit box.
                dimension: 0.001,
                child: htmlColorInput,
              ),
              Center(
                child: ValueListenableBuilder<Color?>(
                    valueListenable: selectedColor,
                    builder: (context, selectedColor, child) {
                      /// Using a [Listener] to capture the pointer up event
                      /// directly so that taps can be detected even if the
                      /// [builder] returns a widget that has gesture detection
                      /// like buttons.
                      ///
                      /// If a [GestureDetector] is used instead, the tap event
                      /// will not be detected if the [builder] returns a widget
                      /// that has gesture detection.
                      ///
                      /// See: https://docs.flutter.dev/ui/interactivity/gestures
                      return Listener(
                        behavior: HitTestBehavior.translucent,
                        onPointerUp: (_) {
                          inputElement.click();
                        },
                        child: builder.call(
                          context,
                          selectedColor,
                        ),
                      );
                    }),
              ),
            ],
          );
  }
}
