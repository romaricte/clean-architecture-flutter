class CounterLocalDataSource {
  CounterLocalDataSource();

  int _counter = 0;

  int getCounter() => _counter;

  int increment() {
    _counter++;
    return _counter;
  }
}
