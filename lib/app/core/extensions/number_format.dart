String numberFormat(String x) {
  List<String> part= x.split(".");
  RegExp re = RegExp(r'\B(?=(\d{3})+(?!\d))');
  x = part[0].replaceAll(re, '.');
  return x;
}