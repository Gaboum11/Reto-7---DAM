import 'servicio.dart';
import 'atencion.dart';
import 'categoria_servicio.dart';

extension ConsultasFacturacion on List<Atencion> {
  Map<CategoriaServicio, double> get montoPorCategoria {
    final totales = <CategoriaServicio, double>{};
    
    for (final atencion in this) {
      for (final linea in atencion.lineas) {
        totales.update(
          linea.servicio.categoria,
          (acumulado) => acumulado + linea.subtotal,
          ifAbsent: () => linea.subtotal,
        );
      }
    }
    
    return totales;
  }

  ({CategoriaServicio categoria, double monto})? get categoriaLider {
    final entradas = montoPorCategoria.entries.toList();
    if (entradas.isEmpty) return null;

    final lider = entradas.reduce(
      (mayor, actual) => actual.value > mayor.value ? actual : mayor,
    );

    return (categoria: lider.key, monto: lider.value);
  }
}
