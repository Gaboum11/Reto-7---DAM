class Atencion {
  Atencion(this.codigo, [List<LineaAtencion> lineas = const []])
    : lineas = List.unmodifiable(lineas);

  final String codigo;
  final List<LineaAtencion> lineas;

  double get montoTotal =>
      lineas.fold(0, (total, linea) => total + linea.subtotal);
}
