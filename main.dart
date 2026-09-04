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