abstract interface class EstrategiaPersecucion {
  String ejecutarPersecucion(String nombreFantasma, double velocidad);
}

class PersecucionDirecta implements EstrategiaPersecucion {
  @override
  String ejecutarPersecucion(String nombreFantasma, double velocidad) {
    return '$nombreFantasma persigue a Pac-Man directamente a velocidad $velocidad.';
  }
}

class PersecucionEmboscada implements EstrategiaPersecucion {
  @override
  String ejecutarPersecucion(String nombreFantasma, double velocidad) {
    return '$nombreFantasma intenta emboscar a Pac-Man por delante a velocidad $velocidad.';
  }
}

abstract class Fantasma {
  final String nombre;
  final String color;
  final double velocidad;
  final String? potenciacionActiva;
  final EstrategiaPersecucion estrategia;

  Fantasma({
    required String nombre,
    required String color,
    required this.velocidad,
    required this.estrategia,
    this.potenciacionActiva,
  })  : nombre = nombre.trim(),
        color = color.trim() {
    if (this.nombre.isEmpty || this.color.isEmpty) {
      throw FormatException('El nombre y el color del fantasma no deben estar vacíos.');
    }
    if (!velocidad.isFinite || velocidad <= 0) {
      throw FormatException('La velocidad debe ser positiva y finita.');
    }
  }

  String get estado;

  void perseguir() {
    print(estrategia.ejecutarPersecucion(nombre, velocidad));
  }

  void huir() {
    String efecto = potenciacionActiva ?? 'Sin escudo especial';
    print('$nombre ($color) se vuelve azul y huye! [Efecto: $efecto]');
  }
}

class Blinky extends Fantasma {
  Blinky({
    required super.velocidad,
    required super.estrategia,
    super.potenciacionActiva,
  }) : super(nombre: 'Blinky', color: 'Rojo');

  @override
  String get estado => 'Agresivo';
}

class Pinky extends Fantasma {
  Pinky({
    required super.velocidad,
    required super.estrategia,
    super.potenciacionActiva,
  }) : super(nombre: 'Pinky', color: 'Rosa');

  @override
  String get estado => 'Táctico';
}

class EscuadronFantasmas {
  final String nombreNivel;
  final List<Fantasma> fantasmas;

  EscuadronFantasmas({
    required String nombreNivel,
    required List<Fantasma> fantasmas,
  })  : nombreNivel = nombreNivel.trim(),
        fantasmas = List<Fantasma>.unmodifiable(fantasmas) {
    if (this.nombreNivel.isEmpty) {
      throw FormatException('El nombre del nivel no debe estar vacío.');
    }
    if (this.fantasmas.isEmpty) {
      throw FormatException('Un escuadrón debe tener al menos un fantasma.');
    }

    Set<String> nombresUnicos = <String>{};
    for (final fantasma in this.fantasmas) {
      if (!nombresUnicos.add(fantasma.nombre.toLowerCase())) {
        throw FormatException('Fantasma duplicado en el escuadrón: ${fantasma.nombre}');
      }
    }
  }

  double get velocidadTotalEscuadron {
    return fantasmas.fold<double>(
      0.0,
      (total, fantasma) => total + fantasma.velocidad,
    );
  }

  double get velocidadPromedio => velocidadTotalEscuadron / fantasmas.length;

  Fantasma get fantasmaMasRapido {
    Fantasma masRapido = fantasmas.first;
    for (final fantasma in fantasmas.skip(1)) {
      if (fantasma.velocidad > masRapido.velocidad) {
        masRapido = fantasma;
      }
    }
    return masRapido;
  }
}

void main() {
  try {
    Fantasma blinky = Blinky(
      velocidad: 1.5,
      estrategia: PersecucionDirecta(),
      potenciacionActiva: 'Aumento de Velocidad',
    );

    Fantasma pinky = Pinky(
      velocidad: 1.2,
      estrategia: PersecucionEmboscada(),
    );

    EscuadronFantasmas escuadron = EscuadronFantasmas(
      nombreNivel: '  Nivel Cereza 1  ',
      fantasmas: [blinky, pinky],
    );

    print('=== ${escuadron.nombreNivel} ===');
    print('Velocidad Promedio: ${escuadron.velocidadPromedio}');
    print('Fantasma Más Rápido: ${escuadron.fantasmaMasRapido.nombre}\n');

    for (final fantasma in escuadron.fantasmas) {
      print('Estado: ${fantasma.estado}');
      fantasma.perseguir();
      fantasma.huir();
      print('---');
    }

    print('Intentando crear un escuadrón inválido...');
    EscuadronFantasmas escuadronInvalido = EscuadronFantasmas(
      nombreNivel: 'Nivel Roto',
      fantasmas: [blinky, blinky],
    );
    print(escuadronInvalido.nombreNivel);
  } on FormatException catch (e) {
    print('Error de validación capturado de forma segura: ${e.message}');
  }
}
