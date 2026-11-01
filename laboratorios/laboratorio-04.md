# Laboratorio 04 — Introducción a la programación orientada a objetos en Dart

En el [Laboratorio 03](laboratorio-03.md) construiste un catálogo agrícola utilizando funciones, listas, conjuntos y mapas anidados. Pudiste registrar municipios, años y cultivos, pero surgió una dificultad: **una colección por sí sola no explica qué representa cada dato ni qué operaciones deben permitirse**.

En este laboratorio aprenderás **programación orientada a objetos (POO) desde sus fundamentos**. Primero crearás clases pequeñas y después transformarás el catálogo de AgroDiversa en un programa organizado mediante objetos. En el [Laboratorio 05](laboratorio-05.md) ampliarás lo aprendido con herencia, interfaces, polimorfismo, JSON y pruebas automatizadas.

**No necesitas haber programado en otros lenguajes.** Solo se requieren los conocimientos de los laboratorios 01 a 03: variables, funciones, decisiones, bucles y colecciones.

> **Alcance de los datos:** los municipios, cultivos, años y superficies de todos los ejemplos son **ficticios**. Las proporciones calculadas solo describen los valores introducidos; no son estadísticas oficiales ni permiten concluir riesgos, productividad, diversidad o sostenibilidad agrícolas.

## Plan de trabajo

| Práctica | Tema central | Tiempo efectivo |
|---|---|---:|
| 4.1 | Clases, objetos, atributos y métodos de instancia | 35 min |
| 4.2 | Constructores, parámetros nombrados, `this` y getters | 40 min |
| 4.3 | Encapsulamiento, estado válido y privacidad | 45 min |
| 4.4 | Composición: una observación contiene cultivos | 40 min |
| 4.5 | Colaboración entre objetos: catálogo y búsqueda | 40 min |
| 4.6 | Reto integrador: AgroDiversa orientada a objetos | 70 min |
| **Total** | **Lectura activa, ejecución, ejercicios y comprobaciones** | **270 min (4,5 h)** |

La preparación e instalación del SDK no forman parte de los 270 minutos. Los tiempos son objetivos de planificación, no sustituyen la comprobación práctica del laboratorio.

### Al finalizar podrás

- Explicar la diferencia entre **clase**, **objeto**, **atributo**, **método**, **instancia** y **constructor**.
- Crear varios objetos de una clase y comprobar que cada uno conserva su propio estado.
- Utilizar constructores con parámetros posicionales y nombrados, así como `this`.
- Diferenciar un método que usa datos de la instancia de una función independiente.
- Proteger reglas mediante encapsulamiento, campos privados, getters y métodos de comportamiento.
- Comprender que la privacidad en Dart se aplica a la **biblioteca**, no a la clase.
- Reconocer cuándo una relación entre objetos se expresa mediante **composición**.
- Modelar `CropArea`, `AgriculturalRecord` y `ObservationCatalog` con responsabilidades diferentes.
- Migrar información desde mapas anidados hacia objetos sin perder funcionalidades.
- Verificar casos normales, límites, duplicados, referencias compartidas y datos inexistentes.

## Preparación del proyecto

Conserva `dart_lab_03`: necesitarás consultar el comportamiento del reto final anterior. Crea otro proyecto de consola con **Dart 3 estable**:

~~~bash
dart create -t console dart_lab_04
cd dart_lab_04
dart run
~~~

Durante las prácticas crearás archivos independientes:

~~~text
dart_lab_04/
├── bin/
│   ├── dart_lab_04.dart
│   ├── practice_41.dart
│   ├── practice_42.dart
│   ├── practice_43.dart
│   ├── practice_44.dart
│   ├── practice_45.dart
│   └── agricultural_catalog_oop.dart
└── pubspec.yaml
~~~

Los archivos que todavía no existen se crearán en su práctica correspondiente. Por ejemplo:

~~~bash
dart run bin/practice_41.dart
~~~

Para mantener el alcance del laboratorio, los ejercicios se pueden resolver en un solo archivo por práctica. **La separación en bibliotecas, interfaces y módulos de producción se profundizará en el Laboratorio 05**.

