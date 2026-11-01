# Laboratorio 03 — Funciones y colecciones en Dart: de un resumen a muchos registros

En el [Laboratorio 02](laboratorio-02.md) creaste un explorador agrícola de consola capaz de validar datos, procesar varios cultivos y conservar el último resumen. Su principal limitación era que **no podía recordar múltiples observaciones ni consultar sus cultivos por separado**.

En este laboratorio mejorarás las funciones y aprenderás a utilizar las tres colecciones principales de Dart: `List`, `Set` y `Map`. El reto integrador conservará distintas observaciones de municipio y año en memoria y permitirá recuperarlas, consultarlas y obtener un catálogo de cultivos únicos.

**No se requiere experiencia en otros lenguajes ni en Flutter.** Sí necesitas los fundamentos practicados en los laboratorios 01 y 02.

> **Contexto:** las cifras, municipios y cultivos son **ejemplos ficticios**. Los indicadores de áreas son descripciones matemáticas de las entradas y no deben interpretarse como diagnósticos de diversidad, riesgo o sostenibilidad agrícolas.

## Plan de trabajo

| Práctica | Tema | Duración |
|---|---|---:|
| 3.1 | Funciones, parámetros nombrados y separación de responsabilidades | 35 min |
| 3.2 | `List`: índices, cambios, búsquedas y copias | 40 min |
| 3.3 | `Set`: unicidad, pertenencia y operaciones | 35 min |
| 3.4 | `Map`: claves, valores, registros y anidación | 45 min |
| 3.5 | Filtrar, transformar, ordenar y resumir colecciones | 35 min |
| 3.6 | Reto integrador: catálogo de observaciones agrícolas | 80 min |
| **Total** | **Trabajo práctico** | **270 min (4,5 horas)** |

La instalación del entorno no está incluida. Estos tiempos incluyen la ejecución de ejemplos, ejercicios, depuración, retos y comprobaciones.

### Objetivos

Al finalizar podrás:

- Organizar operaciones en funciones con responsabilidades claras.
- Emplear parámetros posicionales, nombrados, obligatorios y predeterminados.
- Crear listas tipadas, recorrerlas y evitar índices fuera de rango.
- Distinguir compartir una lista de crear una copia independiente.
- Elegir conjuntos para representar valores únicos.
- Utilizar mapas tipados para relacionar claves con valores.
- Comprender la recuperación de valores opcionales en mapas.
- Transformar datos con `where`, `map`, `toList` y `fold`, después de resolver el problema con ciclos.
- Almacenar varias observaciones agrícolas en memoria sin introducir aún clases ni persistencia.
- Comprobar comportamientos normales, condiciones límite y fallos.

## Preparación

Conserva el proyecto `dart_lab_02`. Crea otro proyecto de consola:

~~~bash
dart create -t console dart_lab_03
cd dart_lab_03
dart run
~~~

Organizarás los archivos progresivamente:

~~~text
dart_lab_03/
├── bin/
│   ├── dart_lab_03.dart
│   ├── practice_31.dart
│   ├── practice_32.dart
│   ├── practice_33.dart
│   ├── practice_34.dart
│   ├── practice_35.dart
│   └── agricultural_catalog.dart
└── pubspec.yaml
~~~

Para ejecutar el primer ejemplo desde la raíz del proyecto:

~~~bash
dart run bin/practice_31.dart
~~~

Los ejemplos, identificadores, mensajes, comentarios y nombres de archivos están en **inglés**. Las explicaciones están en español.

**Método de estudio:** predice primero; luego ejecuta y modifica. Conserva los ejercicios resueltos y corrige los errores intencionales antes de avanzar.

---

## Práctica 3.1 — Funciones y responsabilidades (35 min)

### Objetivos

Mejorar el diseño de funciones, comprender los parámetros nombrados y evitar mezclar lectura de terminal, cálculo y presentación.

### 1. Una función que devuelve un valor

Crea `bin/practice_31.dart`:

~~~dart
double calculateShare(double cropArea, double totalArea) {
  if (totalArea <= 0) {
    return 0.0;
  }

  return cropArea / totalArea * 100;
}

void main() {
  double share = calculateShare(75.0, 300.0);
  print(share.toStringAsFixed(2));
}
~~~

**Antes de ejecutar:** predice el resultado. Cambia el total a `0.0` y explica por qué la función devuelve el valor convencional `0.0` en lugar de intentar dividir entre cero. Ese cero **no significa** que exista un porcentaje estadístico definido sobre un total cero.

### 2. Retornar no es imprimir

~~~dart
double calculateTotal(double first, double second) {
  return first + second;
}

void showTotal(double first, double second) {
  print(first + second);
}

void main() {
  double result = calculateTotal(30.0, 20.0);
  print(result);
  showTotal(30.0, 20.0);
}
~~~

La primera función devuelve un resultado reutilizable; la segunda lo imprime, pero no permite trabajar posteriormente con ese valor devuelto.

**Ejercicio:** utiliza `calculateTotal` dos veces y suma los resultados, sin repetir manualmente la fórmula dentro de `main()`.

### 3. Parámetros nombrados y obligatorios

~~~dart
void showObservation({
  required String municipality,
  required int year,
  String unit = 'ha',
}) {
  print('Municipality: $municipality');
  print('Year: $year');
  print('Unit: $unit');
}

void main() {
  showObservation(municipality: 'Andes', year: 2025);

  showObservation(
    year: 2024,
    municipality: 'La Mesa',
    unit: 'hectares',
  );
}
~~~

- Las llaves en la declaración marcan **parámetros nombrados**.
- `required` obliga a entregar el dato.
- `unit = 'ha'` define un argumento opcional con valor predeterminado.
- Los argumentos nombrados pueden suministrarse en distinto orden.

