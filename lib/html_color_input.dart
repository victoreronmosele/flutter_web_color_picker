/// A Flutter widget that renders a color input element in Flutter Web apps.
library html_color_input;

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_color_input/util.dart';

/// The default border box dimension of the color input element as rendered by Chrome
/// and Edge.
///
/// See: https://css-tricks.com/color-inputs-a-deep-dive-into-cross-browser-differences/#:~:text=the%20border%2Dbox%20is%2050pxx27px%20in%20Chrome%20and%20Edge
const _defaultSize = (width: 50.0, height: 27.0);

typedef ColorInputEventCallback = void Function(Color color, html.Event event);

class HtmlColorInput extends StatefulWidget {
  /// The initial color of the color input element as rendered by the browser.
  ///
  /// If this is not specified, the default color will be black.
  ///
  /// See: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/color#using_color_inputs:~:text=a%20value%2C%20the-,default%20is%20%23000000%2C,-which%20is%20black
  final Color? initialColor;

  /// The width of the color input element.
  ///
  /// If this is not specified, the default width will be 50.0.
  ///
  /// See: [_defaultSize].
  final double? width;

  /// The height of the color input element.
  ///
  /// If this is not specified, the default height will be 27.0.
  ///
  /// See: [_defaultSize].
  final double? height;

  final ColorInputEventCallback? onInput;
  final ColorInputEventCallback? onChange;

  const HtmlColorInput({
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
  late String viewType = DateTime.timestamp().toIso8601String();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? _defaultSize.width,
      height: widget.height ?? _defaultSize.height,
      child: HtmlElementView(
        viewType: viewType,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    registerColorInputView();
  }

  void registerColorInputView() {
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
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
}
