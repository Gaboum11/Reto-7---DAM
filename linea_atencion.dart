import 'class_atencion.dart';
import 'main.dart';

class LineaAtencion {
  const LineaAtencion(this.servicio, this.sesiones);

  final Servicio servicio;
  final int sesiones;

  double get subtotal => servicio.precio * sesiones;
}

extension ConsultasCatalogo on List<Servicio> {
  List<String> get nombresSinCupo => where((servicio) => !servicio.tieneCupos)
      .map((servicio) => servicio.nombre)
      .toList()
    ..sort();
}

extension ConsultasFacturacion on List<Atencion> {
  Map<CategoriaServicio, double> get montoPorCategoria =>
      expand((atencion) => atencion.lineas).fold<Map<CategoriaServicio, double>>(
        <CategoriaServicio, double>{},
        (totales, linea) {
          final categoria = linea.servicio.categoria;
          final acumulado = totales[categoria] ?? 0.0;
          return {...totales, categoria: acumulado + linea.subtotal};
        },
      );

  ({CategoriaServicio categoria, double monto})? get categoriaLider {
    final entradas = montoPorCategoria.entries.toList();
    if (entradas.isEmpty) return null;

    final lider = entradas.reduce(
      (mayor, actual) => actual.value > mayor.value ? actual : mayor,
    );

    return (categoria: lider.key, monto: lider.value);
  }
}