**Depuración:** elimina `municipality: 'Andes'` de la primera llamada, observa el error y corrígelo. **Ejercicio:** añade `bool preliminary = false` como parámetro nombrado y muestra su valor.

### 4. La sintaxis de flecha `=>`

~~~dart
double calculateAverage(double total, int count) {
  return total / count;
}

double calculateAverageShort(double total, int count) => total / count;

void main() {
  print(calculateAverage(45.0, 3));
  print(calculateAverageShort(45.0, 3));
}
~~~

`=>` es una alternativa cuando el cuerpo de la función consiste en una sola expresión. No debe utilizarse si escribir varias instrucciones resulta más claro.

**Ejercicio:** define y ejecuta `double doubleArea(double area) => area * 2;`.

### 5. Funciones y variables locales

Este ejemplo anticipa el tema de listas:

~~~dart
double calculateTotal(List<double> areas) {
  double total = 0.0;

  for (final area in areas) {
    total += area;
  }

  return total;
}

void main() {
  List<double> areas = [20.0, 30.0, 50.0];
  double result = calculateTotal(areas);

  print(result);
  print(areas);
}
~~~

La función recibe valores mediante el parámetro `areas` y utiliza una variable local `total`. **No altera** la colección que recibe ni depende de variables globales.

### Reto — Tres funciones

Implementa:

- `double calculateTotal(List<double> areas)`: suma superficies.
- `double calculateAverage(List<double> areas)`: calcula promedio; para una lista vacía devuelve `0.0` como regla didáctica.
- `void showSummary({required String municipality, required double total, required double average})`: muestra resultados sin volver a calcularlos.

Usa las listas `[20.0, 30.0]` y `[10.0, 20.0, 30.0]`. Predice sus totales y promedios antes de ejecutar.

### Depuración — Orden incorrecto

~~~dart
double calculateShare(double cropArea, double totalArea) {
  return cropArea / totalArea * 100;
}

void main() {
  print(calculateShare(200.0, 50.0));
}
~~~

El código es sintácticamente válido, pero los argumentos no representan correctamente la relación de **área individual / total**. Corrige los datos y propone cómo ayudarían los parámetros nombrados.

### Comprobación

¿En qué se diferencia un parámetro de un argumento? ¿Cuándo usarías `required` y cuándo un valor predeterminado? ¿Por qué conviene separar las funciones de cálculo de las funciones de presentación?

---

## Práctica 3.2 — Listas: datos ordenados (40 min)

### Objetivos

Crear, recorrer y modificar listas, comprender índices y evitar confundir referencias compartidas con copias.

### 1. Crear y consultar `List`

Crea `bin/practice_32.dart`:

~~~dart
void main() {
  List<String> crops = ['Coffee', 'Plantain', 'Avocado'];

  print(crops);
  print(crops.length);
  print(crops[0]);
  print(crops[2]);
}
~~~

Una `List<String>` contiene elementos de texto **ordenados**. Los índices comienzan en cero: si hay tres elementos, sus posiciones son `0`, `1` y `2`.

**Antes de ejecutar:** predice la salida. Después cambia el último índice por `3`: ¿por qué puede fallar durante la ejecución?

### 2. Listas vacías y acceso seguro

~~~dart
void main() {
  List<String> crops = [];

  if (crops.isNotEmpty) {
    print(crops.first);
  } else {
    print('No crops available.');
  }
}
~~~

`first` necesita una lista con al menos un elemento. La comprobación `isNotEmpty` evita intentar leer un elemento inexistente.

### 3. Agregar, insertar y reemplazar

~~~dart
void main() {
  List<String> crops = ['Coffee', 'Plantain'];

  crops.add('Avocado');
  crops[1] = 'Cocoa';
  crops.insert(1, 'Beans');

  print(crops);
}
~~~

**Predice el orden final** antes de ejecutar. Luego agrega `'Rice'` y sustituye el elemento de posición `0`.

### 4. Buscar y eliminar

~~~dart
void main() {
  List<String> crops = ['Coffee', 'Cocoa', 'Coffee', 'Beans'];

  print(crops.contains('Coffee'));
  print(crops.indexOf('Cocoa'));

  crops.remove('Coffee');
  print(crops);

  crops.removeAt(1);
  print(crops);
}
~~~

`contains` comprueba si existe un valor; `indexOf` devuelve su posición o `-1` si no aparece. `remove` elimina la primera coincidencia; `removeAt` elimina por índice.

**Ejercicio:** busca `'Rice'`. Explica por qué no debes usar `removeAt(crops.indexOf('Rice'))` sin revisar antes el resultado de la búsqueda.

### 5. Recorridos por índice y por elemento

~~~dart
void main() {
  List<String> crops = ['Coffee', 'Beans', 'Rice'];

  for (int index = 0; index < crops.length; index++) {
    String crop = crops[index];
    print('Position $index: $crop');
  }

  for (final crop in crops) {
    print('Crop: $crop');
  }
}
~~~

El primer ciclo es útil cuando necesitas la posición. `for-in` recorre directamente los elementos.

**Ejercicio:** imprime los cultivos con numeración humana `1`, `2`, `3`. Hazlo con ambos tipos de ciclo; en la versión `for-in` agrega un contador.

### 6. Operar sobre una lista numérica

~~~dart
void main() {
  List<double> areas = [125.0, 75.0, 50.0];
  double total = 0.0;
  double largest = 0.0;

  for (final area in areas) {
    total += area;

    if (area > largest) {
      largest = area;
    }
  }

  print('Total: $total');
  print('Largest: $largest');
}
~~~

La lista conserva cada número después del cálculo. Agrega `25.0` y vuelve a calcular los resultados sin escribirlos a mano.

### 7. `final`, `const` y mutabilidad

~~~dart
void main() {
  final List<String> mutableCrops = ['Coffee', 'Cocoa'];
  mutableCrops.add('Beans');

  const List<String> fixedCrops = ['Rice', 'Plantain'];

  print(mutableCrops);
  print(fixedCrops);
}
~~~

