class ApplicationFunctions {
  static List<List<T>> partitions<T>(List<T> valuesList, int size) {
    List<List<T>> valuesListPartitation = [];
    var len = valuesList.length;
    for (var i = 0; i < len; i += size) {
      var end = (i + size < len) ? i + size : len;
      valuesListPartitation.add(valuesList.sublist(i, end));
    }
    return valuesListPartitation;
  }
}
