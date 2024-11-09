class Event {
  void listen(void Function(dynamic _) callback) {}

  void call(dynamic _, dynamic __) {}
}

class HTMLInputElement {
  final onInput = Event();
  final onChange = Event();

  final style = CSSStyleDeclaration();

  var value = '';
  var type = '';

  void click() {}
}

class CSSStyleDeclaration {
  var height = '';
  var width = '';
  var opacity = '';
}