`final` impide reasignar la variable, **no** modificar los elementos de la lista. Una lista creada con `const` sí es inmutable.

Para experimentar, agrega temporalmente `fixedCrops.add('Beans');`. Observa el error de modificación durante la ejecución, y después elimina esa instrucción.

### 8. Una asignación no es una copia

~~~dart
void main() {
  List<String> original = ['Coffee', 'Beans'];
  List<String> shared = original;
  List<String> separate = List<String>.from(original);

  shared.add('Cocoa');
  separate.add('Rice');

  print('Original: $original');
  print('Separate copy: $separate');
}
~~~

`shared` y `original` se refieren a la **misma lista**. `List<String>.from` crea otra lista. Es una copia **superficial**: no duplica necesariamente objetos mutables almacenados dentro de ella.

**Predice** qué lista contiene `Cocoa` y cuál contiene `Rice`.

### Depuración — Índice fuera de rango

~~~dart
void main() {
  List<String> crops = ['Coffee', 'Beans', 'Rice'];

  for (int index = 0; index <= crops.length; index++) {
    print(crops[index]);
  }
}
~~~

Modifica **un operador** para evitar intentar acceder a un índice inexistente.

### Reto — Historial de nombres

Crea una lista de cultivos. Debe permitir agregar nombres, mostrar su posición, buscar uno mediante `contains`, eliminar la primera coincidencia y volver a mostrar la lista. Comprueba una lista vacía y una búsqueda fallida. No uses aún clases.

### Comprobación

¿Por qué el último índice es `length - 1`? ¿Cuándo elegirías `for-in`? ¿Por qué `final` no hace inmutable una lista? ¿Qué diferencia existe entre compartir y copiar una lista?

---

## Práctica 3.3 — Conjuntos: valores únicos (35 min)

### Objetivos

Comprender el propósito de `Set`, normalizar nombres y distinguir registros repetidos de categorías únicas.

### 1. Una colección sin duplicados

Crea `bin/practice_33.dart`:

~~~dart
void main() {
  Set<String> crops = {'Coffee', 'Cocoa', 'Beans'};
  crops.add('Coffee');

  print(crops.length);
  print(crops.contains('Coffee'));
}
~~~

Aunque intentaste incorporar **cuatro valores** mediante el literal y `add`, el conjunto conserva **tres elementos distintos**. Un conjunto representa **pertenencia y unicidad**, no acceso por posición. No utilices `crops[0]`.

### 2. Lista de registros y conjunto de valores únicos

~~~dart
void main() {
  List<String> reportedCrops = ['Coffee', 'Cocoa', 'Coffee', 'Beans'];
  Set<String> uniqueCrops = reportedCrops.toSet();

  print(reportedCrops.length);
  print(uniqueCrops.length);
  print(uniqueCrops);
}
~~~

La lista conserva las cuatro ocurrencias. El conjunto guarda únicamente los nombres distintos. **No elimines datos de origen** solo porque dos registros tienen el mismo nombre: podrían corresponder a años o municipios diferentes.

**Ejercicio:** agrega dos veces `'Rice'` y comprueba ambas longitudes.

### 3. Crear, agregar y quitar elementos

~~~dart
void main() {
  Set<String> crops = <String>{};

  crops.add('Coffee');
  crops.add('Beans');
  crops.add('Coffee');

  print(crops.length);

  crops.remove('Beans');
  print(crops.contains('Beans'));
}
~~~

La sintaxis `<String>{}` crea un conjunto vacío tipado. **Advertencia:** `{}` sin tipo se interpreta como un mapa vacío, no como un conjunto.

### 4. Normalizar antes de comparar

~~~dart
void main() {
  List<String> rawNames = ['Coffee', 'coffee', ' COFFEE ', 'Cocoa'];
  Set<String> uniqueNames = <String>{};

  for (final name in rawNames) {
    uniqueNames.add(name.trim().toLowerCase());
  }

  print(uniqueNames);
  print(uniqueNames.length);
}
~~~

**Ejercicio:** agrega `' Cocoa '` y explica por qué el número de valores distintos sigue siendo `2`. Normalizar sirve para identificar coincidencias; las etiquetas de presentación pueden conservar una capitalización más legible.

### 5. Unión, intersección y diferencia

~~~dart
void main() {
  Set<String> firstYear = {'Coffee', 'Cocoa', 'Beans'};
  Set<String> secondYear = {'Coffee', 'Rice', 'Beans'};

  print(firstYear.union(secondYear));
  print(firstYear.intersection(secondYear));
  print(firstYear.difference(secondYear));
}
~~~

- **Unión:** todos los elementos presentes en alguno.
- **Intersección:** elementos comunes a ambos.
- **Diferencia:** los que están en el primero, pero no en el segundo.

**Antes de ejecutar:** escribe los conjuntos que esperas. No presupongas un orden específico de impresión de los conjuntos.

### 6. Convertir a lista para mostrar ordenadamente

~~~dart
void main() {
  Set<String> crops = {'Coffee', 'Cocoa', 'Beans'};
  List<String> sortedCrops = crops.toList();

  sortedCrops.sort();
  print(sortedCrops);
}
~~~

Un conjunto no debe tratarse como una lista con índices. Si necesitas una presentación ordenada, convierte los valores a lista y ordénalos.

### Depuración — Conjunto vacío incorrecto

~~~dart
void main() {
  var crops = {};

  crops.add('Coffee');
  print(crops);
}
~~~

La expresión `{}` crea un mapa. Corrige la declaración a `Set<String> crops = <String>{};` y vuelve a ejecutar.

### Reto — Cultivos únicos

Parte de seis nombres con repeticiones, espacios y diferencias de mayúsculas. Construye un conjunto normalizado, muestra la cantidad de registros originales y nombres únicos, imprime los nombres ordenados alfabéticamente y comprueba si aparece `'coffee'`.

