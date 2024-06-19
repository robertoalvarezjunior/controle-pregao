extension Formato on DateTime? {
  String formatado() {
    var dia = this!.day;
    var mes = this!.month;
    var ano = this!.year;

    return '$dia/$mes/$ano';
  }
}

extension FormatDate on String? {
  String formatDate() {
    if (this == null) return '';
    List<String> parts = this!.split('/');
    return '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
  }
}