El código, los identificadores, los nombres de archivo y los comentarios se escriben **en inglés**; las explicaciones están en español. Ejecuta cada ejemplo, haz una predicción antes de modificarlo y corrige los errores intencionales antes de continuar.

---

## Práctica 4.1 — Clases, objetos y métodos de instancia (35 min)

### Objetivos

Diferenciar un grupo de datos anónimos de un objeto con identidad conceptual y comportamiento; crear objetos independientes y reconocer el propósito de los métodos.

### 1. Del mapa al objeto

En el Laboratorio 03 podías representar un cultivo mediante un mapa:

~~~dart
void main() {
  Map<String, Object> crop = {
    'name': 'Coffee',
    'plantedArea': 125.0,
  };

  print(crop['name']);
  print(crop['plantedArea']);
}
~~~

Funciona, pero escribir `'plantedArea'` como texto deja margen para equivocaciones como `'plantedarea'`. Además, el mapa por sí solo no define qué operaciones pertenecen al concepto de cultivo.

Una **clase** describe los datos y operaciones que pueden compartir objetos de un mismo tipo. Un **objeto** es una instancia concreta creada a partir de esa clase.

### 2. La primera clase

Crea `bin/practice_41.dart`:

~~~dart
class CropArea {
  String name = '';
  double plantedArea = 0.0;

  void showDescription() {
    print('$name: $plantedArea ha');
  }
}

void main() {
  CropArea coffee = CropArea();

  coffee.name = 'Coffee';
  coffee.plantedArea = 125.0;

  coffee.showDescription();
}
~~~

Identifica estos elementos:

- `class CropArea`: declara una clase.
- `name` y `plantedArea`: son **atributos o variables de instancia**.
- `showDescription()`: es un **método**, una función que pertenece a la clase.
- `CropArea()`: crea una instancia mediante el constructor predeterminado.
- `coffee.name`: accede a un miembro del objeto con el operador `.`.

**Antes de ejecutar:** predice qué mostrará el programa. Cambia el área y comprueba que el método presenta el valor actualizado.

### 3. Dos objetos de la misma clase

~~~dart
class CropArea {
  String name = '';
  double plantedArea = 0.0;

  void showDescription() {
    print('$name: $plantedArea ha');
  }
}

void main() {
  CropArea coffee = CropArea();
  coffee.name = 'Coffee';
  coffee.plantedArea = 125.0;

  CropArea beans = CropArea();
  beans.name = 'Beans';
  beans.plantedArea = 40.0;

  coffee.showDescription();
  beans.showDescription();

  coffee.plantedArea = 130.0;

  coffee.showDescription();
  beans.showDescription();
}
~~~

Cada objeto conserva **sus propios valores**: modificar `coffee` no altera automáticamente `beans`.

**Ejercicio — Independencia:** crea un tercer objeto para `Cocoa`, cambia únicamente su área y muestra los tres objetos. Explica cuántas instancias existen y cuál clase las describe.

### 4. Métodos que devuelven un resultado

Los métodos pueden utilizar atributos sin recibirlos nuevamente como parámetros:

~~~dart
class CropArea {
  String name = '';
  double plantedArea = 0.0;

  double shareOf(double totalArea) {
    if (totalArea <= 0) {
      return 0.0;
    }

    return plantedArea / totalArea * 100;
  }
}

void main() {
  CropArea coffee = CropArea();
  coffee.name = 'Coffee';
  coffee.plantedArea = 125.0;

  double share = coffee.shareOf(250.0);
  print(share.toStringAsFixed(2));
}
~~~

El método `shareOf` usa el área del objeto actual y recibe el **total del conjunto** porque ese dato no pertenece a un cultivo individual.

El retorno `0.0` para un total no positivo es solo una **convención didáctica**: no significa que una proporción estadística sobre un total cero esté definida.

**Antes de ejecutar:** predice el resultado. Luego prueba `coffee.shareOf(500.0)` y explica qué dato se mantuvo y cuál cambió.

### 5. ¿Función o método?

~~~dart
double calculateAverage(double total, int count) {
  return total / count;
}