### Comprobación

¿En qué se diferencia un registro repetido de un valor único? ¿Por qué `Set` no reemplaza a `List`? ¿Qué método sirve para encontrar cultivos comunes entre dos conjuntos?

---

## Práctica 3.4 — Mapas: claves, valores y registros anidados (45 min)

### Objetivos

Relacionar datos mediante claves, detectar claves repetidas, acceder a valores que pueden faltar y organizar datos relacionados sin crear clases todavía.

### 1. Un mapa relaciona claves con valores

En los ejemplos anteriores guardaste nombres en una lista y superficies en otra. Si el objetivo es relacionar cada nombre con su superficie, un `Map` puede resultar más claro.

Crea `bin/practice_34.dart`:

~~~dart
void main() {
  Map<String, double> cropAreas = {
    'Coffee': 125.0,
    'Plantain': 75.0,
    'Avocado': 50.0,
  };

  print(cropAreas);
  print(cropAreas.length);
  print(cropAreas['Coffee']);
}
~~~

`Map<String, double>` indica que las **claves** son cadenas de texto y los **valores** son números decimales. Una clave identifica como máximo **un valor** en un mapa.

**Antes de ejecutar:** predice lo que devuelve la consulta `cropAreas['Coffee']`.

### 2. ¿Qué ocurre con una clave inexistente?

~~~dart
void main() {
  Map<String, double> cropAreas = {'Coffee': 125.0};

  double? existingArea = cropAreas['Coffee'];
  double? missingArea = cropAreas['Rice'];

  print(existingArea);
  print(missingArea);
}
~~~

Aunque el mapa almacene `double`, buscar una clave devuelve **`double?`**: si no existe, el resultado es `null`.

Hay dos formas sencillas de responder a esa posibilidad:

~~~dart
void main() {
  Map<String, double> cropAreas = {'Coffee': 125.0};

  double areaOrZero = cropAreas['Rice'] ?? 0.0;
  print(areaOrZero);

  double? coffeeArea = cropAreas['Coffee'];

  if (coffeeArea != null) {
    print('Coffee area: $coffeeArea');
  }
}
~~~

`??` establece un valor predeterminado. **No lo uses para ocultar errores:** devolver cero tiene sentido solo si esa regla corresponde a tu problema.

**Ejercicio:** muestra un mensaje diferente si un cultivo existe y si no existe, sin usar el operador de afirmación `!`.

### 3. Agregar, actualizar y eliminar

~~~dart
void main() {
  Map<String, double> cropAreas = {'Coffee': 125.0};

  cropAreas['Beans'] = 40.0;
  cropAreas['Coffee'] = 130.0;

  print(cropAreas);

  cropAreas.remove('Beans');
  print(cropAreas);
}
~~~

La asignación a una clave nueva agrega una entrada; asignar a una clave existente **reemplaza su valor anterior**.

**Ejercicio:** inicia un mapa con `'Cocoa': 20.0` y agrega otra asignación a `'Cocoa'` con `35.0`. ¿Cuántas entradas quedan? ¿Qué área conserva? Esto explica por qué el registro final debe verificar duplicados antes de almacenar.

### 4. Recorrer claves, valores y entradas

~~~dart
void main() {
  Map<String, double> cropAreas = {
    'Coffee': 125.0,
    'Beans': 40.0,
  };

  for (final name in cropAreas.keys) {
    print('Crop: $name');
  }

  for (final area in cropAreas.values) {
    print('Area: $area');
  }

  for (final entry in cropAreas.entries) {
    String crop = entry.key;
    double area = entry.value;
    print('$crop: $area ha');
  }
}
~~~

`entries` permite recorrer juntos nombre y superficie. Cada entrada tiene `key` y `value`.

**Ejercicio:** calcula el total usando `cropAreas.values` y un ciclo `for-in`. Después muestra cada par de nombre y superficie sin crear listas paralelas.

### 5. Contar y acumular por clave

Un mapa también permite acumular información agrupada:

~~~dart
void main() {
  List<String> cropNames = ['Coffee', 'Beans', 'Coffee', 'Rice', 'Beans'];

  Map<String, int> appearances = <String, int>{};

  for (final name in cropNames) {
    int previousCount = appearances[name] ?? 0;
    appearances[name] = previousCount + 1;
  }

  print(appearances);
}
~~~

**Predice:** ¿cuántas apariciones tiene `Coffee` y cuántas `Rice`? ¿Por qué aquí es correcto reemplazar el valor de una clave, mientras que en el mapa de superficies del apartado anterior podría significar pérdida de un dato?

### 6. Mapas anidados: varios registros

Para conservar más de una observación sin crear clases, puedes usar **un mapa cuyos valores sean también mapas**:

~~~dart
void main() {
  Map<String, Map<String, double>> observations = {
    'Andes (2025)': {
      'Coffee': 125.0,
      'Plantain': 75.0,
    },
    'Andes (2024)': {
      'Coffee': 110.0,
      'Beans': 40.0,
    },
  };

  print(observations.keys);
  print(observations['Andes (2025)']);
}
~~~

El mapa **externo** relaciona un identificador legible de observación con los cultivos registrados. El mapa **interno** relaciona cada cultivo con su superficie.

Este diseño tiene una limitación deliberada: almacena el municipio y el año juntos en una **clave de texto**. Más adelante, con programación orientada a objetos, podrás diseñar modelos con campos separados y reglas más explícitas. Por ahora nos permite practicar colecciones sin introducir conceptos nuevos antes de tiempo.

### 7. Consultar una observación inexistente

~~~dart
void main() {
  Map<String, Map<String, double>> observations = {
    'Andes (2025)': {'Coffee': 125.0},
  };

  Map<String, double>? selected = observations['Unknown (2025)'];

  if (selected == null) {
    print('Observation not found.');
  } else {
    print(selected);
  }
}
~~~

