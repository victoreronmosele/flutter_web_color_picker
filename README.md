
A Flutter web widget for integrating the default browser color pickers seamlessly.

Only supports Flutter web.

## Features

- **Default Browser Color Picker**: Uses the built-in color picker of web browsers.
- **Callbacks for Color Change Events**: Get notified when a color is selected or confirmed.
- **Customizable Appearance**: Adjust the dimensions to fit your design.

## Usage

To use the `html_color_input` package in your Flutter Web application, follow these steps:

### 1. Import the Package

First, make sure to add `html_color_input` to your `pubspec.yaml` dependencies. Then, import it in your Dart code:

```dart
import 'package:html_color_input/html_color_input.dart';
```

### 2. Using `HtmlColorInput` Widget

You can add the `HtmlColorInput` widget to your Flutter app just like any other widget:

```dart
HtmlColorInput(
  initialColor: Colors.red,
  width: 60.0,
  height: 30.0,
  onInput: (selectedColor, event) {
    print('Color selected: $selectedColor');
  },
  onChange: (confirmedColor, event) {
    print('Color confirmed: $confirmedColor');
  },
)
```

### 3. Customize Appearance

You can adjust the width and height of the widget to better fit within your application's design:

```dart
HtmlColorInput(
  width: 100.0,
  height: 50.0,
  // ... other properties ...
)
```

### 4. Handle Color Change Events

There are two main callbacks you can handle:

- **onInput**: Triggered whenever a color is selected in the picker.
- **onChange**: Triggered whenever the picker is dismissed and a color is confirmed.

Each of these callbacks provides the selected `Color` and the corresponding HTML event:

```dart
HtmlColorInput(
  onInput: (color, event) {
    print('Color selected: $color');
  },
  onChange: (color, event) {
    print('Color confirmed: $color');
  },
  // ... other properties ...
)
```


## Resources

For further understanding and insights on how the HTML color input works, you can refer to the following resources:

- [MDN Documentation: `<input type="color">`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/color): An in-depth overview of the HTML color input element.
  
- [Using Color Inputs on MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/color#using_color_inputs): A guide that explains the user interactions and behavior of the color input.

- [Color Inputs: A Deep Dive into Cross-Browser Differences | CSS-Tricks](https://css-tricks.com/color-inputs-a-deep-dive-into-cross-browser-differences/): An article that delves into the cross-browser differences of color inputs.