class CropArea {
  String name = '';
  double plantedArea = 0.0;

  String describe() {
    return '$name: $plantedArea ha';
  }
}

void main() {
  CropArea crop = CropArea();
  crop.name = 'Rice';
  crop.plantedArea = 20.0;

  print(crop.describe());
  print(calculateAverage(60.0, 3));
}
~~~

`calculateAverage` es una función independiente. `describe` es un método porque describe **el estado de una instancia**.

**Ejercicio:** escribe `double doubledArea()` dentro de la clase y devuelve el doble del área del objeto actual.

### 6. Primera comparación entre objetos y mapas

Crea un mapa y un objeto con la misma información. Explica qué permite detectar más fácilmente un error ortográfico en el nombre de un campo. No significa que todo mapa sea incorrecto: los mapas siguen siendo útiles para colecciones indexadas por clave y para representar datos externos.

### Laboratorio de errores — Objeto no creado

~~~dart
class CropArea {
  String name = '';
}

void main() {
  CropArea crop;
  print(crop.name);
}
~~~

La variable fue declarada, pero **no se inicializó con un objeto**. Ejecuta el análisis, identifica el problema y corrígelo creando `CropArea()` antes de acceder al atributo.

### Laboratorio de errores — Nombre incorrecto

~~~dart
class CropArea {
  String name = '';
}

void main() {
  CropArea crop = CropArea();
  print(crop.cropName);
}
~~~

El objeto existe, pero el atributo `cropName` **no está declarado**. Corrige el miembro consultado o, si lo prefieres, modifica la declaración de forma coherente.

### Reto — Tres cultivos independientes

Construye una clase `CropArea` con un nombre, una superficie y dos métodos: `describe()` que devuelve texto y `shareOf(totalArea)` que calcula una proporción. En `main()` crea tres objetos, calcula el total con una expresión y muestra para cada objeto su nombre, su área y su participación.

**Comprueba:** áreas 125, 75 y 50; total 250; participaciones 50%, 30% y 20%. Después cambia solo el área del segundo objeto, recalcula el total y comprueba que las proporciones se actualizan.

### Comprobación

¿Qué es una clase? ¿Qué es una instancia? ¿Qué diferencia hay entre un método de instancia y una función independiente? ¿Por qué cambiar `coffee.plantedArea` no modifica `beans.plantedArea`?

---

## Práctica 4.2 — Constructores, `this` y propiedades calculadas (40 min)

### Objetivos

Crear objetos con datos desde el primer momento, evitar estados incompletos, utilizar parámetros nombrados y conocer los getters.

### 1. El problema de un objeto a medio llenar

En la práctica anterior podías crear:

~~~dart
class CropArea {
  String name = '';
  double plantedArea = 0.0;
}

void main() {
  CropArea crop = CropArea();
  print(crop.name);
  print(crop.plantedArea);
}
~~~

El programa funciona, pero ¿qué significa un cultivo sin nombre y con área cero si el propósito era registrar una observación completa?

Un **constructor** recibe los datos iniciales y permite crear objetos que tienen sentido desde el principio.

### 2. Constructor posicional con `this`

Reemplaza `bin/practice_42.dart` por:

~~~dart
class CropArea {
  final String name;
  final double plantedArea;

  CropArea(this.name, this.plantedArea);

  String describe() {
    return '$name: $plantedArea ha';
  }
}

void main() {
  CropArea coffee = CropArea('Coffee', 125.0);
  CropArea beans = CropArea('Beans', 40.0);

  print(coffee.describe());
  print(beans.describe());
}
~~~

`CropArea(this.name, this.plantedArea)` utiliza **parámetros inicializadores**: los argumentos se guardan directamente en los atributos antes de ejecutar otros métodos. `final` impide reasignar sus valores después de la construcción.

**Antes de ejecutar:** predice la salida. ¿Qué pasará si llamas `CropArea('Coffee')` sin la superficie?

### 3. Parámetros nombrados y `required`

Para hacer las llamadas más legibles, utiliza parámetros nombrados:

~~~dart
class CropArea {
  final String name;
  final double plantedArea;

  CropArea({
    required this.name,
    required this.plantedArea,
  });