La consulta al mapa externo devuelve `Map<String, double>?`. No intentes utilizar directamente `selected.length` antes de verificar que `selected` no sea nulo.

### 8. Copia superficial en mapas anidados

~~~dart
void main() {
  Map<String, Map<String, double>> original = {
    'Andes (2025)': {'Coffee': 125.0},
  };

  Map<String, Map<String, double>> shallowCopy = Map.of(original);

  Map<String, double>? sharedInnerMap = shallowCopy['Andes (2025)'];

  if (sharedInnerMap != null) {
    sharedInnerMap['Coffee'] = 150.0;
  }

  print(original);
}
~~~

Aunque `shallowCopy` sea otro mapa externo, **ambos mapas siguen compartiendo el mapa interno**. Para guardar una observación de manera independiente, en nuestro reto utilizaremos:

~~~dart
void main() {
  Map<String, double> inputCrops = {'Coffee': 125.0};
  Map<String, double> savedCrops = Map<String, double>.from(inputCrops);

  inputCrops['Coffee'] = 200.0;

  print(savedCrops['Coffee']);
}
~~~

La copia es suficiente en este caso porque los valores internos son `double`, no otros objetos mutables.

### Depuración — Sobrescribir sin querer

~~~dart
void main() {
  Map<String, double> crops = {'Coffee': 125.0};

  crops['Coffee'] = 75.0;

  print(crops);
}
~~~

Si esas dos superficies representaban **dos registros distintos**, se perdió la primera. Explica cuál es la limitación de utilizar solo el nombre como clave y qué información adicional sería necesaria para distinguir registros entre municipios y años.

### Reto — Consulta de observaciones

Construye un `Map<String, Map<String, double>>` con **tres observaciones**, al menos dos cultivos por observación y dos años diferentes. Muestra:

- Los identificadores disponibles.
- Cuántos cultivos tiene cada observación.
- La superficie total de cada observación.
- Un mensaje comprensible al solicitar un identificador inexistente.

**Comprobación:** añade una nueva observación y confirma que el total de observaciones aumenta, pero los registros existentes conservan sus superficies.

### Comprobación

¿Qué diferencia hay entre clave y valor? ¿Por qué consultar una clave produce un valor nullable? ¿Qué ocurre cuando escribes dos veces la misma clave? ¿Qué parte del mapa anidado representa una observación y cuál representa sus cultivos?

---

## Práctica 3.5 — Filtrar, transformar y resumir colecciones (35 min)

### Objetivos

Comparar ciclos explícitos con operaciones sobre `Iterable` y aprender a identificar cuándo se produce una lista nueva y cuándo se modifica la colección original.

### 1. Primero resolver con `for`

Crea `bin/practice_35.dart`:

~~~dart
void main() {
  List<double> areas = [10.0, 50.0, 5.0, 80.0];
  List<double> selectedAreas = <double>[];

  for (final area in areas) {
    if (area >= 20.0) {
      selectedAreas.add(area);
    }
  }

  print(selectedAreas);
}
~~~

**Predice:** ¿cuáles valores superan el umbral elegido? El límite `20.0` es solo un criterio de práctica.

### 2. Resolver con `where`

~~~dart
void main() {
  List<double> areas = [10.0, 50.0, 5.0, 80.0];

  List<double> selectedAreas = areas
      .where((area) => area >= 20.0)
      .toList();

  print(selectedAreas);
}
~~~

`where` **filtra** elementos que cumplen una condición. `toList()` materializa el resultado como lista. La función anónima `(area) => area >= 20.0` se ejecuta para cada elemento cuando se recorre el resultado.

**Ejercicio:** cambia el criterio a `area > 50.0`. Compara el resultado con el de un ciclo `for` y explica por qué `50.0` queda excluido.

### 3. Transformar valores con `map`

~~~dart
void main() {
  List<String> crops = [' coffee ', ' BEANS', 'Cocoa '];

  List<String> normalized = crops
      .map((name) => name.trim().toLowerCase())
      .toList();

  print(normalized);
  print(crops);
}
~~~

`map` **transforma** cada elemento. No debe confundirse con la colección `Map<K, V>`, que almacena pares clave–valor: aquí `map(...)` es un método de los iterables.

**Ejercicio:** produce una lista nueva con todos los nombres en mayúsculas y comprueba que la lista original no cambió.

### 4. Filtrar y transformar en una secuencia

~~~dart
void main() {
  List<String> names = ['Coffee', '', ' Beans ', 'Rice'];

  List<String> cleanedNames = names
      .map((name) => name.trim())
      .where((name) => name.isNotEmpty)
      .toList();

  print(cleanedNames);
}
~~~

Primero se eliminan espacios; luego se descartan cadenas vacías.

**Pregunta de análisis:** ¿qué ocurriría si aplicaras `where((name) => name.isNotEmpty)` **antes** de `trim()` a una cadena formada solo por espacios?

### 5. Resumir con `fold`

Primero resuelve con un acumulador:

~~~dart
void main() {
  List<double> areas = [125.0, 75.0, 50.0];
  double total = 0.0;

  for (final area in areas) {
    total += area;
  }

  print(total);
}
~~~

Después compara con:

~~~dart
void main() {
  List<double> areas = [125.0, 75.0, 50.0];

  double total = areas.fold<double>(
    0.0,
    (sum, area) => sum + area,
  );

  print(total);
}
~~~

`fold` empieza con un acumulador inicial (`0.0`) y combina cada elemento con el acumulado. A diferencia de otras estrategias, **una lista vacía produce el valor inicial**: en este caso `0.0`.

**Ejercicio:** calcula la suma de `[12.5, 7.5, 5.0]` mediante ambos métodos y confirma que coinciden.

