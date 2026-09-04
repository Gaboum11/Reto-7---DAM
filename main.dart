enum CategoriaServicio {
  consulta('Consulta'),
  cirugia('Cirugía'),
  estetica('Estética');

  const CategoriaServicio(this.etiqueta);

  final String etiqueta;
}

class Servicio {
  const Servicio({
    required this.nombre,
    required this.precio,
    required this.categoria,
    required this.cuposDisponibles,
  });

  final String nombre;
  final double precio;
  final CategoriaServicio categoria;
  final int cuposDisponibles;

  bool get tieneCupos => cuposDisponibles > 0;
}

class LineaAtencion {
  const LineaAtencion(this.servicio, this.sesiones);

  final Servicio servicio;
  final int sesiones;

  double get subtotal => servicio.precio * sesiones;
}

class Atencion {
  Atencion(this.codigo, [List<LineaAtencion> lineas = const []])
      : lineas = List.unmodifiable(lineas);

  final String codigo;
  final List<LineaAtencion> lineas;

  double get montoTotal =>
      lineas.fold(0, (total, linea) => total + linea.subtotal);
}

extension ConsultasCatalogo on List<Servicio> {
  List<String> get nombresSinCupo => where((servicio) => !servicio.tieneCupos)
      .map((servicio) => servicio.nombre)
      .toList()
    ..sort();
}

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

void main() {
  final catalogo = <Servicio>[
    const Servicio(
      nombre: 'Consulta general',
      precio: 20,
      categoria: CategoriaServicio.consulta,
      cuposDisponibles: 8,
    ),
    const Servicio(
      nombre: 'Consulta de urgencia',
      precio: 35,
      categoria: CategoriaServicio.consulta,
      cuposDisponibles: 0,
    ),
    const Servicio(
      nombre: 'Esterilización',
      precio: 90,
      categoria: CategoriaServicio.cirugia,
      cuposDisponibles: 0,
    ),
    const Servicio(
      nombre: 'Baño medicado',
      precio: 12,
      categoria: CategoriaServicio.estetica,
      cuposDisponibles: 10,
    ),
  ];

  final atenciones = <Atencion>[
    Atencion('AT-001', [
      LineaAtencion(catalogo[0], 1),
      LineaAtencion(catalogo[3], 2),
    ]),
    Atencion('AT-002', [LineaAtencion(catalogo[2], 1)]),
    Atencion('AT-003'),
  ];

  final totales = atenciones.montoPorCategoria;
  final lider = atenciones.categoriaLider;

  print('Monto por atención:');
  for (final atencion in atenciones) {
    print('  ${atencion.codigo}: ${atencion.montoTotal}');
  }

  print('');
  print('Servicios sin cupo: ${catalogo.nombresSinCupo}');

  print('');
  print('Monto por categoría:');
  for (final entrada in totales.entries) {
    print('  ${entrada.key.etiqueta}: ${entrada.value}');
  }

  print('');
  print(
    lider == null
        ? 'Categoría líder: ninguna (sin atenciones registradas)'
        : 'Categoría líder: ${lider.categoria.etiqueta} (${lider.monto})',
  );
}