  String describe() => '$name: $plantedArea ha';
}

void main() {
  CropArea crop = CropArea(
    plantedArea: 125.0,
    name: 'Coffee',
  );

  print(crop.describe());
}
~~~

El orden ya no depende de la posición de los argumentos, pero los nombres deben coincidir. `required` obliga a suministrar ambos datos.

**Ejercicio:** crea dos objetos adicionales y llama al constructor utilizando en uno de ellos el orden inverso de argumentos.

### 4. Normalizar un dato al construir

A veces el valor recibido necesita transformarse antes de quedar guardado. Puedes utilizar la **lista de inicialización** del constructor:

~~~dart
class CropArea {
  final String name;
  final double plantedArea;

  CropArea({
    required String name,
    required this.plantedArea,
  }) : name = name.trim();

  String describe() => '$name: $plantedArea ha';
}

void main() {
  CropArea crop = CropArea(
    name: '  Coffee  ',
    plantedArea: 125.0,
  );

  print(crop.describe());
}
~~~

La asignación `: name = name.trim()` ocurre **antes del cuerpo del constructor**. Se utiliza un parámetro local `name` y un campo `name`; su relación se hace explícita en la lista de inicialización.

**Ejercicio:** construye un objeto con `' Beans '` y observa el nombre normalizado. Intenta eliminar la inicialización de `name` y explica el error relacionado con un campo `final`.

### 5. Constructor nombrado

Un constructor puede recibir un nombre que describa para qué se utiliza:

~~~dart
class CropArea {
  final String name;
  final double plantedArea;

  CropArea({required this.name, required this.plantedArea});

  CropArea.example()
      : name = 'Coffee',
        plantedArea = 125.0;
}

void main() {
  CropArea sample = CropArea.example();
  CropArea custom = CropArea(name: 'Beans', plantedArea: 40.0);

  print(sample.name);
  print(custom.name);
}
~~~

`CropArea.example()` es un **constructor nombrado**, útil aquí para crear un ejemplo didáctico. No es todavía una función que consulta un archivo o una API.

**Ejercicio:** crea `CropArea.emptyExample()` con un nombre de prueba y una superficie de `1.0`. Explica por qué no conviene usar un constructor de ejemplos en la capa que procesa datos oficiales.

### 6. Getter: una propiedad calculada

~~~dart
class CropArea {
  final String name;
  final double plantedArea;

  CropArea({required this.name, required this.plantedArea});

  double get areaInSquareMeters => plantedArea * 10000.0;
}

void main() {
  CropArea crop = CropArea(name: 'Beans', plantedArea: 2.5);

  print(crop.plantedArea);
  print(crop.areaInSquareMeters);
}
~~~

Un **getter** se declara con `get` y se accede como una propiedad, **sin paréntesis**. En este caso se calcula cada vez que se consulta. La conversión entre hectáreas y metros cuadrados solo ilustra la idea matemática; el laboratorio no transforma ni valida unidades de un dataset.

**Predice:** ¿qué valor devuelve `areaInSquareMeters` con `2.5` hectáreas?

### 7. `final` y objetos

~~~dart
class CropArea {
  final String name;
  final double plantedArea;

  CropArea({required this.name, required this.plantedArea});
}

void main() {
  final crop = CropArea(name: 'Coffee', plantedArea: 125.0);

  print(crop.name);
}
~~~

La variable `crop` no puede apuntar a otro objeto. Además, sus campos `final` no pueden reasignarse. **No confundas** esta situación con una clase que contiene una `List` mutable: más adelante comprobarás que hacer `final` una referencia a lista no vuelve inmutables sus elementos.

### Laboratorio de errores — Constructor incompleto

~~~dart
class CropArea {
  final String name;
  final double plantedArea;

  CropArea({required this.name, required this.plantedArea});
}

void main() {
  CropArea crop = CropArea(name: 'Coffee');
  print(crop.name);
}
~~~

Corrige la llamada sin eliminar `required` ni sustituir `double` por un tipo más general.

### Reto — Objetos con creación explícita