### 6. Ordenar sin cambiar el original

~~~dart
void main() {
  List<String> original = ['Rice', 'Coffee', 'Beans'];

  List<String> sorted = List<String>.from(original);
  sorted.sort();

  print('Original: $original');
  print('Sorted: $sorted');
}
~~~

`sort()` cambia la lista sobre la que se invoca. Por eso creamos una copia para conservar el orden original.

### 7. Trabajar con claves de un `Map`

~~~dart
void main() {
  Map<String, double> cropAreas = {
    'Coffee': 125.0,
    'Beans': 15.0,
    'Rice': 80.0,
  };

  List<String> largeCrops = cropAreas.entries
      .where((entry) => entry.value >= 50.0)
      .map((entry) => entry.key)
      .toList();

  largeCrops.sort();
  print(largeCrops);
}
~~~

`entries` permite consultar juntos las claves y los valores. `where` filtra por área; `map` convierte cada entrada seleccionada en su nombre de cultivo. `sort()` ordena los nombres.

### 8. Comparar legibilidad antes de elegir

Si un `for` explícito se entiende mejor, úsalo. Las transformaciones encadenadas son útiles cuando expresan con claridad **filtrar → transformar → materializar**, pero no deben ocultar reglas de negocio ni cálculos complejos.

**Depuración — No es una lista todavía**

~~~dart
void main() {
  List<int> numbers = [1, 2, 3, 4];

  Iterable<int> evenNumbers = numbers.where((number) => number.isEven);

  // Observe the difference between an Iterable and a List.
  print(evenNumbers);
  print(evenNumbers.toList());
}
~~~

Este ejemplo **no contiene un error de compilación**. La pregunta es conceptual: ¿qué tipo devuelve `where`? ¿Por qué suele ser útil llamar a `toList()` al conservar un resultado para mostrarlo o modificarlo después?

### Reto — Informe filtrado

Partiendo de un mapa de cuatro cultivos y sus áreas, genera:

1. Una lista ordenada de nombres con área mayor o igual a `50.0`.
2. La suma de todas las áreas usando `fold` sobre `values`.
3. Un conjunto de nombres normalizados, utilizando `map` y `toSet`.
4. Una comparación del total obtenido mediante `fold` y mediante un ciclo.

### Comprobación

¿Qué diferencia hay entre `where` y `map`? ¿Qué produce `toList()`? ¿Por qué `sort()` puede alterar datos originales si no haces una copia? ¿Cuándo es preferible un ciclo explícito?

---

## Práctica 3.6 — Reto integrador: catálogo de observaciones agrícolas (80 min)

### El problema

El programa del Laboratorio 02 conserva únicamente el último resumen. Ahora construirás **AgroDiversa Catalog**, una aplicación de consola que guarda varias observaciones, cada una identificada por municipio y año, y permite consultar sus cultivos y estadísticas. Todo permanece **en memoria hasta cerrar la aplicación**.

### Requisitos de funcionamiento

1. Registrar una observación con municipio, año y entre uno y cinco cultivos.
2. Guardar varias observaciones sin sobrescribir las anteriores.
3. Rechazar un municipio y año ya registrados, ignorando espacios exteriores y diferencias de mayúsculas.
4. Rechazar nombres duplicados de cultivos **dentro de la misma observación** y volver a solicitar otro nombre.
5. Validar año, cantidad y superficies mediante las funciones de lectura del Laboratorio 02.
6. Listar las observaciones guardadas, ordenadas por su clave.
7. Buscar una observación por municipio y año, sin volver a solicitar sus áreas.
8. Mostrar por observación: cultivos, áreas, total, promedio, mayor superficie y participación del cultivo mayor.
9. Mostrar un catálogo ordenado de nombres de cultivos distintos entre **todas** las observaciones.
10. Informar cuando no hay registros, cuando una clave no existe y cuando termina la entrada.

Usarás los siguientes tipos:

~~~dart
Map<String, Map<String, double>> observations = <String, Map<String, double>>{};
~~~

El mapa externo relaciona una **clave de observación** con un mapa de cultivos. El mapa interno relaciona el **nombre del cultivo** con su superficie. Una observación se identificará, por ejemplo, mediante la clave normalizada `andes (2025)`.

> **Reglas del escenario:** los años de `2000` a `2100`, las superficies positivas y finitas y el máximo de cinco cultivos son límites **didácticos**, no requisitos de un conjunto de datos público. Ante un empate de superficies máximas, se conservará el **primer** cultivo ingresado. No deduzcas diagnósticos agrícolas a partir de estos cálculos.

### Ejemplo de menú

~~~text
==================================
        AGRODIVERSA CATALOG
==================================
1. Register observation
2. List observations
3. View observation details
4. Show unique crop names
0. Exit
Option:
~~~

### Etapa 1 — Diseñar funciones y datos (10 min)

Antes de programar, define qué responsabilidad tiene cada función:

| Función | Qué hace |
|---|---|
| `createObservationKey` | Normaliza municipio y año en una clave |
| `readRequiredText`, `readIntInRange`, `readPositiveArea` | Leen y validan entradas |
| `readUniqueCropName` | Rechaza nombres ya presentes en el mapa actual |
| `registerObservation` | Construye y guarda una observación completa |
| `listObservations` | Muestra las claves disponibles |
| `viewObservation` | Busca una observación y solicita su resumen |
| `calculateTotalArea` | Devuelve un total sin imprimir |
| `showObservationSummary` | Presenta los datos de una observación |
| `showUniqueCrops` | Deriva nombres únicos del catálogo |

**Preguntas de diseño:** ¿qué información debe sobrevivir a cada vuelta del menú? ¿Por qué el mapa local de la captura debe guardarse solo cuando está completo? ¿Por qué el total puede calcularse a partir de los datos guardados sin almacenarlo dos veces?

### Etapa 2 — Preparar archivo y reutilizar lectores (10 min)

