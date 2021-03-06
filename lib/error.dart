import 'dart:isolate';

void _foo<T, U>(SendPort sendPort) async {
  var receivePort = new ReceivePort();
  sendPort.send(receivePort.sendPort);
  U Function(T input) mapper = await receivePort.first;
}

void _bar<T, U>(U Function(T input) mapper) async {
  ReceivePort receivePort = new ReceivePort();
  Isolate isolate = await Isolate.spawn(_foo, receivePort.sendPort);
  SendPort sendPort = await receivePort.first;
  sendPort.send(mapper);
}

int _baz(int x) => x * x;

void main() {
  _bar(_baz);
}