Escribe una clase `CropArea` con parámetros nombrados obligatorios, normalización del nombre, un getter `areaInSquareMeters` y un método `describe()`. Crea tres objetos con áreas `1.0`, `2.5` y `3.0`. Muestra sus superficies en hectáreas y metros cuadrados.

**Ampliación voluntaria:** agrega un constructor nombrado `CropArea.example()` con datos ficticios. No es necesario para completar el reto.

### Comprobación

¿Qué problema resuelve un constructor? ¿En qué se diferencian parámetros posicionales y nombrados? ¿Qué representa `this`? ¿Qué diferencia hay entre un getter y almacenar manualmente otro campo con el mismo valor calculado?

---

## Práctica 4.3 — Encapsulamiento y reglas de un objeto (45 min)

### Objetivos

Comprender por qué no se debe permitir cualquier modificación de estado y cómo ocultar detalles internos detrás de operaciones comprensibles.

### 1. Un objeto que cualquiera puede dejar en un estado inválido

Crea `bin/practice_43.dart`:

~~~dart
class AreaCounter {
  double totalArea = 0.0;
}

void main() {
  AreaCounter counter = AreaCounter();

  counter.totalArea = 100.0;
  counter.totalArea = -999.0;

  print(counter.totalArea);
}
~~~

El atributo público permite escribir cualquier número. Para este **contador de superficies positivas**, eso rompe la intención del objeto.

### 2. Campo privado y operación controlada

~~~dart
class AreaCounter {
  double _totalArea = 0.0;

  double get totalArea => _totalArea;

  bool addArea(double area) {
    if (!area.isFinite || area <= 0) {
      return false;
    }

    _totalArea += area;
    return true;
  }
}

void main() {
  AreaCounter counter = AreaCounter();

  print(counter.addArea(25.0));
  print(counter.addArea(-3.0));
  print(counter.totalArea);
}
~~~

- `_totalArea` es **privado a la biblioteca** que lo declara.
- `totalArea` es un getter público de solo lectura.
- `addArea` expresa una operación válida y rechaza valores no positivos o no finitos.
- El método devuelve `bool` para informar si se aceptó el cambio.

**Predice** los tres valores impresos. Luego llama a `addArea(0.0)`, `addArea(double.nan)` y `addArea(50.0)`. ¿Cuándo cambia el total?

### 3. Una precisión importante: privacidad por biblioteca

En Dart, el guion bajo inicial **no significa privado a una instancia o a una clase**: significa **privado a la biblioteca**. Si varias clases se encuentran en el mismo archivo/biblioteca, pueden acceder a los identificadores privados de esa biblioteca.

Este ejemplo sirve para reconocer esa limitación:

~~~dart
class AreaCounter {
  double _totalArea = 0.0;

  double get totalArea => _totalArea;
}

void main() {
  AreaCounter counter = AreaCounter();

  counter._totalArea = -10.0;

  print(counter.totalArea);
}
~~~

El código puede acceder a `_totalArea` porque está **en la misma biblioteca**. No interpretes `_` como una frontera de seguridad.

Para comprobar el acceso entre bibliotecas, crea dos archivos:

`bin/area_counter.dart`:

~~~dart
class AreaCounter {
  double _totalArea = 0.0;

  double get totalArea => _totalArea;

  bool addArea(double area) {
    if (!area.isFinite || area <= 0) {
      return false;
    }

    _totalArea += area;
    return true;
  }
}
~~~

`bin/counter_client.dart`:

~~~dart
import 'area_counter.dart';

void main() {
  AreaCounter counter = AreaCounter();

  counter.addArea(25.0);
  print(counter.totalArea);

  // counter._totalArea = -10.0; // Not accessible from another library.
}
~~~

Ejecuta:

~~~bash
dart run bin/counter_client.dart
~~~

Descomenta temporalmente el acceso a `_totalArea` y ejecuta `dart analyze bin/counter_client.dart`. Observa por qué ahora no es válido. Vuelve a comentar la línea antes de seguir.

**Conclusión:** en el laboratorio final conviene utilizar las operaciones públicas del objeto, incluso cuando dos clases compartan la misma biblioteca.

### 4. No todo cambio merece un setter