Crea `bin/agricultural_catalog.dart`:

~~~dart
import 'dart:io';
~~~

Debajo del `import`, copia las **implementaciones completas** de estas tres funciones desde tu Laboratorio 02, práctica 2.5. No copies un segundo `main()`:

- `String? readRequiredText(String prompt)`
- `int? readIntInRange(String prompt, int minimum, int maximum)`
- `double? readPositiveArea(String prompt)`

Cada función debe devolver `null` cuando termine la entrada estándar y reintentar cuando el valor sea inválido.

Agrega la función de clave:

~~~dart
String createObservationKey(String municipality, int year) {
  String normalized = municipality.trim().toLowerCase();
  return '$normalized ($year)';
}
~~~

Comprueba temporalmente que `createObservationKey('Andes', 2025)` y `createObservationKey(' ANDES ', 2025)` producen **la misma cadena**. En la versión final el archivo debe tener un solo `main()`.

**Decisión consciente:** esta versión guarda las claves y los nombres de cultivos normalizados en minúsculas. Una versión orientada a objetos podrá conservar por separado las etiquetas originales para presentación.

### Etapa 3 — Menú persistente (10 min)

Agrega este esqueleto, que **no es una solución terminada**:

~~~dart
void main() {
  Map<String, Map<String, double>> observations =
      <String, Map<String, double>>{};

  while (true) {
    print('1. Register observation');
    print('2. List observations');
    print('3. View observation details');
    print('4. Show unique crop names');
    print('0. Exit');

    int? option = readIntInRange('Option: ', 0, 4);

    if (option == null || option == 0) {
      print('Goodbye!');
      return;
    }

    switch (option) {
      case 1:
        // TODO: Register an observation and handle end of input.
        print('Registration not implemented yet.');
      case 2:
        // TODO: List saved observations.
        print('Listing not implemented yet.');
      case 3:
        // TODO: Find an observation and handle end of input.
        print('Search not implemented yet.');
      case 4:
        // TODO: Show distinct crop names.
        print('Catalog not implemented yet.');
      default:
        print('Unknown option.');
    }
  }
}
~~~

Las variables `observations` deben estar **fuera del ciclo** para que sus datos no se pierdan al volver al menú. Sustituirás cada mensaje `not implemented yet` por una llamada a la función correspondiente.

### Etapa 4 — Registrar sin sobrescribir (20 min)

Primero, agrega antes de `main()` esta función para obtener un nombre **nuevo en la observación actual**:

~~~dart
String? readUniqueCropName(
  String prompt,
  Map<String, double> currentCrops,
) {
  while (true) {
    String? name = readRequiredText(prompt);

    if (name == null) {
      return null;
    }

    String normalized = name.trim().toLowerCase();

    if (!currentCrops.containsKey(normalized)) {
      return normalized;
    }

    print('Crop already registered in this observation.');
  }
}
~~~

Después crea `bool registerObservation(Map<String, Map<String, double>> observations)`. Su responsabilidad será leer y guardar un registro completo. Usa este plan:

1. Solicita `municipality` mediante `readRequiredText`.
2. Solicita `year` mediante `readIntInRange`, con límites `2000` y `2100`.
3. Si termina la entrada de cualquiera de los lectores, devuelve `false`.
4. Construye la clave con `createObservationKey`.
5. Si `observations.containsKey(key)` es verdadero, informa `'Observation already exists.'` y devuelve `true` **sin modificar ningún dato**.
6. Solicita `cropCount` entre `1` y `5`.
7. Crea un mapa local `Map<String, double> currentCrops = <String, double>{};`.
8. Utiliza `for` para leer `cropCount` pares de nombre y área. Si la entrada termina, devuelve `false`.
9. Guarda **solo al final** `observations[key] = Map<String, double>.from(currentCrops);`.
10. Muestra `'Observation saved in memory.'` y devuelve `true`.

Completa este esqueleto del ciclo **dentro de `registerObservation`**:

~~~dart
for (int index = 1; index <= cropCount; index++) {
  String? cropName = readUniqueCropName(
    'Crop $index name: ',
    currentCrops,
  );

  if (cropName == null) {
    return false;
  }

  double? area = readPositiveArea('Crop $index area (ha): ');

  if (area == null) {
    return false;
  }

  currentCrops[cropName] = area;
}
~~~

El código supone que ya declaraste `cropCount` como entero no nulo y `currentCrops` como mapa local tras validar las entradas.

**No modifiques el catálogo principal mientras la captura está incompleta.** Si termina la entrada, la función devuelve `false` y el menú termina sin guardar un mapa parcial.

Reemplaza el `case 1` por la llamada a `registerObservation(observations)` y termina `main()` si retorna `false`. Un registro duplicado debe devolver `true` para volver normalmente al menú.

### Etapa 5 — Listar, buscar y calcular (20 min)

Implementa el listado de claves:

~~~dart
void listObservations(
  Map<String, Map<String, double>> observations,
) {
  if (observations.isEmpty) {
    print('No observations registered.');
    return;
  }

  List<String> keys = observations.keys.toList();
  keys.sort();

  for (final key in keys) {
    print(key);
  }
}
~~~

Reemplaza el `case 2` por `listObservations(observations);`.

La función `bool viewObservation(Map<String, Map<String, double>> observations)` deberá:

1. Leer municipio y año (con los lectores validados).
2. Devolver `false` si termina la entrada.
3. Crear la clave usando `createObservationKey`.
4. Recuperar `Map<String, double>? crops = observations[key];`.
5. Si `crops == null`, mostrar `'Observation not found.'` y devolver `true`.
6. Si existe, llamar a `showObservationSummary(key, crops)` y devolver `true`.

Puedes aprovechar esta función ya completa para el total:

~~~dart
double calculateTotalArea(Map<String, double> crops) {
  return crops.values.fold<double>(
    0.0,
    (total, area) => total + area,
  );
}
~~~

Crea `void showObservationSummary(String key, Map<String, double> crops)`. Debe:

- Comprobar `crops.isEmpty` antes de dividir por la cantidad de cultivos.
- Mostrar la clave, seguida por los cultivos y sus superficies en orden alfabético.
- Calcular total con `calculateTotalArea(crops)`.
- Calcular promedio como total dividido entre `crops.length`.
- Recorrer `crops.entries` para identificar el mayor, actualizando únicamente si `entry.value > largestArea`.
- Calcular `largestArea / totalArea * 100` solo cuando `totalArea > 0`.
- Mostrar cifras mediante `toStringAsFixed(2)`.

Esqueleto de cálculo:

~~~dart
void showObservationSummary(
  String key,
  Map<String, double> crops,
) {
  if (crops.isEmpty) {
    print('No crops available.');
    return;
  }

  double totalArea = calculateTotalArea(crops);
  double averageArea = totalArea / crops.length;

  String largestCrop = '';
  double largestArea = 0.0;

  for (final entry in crops.entries) {
    if (entry.value > largestArea) {
      largestArea = entry.value;
      largestCrop = entry.key;
    }
  }

  double largestShare = largestArea / totalArea * 100;

  // TODO: Print key, sorted crops and formatted statistics.
}
~~~

El esqueleto asume la regla de entrada del ejercicio: **al menos un cultivo y solo áreas positivas y finitas**. Cuando se carguen archivos o datos externos, esas precondiciones deberán validarse nuevamente.

Conecta `viewObservation(observations)` al `case 3`, terminando `main()` si devuelve `false`.

### Etapa 6 — Mostrar cultivos únicos y comprobar (10 min)

Agrega esta función:

~~~dart
void showUniqueCrops(
  Map<String, Map<String, double>> observations,
) {
  Set<String> uniqueCrops = <String>{};

  for (final crops in observations.values) {
    uniqueCrops.addAll(crops.keys);
  }

  if (uniqueCrops.isEmpty) {
    print('No crops available.');
    return;
  }

  List<String> sortedNames = uniqueCrops.toList();
  sortedNames.sort();

  print('Unique crop names: ' + sortedNames.length.toString());

  for (final name in sortedNames) {
    print(name);
  }
}
~~~

Reemplaza el `case 4` por `showUniqueCrops(observations);`. Este conjunto se calcula **sin eliminar entradas ni modificar los mapas originales**.

### Pruebas manuales obligatorias

| Caso | Acciones | Resultado esperado |
|---|---|---|
| A — Vacío | Listar, buscar y consultar cultivos sin registrar | No falla; muestra mensajes informativos |
| B — Primera observación | Andes, 2025: coffee 125, plantain 75, avocado 50 | Total 250.00; promedio 83.33; máximo coffee 125.00; participación 50.00% |
| C — Segunda observación | Andes, 2024: coffee 110, beans 40 | Se conservan las dos observaciones; nueva suma 150.00 |
| D — Tercera observación | La Mesa, 2025: cocoa 20, plantain 30 | La tercera clave existe y se consulta por separado |
| E — Clave duplicada | Registrar ` ANDES `, 2025 después de B | No sustituye la primera observación |
| F — Cultivo duplicado | En una captura ingresar `Coffee` y después ` coffee ` | Repite la solicitud del nombre; no sobrescribe la primera área |
| G — Nombres únicos | Después de B, C y D utilizar opción 4 | Cinco nombres: avocado, beans, cocoa, coffee, plantain |
| H — Un cultivo | Una observación con área 12.5 | Total y promedio 12.50; participación 100.00% |
| I — Empate | rice 20, cocoa 20, beans 10 | Conserva rice como máximo; total 50.00; participación 40.00% |
| J — Entradas inválidas | Año `abc`; cantidad `0`; áreas `NaN`, `-2` y luego 12.5 | Reintenta y solo guarda valores válidos |
| K — No existe | Buscar municipio y año no registrados | Avisa que no existe y vuelve al menú |
| L — Fin de entrada | Terminar entrada durante una captura | Sale sin ciclo infinito ni guardar una observación parcial |

**Comprueba tres magnitudes diferentes:** en las observaciones B, C y D hay **3 observaciones**, **7 registros individuales de cultivo** (3 + 2 + 2) y **5 nombres únicos**.

### Verificación del código

Desde la raíz del proyecto, con errores intencionales corregidos:

~~~bash
dart format bin
dart analyze
dart run bin/agricultural_catalog.dart
~~~

El analizador busca problemas estáticos, pero no garantiza que tus resultados matemáticos sean correctos. Por ello son obligatorias las comprobaciones numéricas y de comportamiento.

### Laboratorio de errores — Corrige uno por uno

Trabaja en una copia temporal y restaura la versión válida tras cada experimento:

1. **Datos que desaparecen:** crea `observations` dentro de `while`. ¿Por qué se reinicia el catálogo con cada vuelta?
2. **Sobrescritura:** omite `containsKey` al registrar y guarda la misma clave por segunda vez.
3. **Nombre repetido:** elimina la comprobación de nombre de cultivo duplicado.
4. **Empate incorrecto:** actualiza el máximo con `>=` en lugar de `>`.
5. **Resultado desactualizado:** guarda un total calculado y cambia después las áreas sin recalcularlo.
6. **Modificación compartida:** modifica un mapa interior al que apuntan dos referencias y observa que el cambio afecta a ambas.

### Ampliación opcional — Fuera de las 4,5 horas

Incorpora una opción para comparar cultivos comunes y distintos entre dos observaciones con `Set.intersection` y `Set.difference`, o muestra solo los cultivos que superen un umbral introducido por el usuario.

No avances todavía a clases, persistencia o APIs: esos temas tendrán laboratorios dedicados.
