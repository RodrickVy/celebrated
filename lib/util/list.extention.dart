extension Loop<T> on Iterable<T> {
  Iterable<Y> map3<Y>(
      Y Function(T value, int index, Iterable<T> list) transformer) {
    var index = 0;
    return map((item) {
      return transformer(item, index++, take(length));
    });
  }

  Iterable<Y> map2<Y>(Y Function(T value, int index) transformer) {
    var index = 0;
    return map((item) {
      return transformer(item, index++);
    });
  }

  void forEach3<Y>(
      void Function(T value, int index, Iterable<T> list) transformer) {
    var index = 0;
    forEach((item) {
      transformer(item, index, take(length));
      index = index + 1;
    });
  }

  void forEach2<Y>(void Function(T value, int index) transformer) {
    var index = 0;
    forEach((item) {
      transformer(item, index);
      index = index + 1;
    });
  }
}