Podrías permitir:

~~~dart
class TemperatureRecord {
  double _celsius = 0.0;

  double get celsius => _celsius;

  set celsius(double value) {
    if (!value.isFinite) {
      throw ArgumentError.value(value, 'value', 'Must be finite.');
    }

    _celsius = value;
  }
}

void main() {
  TemperatureRecord record = TemperatureRecord();

  record.celsius = 21.0;
  print(record.celsius);
}
~~~

El setter `set celsius` controla la escritura. **No lo agregues automáticamente a todos los campos.** Si la regla de un objeto es *registrar superficie*, un método `addArea` suele expresar mejor esa intención que un setter arbitrario `totalArea = ...`.

El uso de `ArgumentError` anuncia un concepto que estudiarás con detalle en el Laboratorio 05: **fallar explícitamente cuando se viola una precondición**. Por ahora ejecuta únicamente el ejemplo válido.

### 5. Validaciones que pertenecen al objeto

Regresa a `CropArea`. Queremos que no existan cultivos construidos con nombre vacío ni superficie inválida:

~~~dart
class CropArea {
  final String name;
  final double plantedArea;

  CropArea({
    required String name,
    required this.plantedArea,
  }) : name = name.trim() {
    if (this.name.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Name is required.');
    }

    if (!plantedArea.isFinite || plantedArea <= 0) {
      throw ArgumentError.value(
        plantedArea,
        'plantedArea',
        'Area must be positive and finite.',
      );
    }
  }
}

void main() {
  CropArea crop = CropArea(
    name: ' Coffee ',
    plantedArea: 125.0,
  );

  print(crop.name);
  print(crop.plantedArea);
}
~~~

El constructor valida después de inicializar los campos. El usuario de la clase no necesita recordar una comprobación adicional cada vez que crea un objeto.

**No intentes capturar todas las excepciones silenciosamente** para aparentar que el programa funcionó: en el próximo laboratorio aprenderás a distinguir excepciones esperadas y fallos de programación.

### 6. Un objeto estable frente a uno mutable

Compara:

- `AreaCounter` necesita cambiar su total mediante una operación controlada.
- `CropArea` representa un cultivo y área ya registrados, por lo que sus campos son `final`.

No es obligatorio que **todo** sea mutable o que **todo** sea inmutable. Elige según la responsabilidad. La inmutabilidad de un modelo sencillo reduce los estados que deben comprobarse.

### 7. Análisis de responsabilidades

Imagina una clase `AgriculturalRecord`:

- ¿Debe permitir establecer `totalArea` desde fuera?
- ¿O debería calcular `totalArea` sumando sus cultivos?
- ¿Debe permitir modificar directamente la colección interna?
- ¿Qué sucedería si una operación elimina el último cultivo?

Escribe una propuesta con tres **operaciones públicas**, no una lista de setters para todos los campos. La práctica siguiente utilizará composición para resolverlo.

### Laboratorio de errores — Una validación demasiado tarde

~~~dart
class AreaCounter {
  double totalArea = 0.0;

  void addArea(double area) {
    totalArea += area;

    if (area <= 0) {
      print('Invalid area.');
    }
  }
}

void main() {
  AreaCounter counter = AreaCounter();
  counter.addArea(-10.0);
  print(counter.totalArea);
}
~~~

El error se informa **después de modificar el estado**. Corrige el orden: primero validar, después cambiar. Prueba un área positiva y una negativa.

### Reto — Contador con reglas

Implementa `AreaCounter` con:

- Campo privado `_totalArea`.
- Getter `totalArea`.
- Método `addArea(double area)` que devuelva `bool`.
- Método `reset()` para reiniciar el contador **solo mediante una operación explícita**.
- Rechazo de `-1`, `0`, `double.nan` y `double.infinity`.

Prueba dos contadores diferentes: actualizar uno no debe modificar el otro.

### Comprobación

¿Por qué un atributo público puede permitir estados incorrectos? ¿Qué garantiza un método de comportamiento? ¿Qué significa exactamente privado en Dart? ¿Por qué un getter calculado no necesita un campo que almacene su resultado?

---

