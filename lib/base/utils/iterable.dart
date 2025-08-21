extension IterableIndexed<E> on Iterable<E> {
  Iterable<MapEntry<int, E>> enumerate() sync* {
    var index = 0;
    for (final element in this) {
      yield MapEntry<int, E>(index, element);
      index += 1;
    }
  }
}
