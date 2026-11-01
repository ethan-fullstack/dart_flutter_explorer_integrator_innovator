# Laboratorio 05 — POO avanzada, manejo de datos, JSON y pruebas en Dart

En el [Laboratorio 03](laboratorio-03.md) construiste un catálogo de observaciones agrícolas con `List`, `Set` y `Map`. Después, en el [Laboratorio 04](laboratorio-04.md), transformaste ese catálogo utilizando clases, objetos, constructores, encapsulamiento y composición de objetos.

En este laboratorio aprenderás a **extender el diseño mediante interfaces, herencia y composición**, detectar datos inválidos con excepciones, organizar el código en módulos, convertir modelos tipados a JSON y probar el comportamiento automáticamente.

> **Continuidad:** este laboratorio asume los fundamentos de POO desarrollados en el [Laboratorio 04](laboratorio-04.md). Incluye un recordatorio breve de clases, pero no reemplaza las prácticas de modelado y colaboración entre objetos del laboratorio anterior.

> **Alcance:** los datos agrícolas son **ficticios y didácticos**. El laboratorio no consulta fuentes oficiales, no produce recomendaciones agronómicas y no utiliza HTTP ni asincronía; estos últimos temas corresponden al Laboratorio 06.

## Ruta del laboratorio

| Práctica | Tema | Tiempo efectivo |
|---|---|---:|
| 5.1 | Herencia, interfaces, polimorfismo y composición | 45 min |
| 5.2 | Null safety, validaciones y excepciones | 40 min |
| 5.3 | Módulos y responsabilidades separadas | 35 min |
| 5.4 | JSON, modelos tipados y archivos locales | 45 min |
| 5.5 | Pruebas unitarias y casos límite | 40 min |
| 5.6 | Reto integrador: procesador agrícola con JSON | 65 min |
| **Total** | **Trabajo práctico** | **270 min (4,5 horas)** |

La duración incluye lectura activa, ejecución, modificaciones, retos, depuración y comprobaciones, no la instalación del SDK ni la descarga de dependencias.

### Objetivos

Al finalizar podrás:

- Distinguir `extends`, `implements` y composición.
- Trabajar con `abstract class` y `abstract interface class` en Dart 3.
- Aplicar polimorfismo para intercambiar estrategias de presentación.
- Comprobar valores ausentes y validar invariantes en constructores.
- Recuperar excepciones esperadas sin ocultar fallos de programación.
- Separar modelos, presentación y acceso a datos.
- Decodificar y codificar JSON desde objetos tipados.
- Leer y escribir archivos locales sin sobrescribir un origen inválido.
- Construir pruebas con `package:test` para casos normales y fallos.
- Explicar las limitaciones de una implementación de consola y justificar su evolución hacia Flutter.

## Preparación del proyecto

Conserva los laboratorios anteriores. Crea otro proyecto de consola con Dart 3 estable:

~~~bash
dart create -t console dart_lab_05
cd dart_lab_05
dart --version
dart run
~~~

Los archivos se incorporarán gradualmente:

~~~text
dart_lab_05/
├── bin/
│   ├── practice_51.dart
│   ├── practice_52.dart
│   └── agrodiversa_cli.dart
├── lib/
│   ├── agrodiversa.dart
│   └── src/
│       ├── model/
│       ├── services/
│       └── storage/
├── data/
├── test/
└── pubspec.yaml
~~~

Ejecuta un ejemplo desde la raíz del proyecto:

~~~bash
dart run bin/practice_51.dart
~~~

Todos los identificadores, mensajes, comentarios dentro del código y nombres de archivos están en **inglés**; las explicaciones están en español. En cada práctica sigue la secuencia **predice → ejecuta → modifica → comprueba**. Corrige cada error intencional antes de proseguir.

---

## Práctica 5.1 — Herencia, interfaces, polimorfismo y composición (45 min)

### 1. Recordatorio: clases y constructores

Crea `bin/practice_51.dart`:

~~~dart
class CropArea {
  final String name;
  final double plantedArea;

  CropArea({required this.name, required this.plantedArea});

  String describe() {
    return '$name: $plantedArea ha';
  }
}

void main() {
  CropArea coffee = CropArea(name: 'Coffee', plantedArea: 125.0);
  CropArea beans = CropArea(name: 'Beans', plantedArea: 40.0);

  print(coffee.describe());
  print(beans.describe());
}
~~~

La clase define el estado y el comportamiento de los objetos. El constructor recibe los datos; `final` evita reasignar los campos después de construir el objeto.

**Ejercicio:** agrega un objeto `Cocoa` y muestra su descripción. Después cambia un nombre de parámetro intencionalmente, observa el mensaje del analizador y corrígelo.

### 2. Heredar una implementación

~~~dart
abstract class Report {
  String get title;

  String describe() {
    return 'Report: $title';
  }
}

class MunicipalReport extends Report {
  @override
  final String title;

  MunicipalReport(this.title);
}

void main() {
  Report report = MunicipalReport('Andes 2025');
  print(report.describe());
}
~~~

- `abstract class` no puede instanciarse directamente.
- `MunicipalReport extends Report` hereda comportamiento.
- `@override` identifica un miembro redefinido o implementado.
- Una variable del tipo base puede referirse a una instancia de la clase hija.

**Predice** la salida. **Ejercicio:** crea `DepartmentReport` y muestra sus datos mediante una variable de tipo `Report`.

### 3. Sobrescritura y polimorfismo

~~~dart
abstract class Report {
  String describe();
}

class CompactReport extends Report {
  @override
  String describe() => 'Compact report';
}

class DetailedReport extends Report {
  @override
  String describe() => 'Detailed report';
}

void showDescription(Report report) {
  print(report.describe());
}

void main() {
  showDescription(CompactReport());
  showDescription(DetailedReport());
}
~~~

La función `showDescription` utiliza el contrato común, pero el resultado depende de la implementación que recibe. No necesita comprobar el tipo concreto con `if`.

**Ejercicio:** crea una tercera implementación y verifica que `showDescription` sigue funcionando sin cambios.

### 4. Interfaces en Dart 3

~~~dart
abstract interface class ReportFormatter {
  String format(String title, double area);
}

class CompactFormatter implements ReportFormatter {
  @override
  String format(String title, double area) {
    String value = area.toStringAsFixed(2);
    return '$title: $value ha';
  }
}

class VerboseFormatter implements ReportFormatter {
  @override
  String format(String title, double area) {
    String value = area.toStringAsFixed(2);
    return 'Observation $title reports $value hectares.';
  }
}

void main() {
  ReportFormatter formatter = CompactFormatter();
  print(formatter.format('Andes 2025', 125.0));

  formatter = VerboseFormatter();
  print(formatter.format('Andes 2025', 125.0));
}
~~~

`implements` obliga a cumplir los miembros de la interfaz. No hereda las implementaciones de sus métodos. La declaración `abstract interface class` indica un contrato que otras bibliotecas pueden **implementar**, pero no extender.

**Ejercicio:** elimina temporalmente `format` de una implementación. ¿Qué problema señala Dart? Restaura el método.

### 5. Composición e inyección por constructor

~~~dart
abstract interface class ReportFormatter {
  String format(String title, double area);
}

class CompactFormatter implements ReportFormatter {
  @override
  String format(String title, double area) {
    return '$title: $area ha';
  }
}

class ReportPrinter {
  final ReportFormatter formatter;

  ReportPrinter(this.formatter);

  void printReport(String title, double area) {
    print(formatter.format(title, area));
  }
}

void main() {
  ReportPrinter printer = ReportPrinter(CompactFormatter());
  printer.printReport('Andes 2025', 125.0);
}
~~~

`ReportPrinter` **tiene una dependencia** de tipo `ReportFormatter`. Esa relación es composición, no herencia. Al recibir la dependencia por el constructor, el consumidor puede utilizar otros formatos sin modificar su código.

**Reto:** incorpora `VerboseFormatter` al programa y crea dos `ReportPrinter` con las diferentes implementaciones.

### 6. ¿Por qué no heredar por cada cultivo?

Un objeto que contiene un cultivo y su área no necesita clases separadas `CoffeeArea`, `BeansArea` y `CocoaArea` si la diferencia es solo un dato. En general, una observación **contiene varios `CropArea`**; no **es un tipo de cultivo**.

Elige herencia para una especialización coherente y composición para colaboración o contención. Evita jerarquías creadas solo para reutilizar una línea de código.

### Depuración intencional

Prueba por separado:

1. Instanciar `ReportFormatter()` y explicar por qué no es posible.
2. Eliminar `format` de `CompactFormatter` y leer el error.
3. Cambiar el nombre del método implementado a `formatted`. ¿Por qué no satisface el contrato?

### Comprobación

¿Qué distingue `extends` de `implements`? ¿Qué es el polimorfismo? ¿Por qué un consumidor debe recibir una dependencia en vez de crear necesariamente una implementación concreta?

---

## Práctica 5.2 — Null safety, invariantes y excepciones (40 min)

### 1. Dato ausente y dato inválido

Crea `bin/practice_52.dart`:

~~~dart
void main() {
  String? note;
  String? reviewedNote = 'Verified manually';

  print(note ?? 'No note available');
  print(reviewedNote ?? 'No note available');
}
~~~

`String?` puede contener una cadena o `null`. `??` proporciona un valor predeterminado si el dato es nulo. La ausencia no significa necesariamente que el dato presente sea válido.

**Ejercicio:** asigna `'Andes'` a un `String? municipality` y muéstralo. Luego asígnale `null` y utiliza una etiqueta predeterminada.

### 2. Comprobación y promoción de tipos

~~~dart
void showMunicipality(String? municipality) {
  if (municipality == null) {
    print('Municipality is missing.');
    return;
  }

  print(municipality.trim().toLowerCase());
}

void main() {
  showMunicipality(null);
  showMunicipality(' Andes ');
}
~~~

Tras comprobar el valor nulo y salir de esa rama, Dart puede tratar `municipality` como un `String` en el resto de la función. Prefiere una comprobación explícita a forzar el valor mediante `!` cuando su ausencia es posible.

### 3. Conversión y validación no son equivalentes

~~~dart
void main() {
  double? area = double.tryParse('NaN');

  if (area == null || !area.isFinite || area <= 0) {
    print('Enter a positive finite area.');
  } else {
    print('Accepted area: $area');
  }
}
~~~

`tryParse` puede convertir textos como `NaN` o `Infinity`. Por eso debes comprobar también la regla de negocio y `isFinite`.

**Ejercicio:** prueba `'abc'`, `'-3'`, `'0'`, `'Infinity'` y `'12.5'`.

### 4. Validar dentro del modelo

~~~dart
class CropArea {
  final String name;
  final double plantedArea;

  CropArea({required String name, required this.plantedArea})
      : name = name.trim() {
    if (this.name.isEmpty) {
      throw FormatException('Crop name must not be empty.');
    }

    if (!plantedArea.isFinite || plantedArea <= 0) {
      throw FormatException('Planted area must be positive and finite.');
    }
  }
}

void main() {
  CropArea crop = CropArea(name: ' Coffee ', plantedArea: 125.0);
  print(crop.name);
}
~~~

El constructor garantiza que no se pueda obtener un `CropArea` con un nombre vacío o superficie no positiva/no finita. Es una **invariante**: una condición que todos los objetos válidos de ese tipo deben satisfacer.

**Ejercicio:** prueba por separado nombre vacío, espacios, área cero, negativa y `double.nan`. Observa y explica el error.

### 5. Capturar la excepción prevista

~~~dart
class CropArea {
  final String name;
  final double plantedArea;

  CropArea({required String name, required this.plantedArea})
      : name = name.trim() {
    if (this.name.isEmpty) {
      throw FormatException('Crop name must not be empty.');
    }
    if (!plantedArea.isFinite || plantedArea <= 0) {
      throw FormatException('Planted area must be positive and finite.');
    }
  }
}

void main() {
  try {
    CropArea crop = CropArea(name: '', plantedArea: 12.5);
    print(crop.name);
  } on FormatException catch (error) {
    print('Invalid crop: ' + error.message);
  }
}
~~~

`on FormatException catch` recupera **esa** excepción prevista y deja que otras fallas se manifiesten. No utilices un `catch` vacío para ocultar errores.

### 6. `finally` y `rethrow`

~~~dart
void parseYear(String text) {
  try {
    print(int.parse(text));
  } on FormatException {
    print('Invalid year format.');
  } finally {
    print('Parsing attempt finished.');
  }
}

void main() {
  parseYear('2025');
  parseYear('invalid');
}
~~~

`finally` se ejecuta al terminar el `try` y los manejadores aplicables, haya habido excepción o no. Resulta útil para liberar recursos; aquí solo permite observar el flujo.

Para propagar una excepción sin perder su traza original:

~~~dart
void validateArea(double area) {
  if (!area.isFinite || area <= 0) {
    throw FormatException('Invalid area.');
  }
}

void processArea(double area) {
  try {
    validateArea(area);
  } on FormatException {
    print('Validation failed.');
    rethrow;
  }
}

void main() {
  try {
    processArea(-1.0);
  } on FormatException {
    print('Caller handled the error.');
  }
}
~~~

`rethrow` se utiliza dentro de un manejador para dejar que la excepción continúe hacia quien puede manejarla.

### Reto y depuración

Construye una función que intente crear cinco `CropArea` con valores distintos, incluyendo casos inválidos. Recupera únicamente `FormatException` y registra un mensaje comprensible por intento.

Después analiza esta práctica incorrecta:

~~~dart
void main() {
  try {
    int year = int.parse('invalid');
    print(year);
  } catch (_) {
    // Incorrect: the failure is silently ignored.
  }

  print('Operation completed.');
}
~~~

Cámbiala para que indique explícitamente cuál fue el error esperado y no lo oculte.

### Comprobación

¿Cómo se distingue un valor `null` de un valor de tipo incorrecto? ¿Por qué una validación debe vivir dentro del modelo y no únicamente en la interfaz? ¿Qué diferencia hay entre `tryParse` y lanzar `FormatException`?

---

## Práctica 5.3 — Módulos, imports y separación de responsabilidades (35 min)

### 1. Una responsabilidad por módulo

Un programa que mezcla lectura de archivos, validación, cálculo y presentación es difícil de modificar y probar. Para evolucionar el catálogo usarás esta organización:

~~~text
dart_lab_05/
├── bin/
│   ├── practice_51.dart
│   ├── practice_52.dart
│   └── agrodiversa_cli.dart
├── lib/
│   ├── agrodiversa.dart
│   └── src/
│       ├── model/
│       │   ├── crop_area.dart
│       │   └── agricultural_record.dart
│       ├── services/
│       │   └── report_formatter.dart
│       └── storage/
│           └── record_json_codec.dart
├── data/
│   └── observations.json
├── test/
└── pubspec.yaml
~~~

Los archivos de modelo y codec adicionales se construirán en la práctica siguiente; no crees archivos vacíos para aparentar módulos terminados.

### 2. Modelo reutilizable en `lib/`

Crea `lib/src/model/crop_area.dart` con la versión validada de `CropArea` de la práctica 5.2:

~~~dart
class CropArea {
  final String name;
  final double plantedArea;

  CropArea({required String name, required this.plantedArea})
      : name = name.trim() {
    if (this.name.isEmpty) {
      throw FormatException('Crop name must not be empty.');
    }

    if (!plantedArea.isFinite || plantedArea <= 0) {
      throw FormatException('Planted area must be positive and finite.');
    }
  }
}
~~~

Las clases de ejemplo en `bin/practice_52.dart` pueden conservarse en ese archivo independiente, pero no debes **copiar otra clase de producción con el mismo propósito** dentro de `lib/`.

### 3. Contrato y estrategias de presentación

Crea `lib/src/services/report_formatter.dart`:

~~~dart
abstract interface class ReportFormatter {
  String format(String title, double area);
}

class CompactFormatter implements ReportFormatter {
  @override
  String format(String title, double area) {
    String value = area.toStringAsFixed(2);
    return '$title: $value ha';
  }
}

class DetailedFormatter implements ReportFormatter {
  @override
  String format(String title, double area) {
    String value = area.toStringAsFixed(2);
    return 'Observation $title reports $value hectares.';
  }
}
~~~

Los formateadores **devuelven cadenas**. No abren archivos ni leen la terminal, lo que permite probarlos con datos independientes del entorno.

### 4. Un archivo público de exportaciones

Crea `lib/agrodiversa.dart`:

~~~dart
export 'src/model/crop_area.dart';
export 'src/services/report_formatter.dart';
~~~

Agrega nuevas exportaciones cuando construyas otros módulos. Un programa externo al directorio `lib/` debe preferir este punto de entrada a depender directamente de rutas internas que podrían cambiar.

### 5. Importar correctamente desde `bin/`

Crea `bin/agrodiversa_cli.dart`:

~~~dart
import 'package:dart_lab_05/agrodiversa.dart';

void main() {
  CropArea crop = CropArea(name: 'Coffee', plantedArea: 125.0);

  ReportFormatter formatter = CompactFormatter();
  print(formatter.format(crop.name, crop.plantedArea));
}
~~~

`dart_lab_05` es el nombre de paquete declarado en `pubspec.yaml`. Si creaste el proyecto con otro nombre, utiliza ese valor en todas las importaciones `package:`.

Ejecuta:

~~~bash
dart pub get
dart run bin/agrodiversa_cli.dart
~~~

Luego cambia `CompactFormatter` por `DetailedFormatter` y observa cómo se modifica el formato sin cambiar el modelo.

### 6. Inyección de dependencia sin sobreingeniería

~~~dart
import 'package:dart_lab_05/agrodiversa.dart';

class CropPresenter {
  final ReportFormatter formatter;

  CropPresenter(this.formatter);

  String present(CropArea crop) {
    return formatter.format(crop.name, crop.plantedArea);
  }
}

void main() {
  CropPresenter presenter = CropPresenter(DetailedFormatter());
  CropArea crop = CropArea(name: 'Beans', plantedArea: 40.0);

  print(presenter.present(crop));
}
~~~

El consumidor recibe una dependencia por constructor: **no está obligado a crear siempre un formato específico**. Esta es una aplicación pequeña de composición y del principio de inversión de dependencias. No agregues la clase `CropPresenter` al producto final si no ofrece un comportamiento que realmente se necesita.

### 7. Dónde debe vivir cada operación

| Capa | Sí debe hacer | No debería hacer |
|---|---|---|
| `model/` | Validar objetos y representar datos | Preguntar por teclado |
| `services/` | Transformar datos o dar formato | Leer rutas de disco |
| `storage/` | Convertir JSON y gestionar persistencia | Imprimir menús |
| `bin/` | Coordinar el programa y comunicar resultados | Duplicar las reglas de los modelos |
| `test/` | Comprobar contratos y errores | Pedir entradas manuales |

**Ejercicio:** indica la carpeta apropiada para calcular una suma, leer un JSON, mostrar un menú y comprobar un constructor. Justifica tu decisión.

### Reto y depuración

Añade `MinimalFormatter`, que devuelva únicamente el título. Verifica que una clase que consume `ReportFormatter` pueda utilizar las tres implementaciones sin modificar su lógica.

Cambia temporalmente la importación a un nombre de paquete inexistente y ejecuta `dart analyze`. Observa el error, corrige el nombre y ejecuta nuevamente.

### Comprobación

¿Por qué `lib/` no es lo mismo que `bin/`? ¿Cómo ayuda `lib/agrodiversa.dart` a exponer una API sencilla? ¿Por qué una dependencia por constructor facilita las pruebas?

---

## Práctica 5.4 — JSON, modelos tipados y archivos locales (45 min)

### Objetivos

Comprender la diferencia entre texto JSON, colecciones decodificadas y objetos de dominio; validar la estructura de los datos antes de utilizarlos; y guardar una copia exportada sin modificar el archivo de entrada.

### 1. JSON no es un objeto de Dart

Crea `data/observations.json` con este contenido **ficticio**:

~~~json
[
  {
    "municipality": "Andes",
    "year": 2025,
    "crops": [
      {"name": "Coffee", "plantedArea": 125.0},
      {"name": "Plantain", "plantedArea": 75.0},
      {"name": "Avocado", "plantedArea": 50.0}
    ]
  },
  {
    "municipality": "La Mesa",
    "year": 2024,
    "crops": [
      {"name": "Cocoa", "plantedArea": 20.0},
      {"name": "Beans", "plantedArea": 30.0}
    ]
  }
]
~~~

Aquí, `[]` representa una lista, `{}` representa un objeto JSON y cada par de nombre y valor representa una propiedad. Las superficies están en hectáreas **solo por convención del ejercicio**. El JSON es texto que **no conoce** las clases `CropArea` o `AgriculturalRecord`.

### 2. Primer experimento con `jsonDecode`

Crea `bin/json_experiment.dart`:

~~~dart
import 'dart:convert';

void main() {
  const source = '{"name":"Coffee","plantedArea":125.0}';

  Object? decoded = jsonDecode(source);

  if (decoded is! Map<String, dynamic>) {
    print('Expected a JSON object.');
    return;
  }

  print(decoded['name']);
  print(decoded['plantedArea']);
}
~~~

`dart:convert` proporciona `jsonDecode` y `jsonEncode`. La conversión interpreta un objeto JSON como un mapa y una matriz JSON como una lista. No devuelve automáticamente instancias de tus clases.

**Antes de ejecutar:** predice los dos valores. Luego cambia `source` a `'not json'` y observa la excepción. Recupera después el texto válido.

### 3. Un modelo de observación con reglas propias

Crea `lib/src/model/agricultural_record.dart`:

~~~dart
import 'crop_area.dart';

class AgriculturalRecord {
  final String municipality;
  final int year;
  final List<CropArea> crops;

  AgriculturalRecord({
    required String municipality,
    required this.year,
    required List<CropArea> crops,
  })  : municipality = municipality.trim(),
        crops = List<CropArea>.unmodifiable(crops) {
    if (this.municipality.isEmpty) {
      throw FormatException('Municipality must not be empty.');
    }

    if (year < 2000 || year > 2100) {
      throw FormatException('Year must be between 2000 and 2100.');
    }

    if (this.crops.isEmpty) {
      throw FormatException('At least one crop is required.');
    }

    Set<String> uniqueNames = <String>{};

    for (final crop in this.crops) {
      String normalizedName = crop.name.toLowerCase();

      if (!uniqueNames.add(normalizedName)) {
        throw FormatException('Duplicate crop name: ' + crop.name);
      }
    }

    if (!totalArea.isFinite) {
      throw FormatException('Total planted area is not finite.');
    }
  }

  double get totalArea {
    return crops.fold<double>(
      0.0,
      (total, crop) => total + crop.plantedArea,
    );
  }

  double get averageArea => totalArea / crops.length;

  CropArea get largestCrop {
    CropArea largest = crops.first;

    for (final crop in crops.skip(1)) {
      if (crop.plantedArea > largest.plantedArea) {
        largest = crop;
      }
    }

    return largest;
  }
}
~~~

El constructor comprueba las reglas **del escenario didáctico**. Usa `List<CropArea>.unmodifiable` para que el código exterior no pueda agregar o quitar cultivos de una observación ya construida, ni alterar directamente la lista recibida. Esto evita que una modificación externa invalide las reglas del modelo.

**Detalle matemático:** los valores individuales pueden ser finitos y, aun así, una suma extremadamente grande podría desbordarse. Por eso se comprueba también `totalArea.isFinite`.

**Ejercicio:** crea una observación válida con tres cultivos, muestra `totalArea`, `averageArea` y `largestCrop.name`. Después intenta construir una observación vacía, otra con nombres duplicados sin distinguir mayúsculas y una con año `1999`. Explica cada excepción.

### 4. Convertir JSON a objetos sin suponer los tipos

Crea `lib/src/storage/record_json_codec.dart`. La clase `RecordJsonCodec` se ocupará solo de la conversión, sin leer archivos ni imprimir menús:

~~~dart
import 'dart:convert';

import '../model/agricultural_record.dart';
import '../model/crop_area.dart';

class RecordJsonCodec {
  List<AgriculturalRecord> decodeRecords(String source) {
    Object? root = jsonDecode(source);

    if (root is! List<dynamic>) {
      throw FormatException('Expected a JSON array of observations.');
    }

    List<AgriculturalRecord> records = <AgriculturalRecord>[];
    Set<String> uniqueKeys = <String>{};

    for (final rawRecord in root) {
      if (rawRecord is! Map<String, dynamic>) {
        throw FormatException('Every observation must be an object.');
      }

      Object? municipality = rawRecord['municipality'];
      Object? year = rawRecord['year'];
      Object? rawCrops = rawRecord['crops'];

      if (municipality is! String ||
          year is! int ||
          rawCrops is! List<dynamic>) {
        throw FormatException('Invalid observation fields.');
      }

      List<CropArea> crops = <CropArea>[];

      for (final rawCrop in rawCrops) {
        if (rawCrop is! Map<String, dynamic>) {
          throw FormatException('Every crop must be an object.');
        }

        Object? name = rawCrop['name'];
        Object? plantedArea = rawCrop['plantedArea'];

        if (name is! String || plantedArea is! num) {
          throw FormatException('Invalid crop fields.');
        }

        crops.add(
          CropArea(
            name: name,
            plantedArea: plantedArea.toDouble(),
          ),
        );
      }

      AgriculturalRecord record = AgriculturalRecord(
        municipality: municipality,
        year: year,
        crops: crops,
      );

      String key = record.municipality.toLowerCase() +
          ' (' +
          record.year.toString() +
          ')';

      if (!uniqueKeys.add(key)) {
        throw FormatException('Duplicate municipality and year: ' + key);
      }

      records.add(record);
    }

    return records;
  }

  String encodeRecords(List<AgriculturalRecord> records) {
    List<Map<String, Object?>> data = records.map((record) {
      return <String, Object?>{
        'municipality': record.municipality,
        'year': record.year,
        'crops': record.crops.map((crop) {
          return <String, Object?>{
            'name': crop.name,
            'plantedArea': crop.plantedArea,
          };
        }).toList(),
      };
    }).toList();

    return const JsonEncoder.withIndent('  ').convert(data);
  }
}
~~~

Observa esta secuencia de responsabilidades:

- `jsonDecode`: convierte **texto JSON** en colecciones Dart.
- Validaciones de `RecordJsonCodec`: comprueban la **estructura** y tipos esperados.
- Constructores: garantizan las **invariantes** de cada objeto.
- `jsonEncode` / `JsonEncoder`: transforman valores compatibles con JSON en **texto JSON**.

**Atención:** este codec valida un formato diseñado para el laboratorio, no el esquema de una API de datos abiertos. Al integrar una fuente real habrá que investigar y documentar sus campos, unidades, nulabilidad y calidad antes de reutilizarlo.

### 5. Importar los nuevos módulos

Actualiza `lib/agrodiversa.dart` para que exponga las cuatro piezas. Su contenido completo será:

~~~dart
export 'src/model/crop_area.dart';
export 'src/model/agricultural_record.dart';
export 'src/services/report_formatter.dart';
export 'src/storage/record_json_codec.dart';
~~~

No elimines los archivos de producción creados en las prácticas anteriores.

### 6. Leer un archivo sin mezclarlo con el codec

Crea `bin/json_file_experiment.dart`:

~~~dart
import 'dart:io';

import 'package:dart_lab_05/agrodiversa.dart';

void main() {
  File inputFile = File('data/observations.json');
  RecordJsonCodec codec = RecordJsonCodec();

  try {
    String source = inputFile.readAsStringSync();
    List<AgriculturalRecord> records = codec.decodeRecords(source);

    print('Observations: ' + records.length.toString());

    for (final record in records) {
      print(record.municipality + ': ' + record.totalArea.toString());
    }
  } on FileSystemException catch (error) {
    print('File error: ' + error.message);
  } on FormatException catch (error) {
    print('Invalid data: ' + error.message);
  }
}
~~~

Desde la raíz del proyecto ejecuta:

~~~bash
dart run bin/json_file_experiment.dart
~~~

**Predice:** ¿cuántas observaciones y qué totales aparecerán? ¿Qué pasará si cambias la ruta a un archivo inexistente?

El programa captura **`FileSystemException`** para problemas de archivos y **`FormatException`** para datos inválidos. No atrapa `RangeError`, `TypeError` ni errores de programación en un bloque genérico para ocultarlos.

### 7. Exportar a otro archivo, nunca al origen

Extiende el cuerpo válido del `try` anterior con:

~~~dart
String normalizedJson = codec.encodeRecords(records);

File outputFile = File('data/normalized_observations.json');
outputFile.writeAsStringSync(normalizedJson);

print('Normalized file written: ' + outputFile.path);
~~~

Los archivos se usan de modo **síncrono**, aceptable para una pequeña herramienta didáctica de consola con datos locales. La API de `File` también permite lectura y escritura **asíncronas**; aprenderás a esperar esas operaciones en el Laboratorio 06.

**Precaución:** el programa escribe siempre `normalized_observations.json`, no el archivo de entrada. Aunque la codificación se haga correctamente, sobrescribir el archivo de origen sin una copia sería un riesgo innecesario. La escritura hacia el archivo de salida reemplaza su contenido si ya existe; usa una ruta dedicada al resultado.

### 8. ¿Qué ocurre ante JSON defectuoso?

Crea una **copia temporal** del archivo de entrada para probar cada falla:

- Reemplaza el `year` entero por texto: `"2025"`.
- Sustituye el área por `"unknown"`.
- Elimina la propiedad `crops` de una observación.
- Repite el nombre de un cultivo dentro de la misma observación.
- Agrega dos observaciones con mismo municipio y año, con diferentes mayúsculas.
- Quita un corchete del documento, produciendo JSON mal formado.

Para cada caso determina **qué componente** detecta el problema: decodificador JSON, validación de estructura o constructor del modelo.

### Reto breve

Implementa un pequeño programa que lea el archivo ficticio, muestre municipio, año, número de cultivos, total y cultivo con mayor área para cada observación, y genere una copia JSON normalizada. Comprueba que los resultados numéricos no estén escritos manualmente.

### Comprobación

¿Por qué `jsonDecode` no devuelve directamente `AgriculturalRecord`? ¿Qué representa `Map<String, dynamic>`? ¿Por qué las reglas se comprueban también en los constructores? ¿En qué se diferencian el archivo de entrada y el de salida?

---

## Práctica 5.5 — Pruebas automatizadas y casos límite (40 min)

### Objetivos

Comprobar reglas sin depender de la terminal ni del sistema de archivos y entender qué detecta una prueba que el analizador no puede detectar.

### 1. Preparar `package:test`

Desde la raíz del proyecto ejecuta:

~~~bash
dart pub add --dev test
dart pub get
~~~

Esto registra `test` como **dependencia de desarrollo** en `pubspec.yaml`. No fijaremos manualmente una versión en la guía: la herramienta resolverá una versión compatible con tu SDK y registrará las versiones elegidas en los archivos del proyecto.

Comprueba que exista la carpeta `test/` o créala. Si la plantilla genera una prueba de ejemplo, revísala antes de decidir si conservarla; no necesitas borrar pruebas válidas para añadir las nuevas.

### 2. Anatomía de una prueba

Crea `test/crop_area_test.dart`:

~~~dart
import 'package:dart_lab_05/agrodiversa.dart';
import 'package:test/test.dart';

void main() {
  group('CropArea', () {
    test('accepts a positive finite area and a non-empty name', () {
      CropArea crop = CropArea(
        name: ' Coffee ',
        plantedArea: 125.0,
      );

      expect(crop.name, equals('Coffee'));
      expect(crop.plantedArea, equals(125.0));
    });

    test('rejects an empty crop name', () {
      expect(
        () => CropArea(name: '   ', plantedArea: 10.0),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
~~~

- `group` agrupa casos relacionados.
- `test` declara un comportamiento verificable.
- `expect` contrasta el resultado real con una expectativa.
- `throwsA(isA<FormatException>())` indica que **debe lanzarse** esa excepción.

La función entregada a `expect` **no ejecuta el constructor antes de tiempo**: deja que el framework observe la excepción al invocarla.

Ejecuta:

~~~bash
dart test test/crop_area_test.dart
~~~

### 3. Ampliar los casos del modelo

Agrega pruebas para:

- Área negativa: `-1.0`.
- Área cero: `0.0`.
- Área no finita: `double.nan`.
- Área infinita: `double.infinity`.
- Nombre que contiene solo espacios.
- Nombre que tiene espacios exteriores, pero es válido después de `trim()`.

Usa nombres de prueba que expliquen el comportamiento, no títulos genéricos como `test 1` o `works`.

### 4. Pruebas del registro agrícola

Crea `test/agricultural_record_test.dart`:

~~~dart
import 'package:dart_lab_05/agrodiversa.dart';
import 'package:test/test.dart';

void main() {
  group('AgriculturalRecord', () {
    test('calculates total, average, and largest crop', () {
      AgriculturalRecord record = AgriculturalRecord(
        municipality: 'Andes',
        year: 2025,
        crops: [
          CropArea(name: 'Coffee', plantedArea: 125.0),
          CropArea(name: 'Plantain', plantedArea: 75.0),
          CropArea(name: 'Avocado', plantedArea: 50.0),
        ],
      );

      expect(record.totalArea, closeTo(250.0, 0.000001));
      expect(record.averageArea, closeTo(250.0 / 3, 0.000001));
      expect(record.largestCrop.name, equals('Coffee'));
    });

    test('rejects duplicate names ignoring case', () {
      expect(
        () => AgriculturalRecord(
          municipality: 'Andes',
          year: 2025,
          crops: [
            CropArea(name: 'Coffee', plantedArea: 10.0),
            CropArea(name: 'coffee', plantedArea: 20.0),
          ],
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
~~~

**Ejercicio:** añade una prueba para año fuera del rango y otra para lista de cultivos vacía. Añade una prueba con empate que compruebe que se conserva el primero. Después pasa una lista mutable al constructor, agrégale otro cultivo y verifica que el registro mantenga su número original.

### 5. Pruebas del codec sin archivos reales

Crea `test/record_json_codec_test.dart`:

~~~dart
import 'package:dart_lab_05/agrodiversa.dart';
import 'package:test/test.dart';

void main() {
  group('RecordJsonCodec', () {
    final codec = RecordJsonCodec();

    test('decodes a valid observation', () {
      const source = '''
      [
        {
          "municipality": "Andes",
          "year": 2025,
          "crops": [
            {"name": "Coffee", "plantedArea": 125}
          ]
        }
      ]
      ''';

      List<AgriculturalRecord> records = codec.decodeRecords(source);

      expect(records, hasLength(1));
      expect(records.first.totalArea, equals(125.0));
    });

    test('rejects a JSON object instead of an array', () {
      expect(
        () => codec.decodeRecords('{"municipality":"Andes"}'),
        throwsA(isA<FormatException>()),
      );
    });

    test('rejects a crop area with the wrong JSON type', () {
      const source = '''
      [
        {
          "municipality": "Andes",
          "year": 2025,
          "crops": [
            {"name": "Coffee", "plantedArea": "unknown"}
          ]
        }
      ]
      ''';

      expect(
        () => codec.decodeRecords(source),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
~~~

Estas son **pruebas unitarias**: entregan cadenas JSON directamente al codec. Así pueden ejecutarse sin red, archivos ni permisos especiales.

**Ejercicio — Ida y vuelta:** crea un registro válido, ejecútale `codec.encodeRecords`, vuelve a decodificar el texto y comprueba municipio, año, cantidad de cultivos y áreas. No compares necesariamente dos listas de objetos por `==`: todavía no hemos implementado igualdad por valor en los modelos. Compara sus **propiedades**.

### 6. Prueba que falla por una razón conocida

En una copia temporal de `CropArea`, quita la validación `plantedArea <= 0`. Ejecuta las pruebas: las pruebas sobre áreas negativas y cero deberían fallar. Restaura la regla y vuelve a ejecutarlas.

Esto muestra por qué una prueba útil debe fallar cuando se rompe el comportamiento que verifica.

### 7. Ejecutar la suite y analizar

~~~bash
dart format lib bin test
dart analyze
dart test
~~~

El comando `dart analyze` busca problemas estáticos; `dart test` ejecuta afirmaciones sobre el comportamiento. Son controles complementarios: un programa puede analizarse correctamente y, aun así, producir porcentajes erróneos.

### Reto breve — Contratos en condiciones extremas

Agrega dos pruebas nuevas:

1. Un conjunto de superficies individuales finitas tan grandes que su **suma no sea finita** debe ser rechazado por `AgriculturalRecord`.
2. Dos observaciones con el mismo municipio y año, aun con diferentes mayúsculas en el municipio, deben ser rechazadas por `RecordJsonCodec`.

Comprueba que el mensaje de fallo de cada prueba permita identificar **qué regla** se rompió.

### Comprobación

¿Cuándo se utiliza un `expect` de igualdad y cuándo uno de excepción? ¿Por qué probar el codec con una cadena JSON es preferible a abrir un archivo para todos los casos? ¿Cómo se relacionan el constructor, sus invariantes y las pruebas unitarias?

---

## Práctica 5.6 — Reto integrador: procesador agrícola con JSON (65 min)

### El problema

AgroDiversa dispone ahora de modelos tipados, validación de datos, un codec JSON y formateadores intercambiables. Falta conectar esas piezas en un programa capaz de **procesar un archivo completo sin mezclar las responsabilidades**.

Construirás una herramienta de consola que leerá el archivo ficticio `data/observations.json`, comprobará sus registros, calculará estadísticas y escribirá una **copia normalizada** en `data/normalized_observations.json`. El programa deberá admitir dos formatos de informe y comunicar claramente los errores.

A diferencia del reto del Laboratorio 03, no introducirás observaciones manualmente: **el archivo JSON es la fuente del ejercicio**. Esto permite centrarte en arquitectura, persistencia y pruebas.

### Requisitos funcionales

El programa deberá:

1. Abrir `data/observations.json` desde la raíz del proyecto.
2. Decodificarlo mediante `RecordJsonCodec`, no mediante un bloque de JSON incrustado en `main()`.
3. Rechazar documentos con estructura inválida, datos inválidos o claves de observación duplicadas.
4. Mostrar la cantidad de observaciones válidas.
5. Presentar para cada observación su municipio, año, cantidad de cultivos, área total, promedio y cultivo de mayor área.
6. Calcular el porcentaje del cultivo mayor respecto de **su propia observación**.
7. Permitir los formatos `compact` y `detailed` sin duplicar cálculos.
8. Mostrar el total general de las superficies de todas las observaciones y comprobar que sea finito.
9. Escribir los datos normalizados **en un archivo diferente del origen**, únicamente cuando la lectura y validación hayan terminado correctamente.
10. Comunicar por separado problemas de formato y problemas del sistema de archivos, sin capturar indiscriminadamente todos los errores.
11. Aceptar la lista JSON vacía `[]` como un resultado sin observaciones: deberá informar que no hay datos y no dividir entre cero.
12. Mantener una suite de pruebas unitarias para las invariantes y las conversiones, además de los escenarios manuales del programa de consola.

**No se necesita** Flutter, base de datos, API HTTP, generadores de código ni paquetes de arquitectura. El único paquete añadido es `test` como dependencia de desarrollo.

### Reglas del escenario

El archivo utiliza el esquema didáctico definido en la práctica 5.4:

~~~json
[
  {
    "municipality": "Andes",
    "year": 2025,
    "crops": [
      {"name": "Coffee", "plantedArea": 125.0},
      {"name": "Plantain", "plantedArea": 75.0},
      {"name": "Avocado", "plantedArea": 50.0}
    ]
  },
  {
    "municipality": "La Mesa",
    "year": 2024,
    "crops": [
      {"name": "Cocoa", "plantedArea": 20.0},
      {"name": "Beans", "plantedArea": 30.0}
    ]
  }
]
~~~

Las cifras son **inventadas**. Los números sirven para verificar fórmulas:

| Observación | Cultivos | Área total | Promedio | Cultivo de mayor área |
|---|---:|---:|---:|---|
| Andes (2025) | 3 | 250.00 ha | 83.33 ha | Coffee: 125.00 ha (50.00%) |
| La Mesa (2024) | 2 | 50.00 ha | 25.00 ha | Beans: 30.00 ha (60.00%) |
| **Total del archivo** | **5 registros de cultivo** | **300.00 ha** | — | — |

El total general suma superficies de **registros de observación**. No lo presentes como superficie geográfica total del municipio ni como área oficial de Colombia.

### Etapa 1 — Verificar los contratos disponibles (10 min)

Antes de modificar `main()`, revisa que se puedan utilizar desde la importación pública:

~~~dart
import 'package:dart_lab_05/agrodiversa.dart';
~~~

Debes tener disponibles:

- `CropArea` con validación y propiedades `name` y `plantedArea`.
- `AgriculturalRecord` con `municipality`, `year`, `crops`, `totalArea`, `averageArea` y `largestCrop`.
- `ReportFormatter`, `CompactFormatter` y `DetailedFormatter`.
- `RecordJsonCodec` con `decodeRecords` y `encodeRecords`.

**Comprobación previa:** si el analizador no encuentra alguna clase, comprueba `lib/agrodiversa.dart` y las rutas internas. No resuelvas el problema copiando todas las clases dentro de `bin/agrodiversa_cli.dart`.

### Etapa 2 — Elegir el formato desde argumentos (10 min)

El comando tendrá una forma sencilla:

~~~bash
dart run bin/agrodiversa_cli.dart compact
dart run bin/agrodiversa_cli.dart detailed
~~~

Si no se indica formato, `compact` será el predeterminado. Con otro argumento, el programa debe informar el uso correcto y terminar sin abrir archivos.

Reemplaza el `main()` provisional de `bin/agrodiversa_cli.dart` por este **esqueleto de integración**:

~~~dart
import 'dart:io';

import 'package:dart_lab_05/agrodiversa.dart';

ReportFormatter? selectFormatter(List<String> arguments) {
  String format = arguments.isEmpty ? 'compact' : arguments.first;

  if (arguments.length > 1) {
    return null;
  }

  switch (format) {
    case 'compact':
      return CompactFormatter();
    case 'detailed':
      return DetailedFormatter();
    default:
      return null;
  }
}

void main(List<String> arguments) {
  ReportFormatter? formatter = selectFormatter(arguments);

  if (formatter == null) {
    stderr.writeln('Usage: dart run bin/agrodiversa_cli.dart [compact|detailed]');
    exitCode = 2;
    return;
  }

  // TODO: Read, decode, report, and export the observations.
}
~~~

**Observa:** `selectFormatter` no lee archivos ni imprime. Únicamente elige una implementación. `exitCode` comunica a la terminal un resultado no exitoso cuando se recibe un argumento desconocido. El código todavía no es la solución terminada.

### Etapa 3 — Leer y decodificar correctamente (10 min)

Dentro de `main`, después de seleccionar el formateador, crea:

~~~dart
File sourceFile = File('data/observations.json');
File outputFile = File('data/normalized_observations.json');
RecordJsonCodec codec = RecordJsonCodec();
~~~

Organiza el resto de la operación en un `try` que:

1. Obtenga `String source = sourceFile.readAsStringSync();`.
2. Obtenga `List<AgriculturalRecord> records = codec.decodeRecords(source);`.
3. Muestre `'No observations available.'` si la lista está vacía.
4. Si hay observaciones, las recorra y muestre sus estadísticas.
5. Genere el texto de exportación mediante `codec.encodeRecords(records)`.
6. Escriba ese texto con `outputFile.writeAsStringSync(normalizedJson)`.

Maneja de forma explícita estas excepciones, después del bloque `try`:

~~~dart
on FileSystemException catch (error) {
  stderr.writeln('File error: ' + error.message);
  exitCode = 1;
} on FormatException catch (error) {
  stderr.writeln('Invalid agricultural data: ' + error.message);
  exitCode = 1;
}
~~~

Los manejadores anteriores son una **continuación del `try`**, no funciones independientes. Dentro de `main()` debe existir un único bloque `try { ... } on ... on ...`.

**Orden importante:** la escritura debe ocurrir **después** de decodificar y comprobar todos los registros. Así, un documento parcialmente válido no produce una exportación de datos incompletos.

### Etapa 4 — Presentar estadísticas sin repetir cálculos (15 min)

Para cada objeto `AgriculturalRecord`, usa:

~~~dart
double total = record.totalArea;
double average = record.averageArea;
CropArea largest = record.largestCrop;
double largestShare = largest.plantedArea / total * 100;
~~~

En este ejemplo, el constructor garantiza una lista no vacía y un total positivo y finito. Cuando se reciban datos de otras fuentes, esas garantías tendrán que mantenerse o comprobarse.

Construye un título a partir de municipio y año:

~~~dart
String title = record.municipality + ' (' + record.year.toString() + ')';
~~~

Usa `formatter.format(title, total)` para producir el encabezado de la observación. Muestra después cantidad de cultivos, promedio, nombre y superficie del mayor cultivo y su porcentaje. Para cifras, usa `toStringAsFixed(2)`.

Para el total general, puedes utilizar `fold`:

~~~dart
double grandTotal = records.fold<double>(
  0.0,
  (sum, record) => sum + record.totalArea,
);

if (!grandTotal.isFinite) {
  throw FormatException('Combined area is not finite.');
}
~~~

**Por qué verificar otra vez:** aunque cada registro tenga un total válido, sumar muchos registros con valores extremadamente grandes también podría producir un número no finito.

**Evita duplicar cálculo en el formateador:** el formateador debe preocuparse por cómo presentar un resultado que ya existe, no por abrir archivos ni repetir toda la lógica de los modelos.

### Etapa 5 — Proteger la exportación y revisar el código (10 min)

El texto normalizado debe escribirse exclusivamente en:

~~~text
data/normalized_observations.json
~~~

No se debe sobrescribir `data/observations.json`.

Asegúrate de que el programa **no** intente escribir el archivo cuando:

- El JSON de origen no puede decodificarse.
- Una observación contiene campos con tipos incorrectos.
- Se detectan cultivos o claves de observación duplicadas.
- Los cálculos del conjunto producen un total no finito.

Para comprobar la regla, elimina antes de cada prueba de fallo cualquier archivo de salida generado en una ejecución correcta. Así podrás observar que el fallo **no crea un archivo nuevo**. Si el archivo de salida ya existía, el programa debe dejarlo intacto al fallar antes de la escritura.

Ejecuta:

~~~bash
dart format lib bin test
dart analyze
dart test
dart run bin/agrodiversa_cli.dart compact
dart run bin/agrodiversa_cli.dart detailed
~~~

**No confundas estas operaciones:** formatear el código, analizarlo, ejecutar pruebas y utilizar la aplicación son verificaciones diferentes.

### Etapa 6 — Casos de prueba del producto (10 min)

Trabaja con una **copia temporal del archivo de entrada** para cada modificación y recupera el JSON original después de cada experimento.

| Caso | Datos o comando | Resultado esperado |
|---|---|---|
| A — Archivo válido | Dos observaciones del ejemplo | Totales 250.00 y 50.00; total general 300.00 ha; exportación |
| B — Formato compacto | Ejecutar con `compact` | Utiliza `CompactFormatter` sin cambiar los cálculos |
| C — Formato detallado | Ejecutar con `detailed` | Utiliza `DetailedFormatter` con los mismos números |
| D — Argumento inválido | Ejecutar con `unknown` | Muestra uso correcto; termina con código distinto de cero |
| E — Archivo inexistente | Cambiar temporalmente la ruta de entrada | Muestra error de archivo; no genera exportación nueva |
| F — JSON defectuoso | Eliminar un corchete | Muestra error de formato; no genera exportación nueva |
| G — Tipo incorrecto | Poner `"125"` como superficie de Coffee | Rechaza el registro; no genera exportación nueva |
| H — Duplicado | Duplicar Andes 2025 con otras mayúsculas | Rechaza las observaciones duplicadas |
| I — Sin observaciones | Sustituir contenido por `[]` | Informa que no hay observaciones; no divide entre cero; exporta `[]` |
| J — Área inválida | Poner `0` o `-2` en un cultivo | Lanza `FormatException` al construir el modelo |
| K — Empate | Dos cultivos de igual mayor área | Conserva el primero registrado |
| L — Archivo intacto | Ejecutar A y comparar el origen | El archivo de entrada sigue sin modificaciones |

**En los casos de error**, la salida normalizada de una ejecución previa podría existir: eso **no significa** que el programa haya generado una exportación válida para el archivo defectuoso. Elimina el archivo de salida antes de la prueba o comprueba su contenido y fecha para verificar que el proceso fallido no lo reemplazó.

### Depuración final

Introduce estos errores **uno por uno** en una copia y después restáuralos:

1. Capturar cualquier excepción sin mostrarla. ¿Cómo se pierde la causa del fallo?
2. Escribir el archivo normalizado antes de validar todas las observaciones. ¿Qué riesgo genera?
3. Instanciar `CompactFormatter` dentro del ciclo de observaciones, ignorando el argumento del programa. ¿Qué responsabilidad se mezcla?
4. Calcular el porcentaje del cultivo mayor usando el **total general del archivo** en lugar del total de su observación. ¿Por qué cambia el significado matemático?
5. Permitir que el modelo conserve una lista mutable recibida por referencia. ¿Cómo podría un cambio externo invalidar sus reglas?

### Ampliación opcional — Fuera de las 4,5 horas

Agrega un argumento `summary` que muestre exclusivamente la cantidad de observaciones y el total general, o permite seleccionar un archivo de origen **con validación de ruta y protección de destino**. No utilices todavía HTTP ni `Future`: esos conceptos merecen una etapa separada.

---

## Entrega y autoevaluación

Conserva en tu proyecto:

- Código modular de `lib/`, incluyendo modelos, formateadores y codec.
- Programa de consola `bin/agrodiversa_cli.dart`.
- Archivo ficticio de entrada `data/observations.json`.
- Pruebas automáticas de modelos y codec dentro de `test/`.
- Archivo normalizado de salida como resultado de ejecución, sin sobrescribir el origen.

No se exige un informe extenso ni capturas de todas las operaciones. Lo importante es el **código que funciona, las decisiones que puedes explicar y las verificaciones que puedes reproducir**.

### Lista de comprobación

- [ ] Puedo explicar herencia, interfaz y composición con ejemplos distintos.
- [ ] Uso polimorfismo para intercambiar formateadores.
- [ ] Las reglas de `CropArea` y `AgriculturalRecord` no dependen de la terminal.
- [ ] Diferencio `null`, dato inválido y excepción.
- [ ] Las importaciones siguen la estructura `bin/`, `lib/` y `test/`.
- [ ] El codec convierte JSON a objetos y objetos a JSON.
- [ ] Los datos inválidos producen errores explícitos.
- [ ] Los archivos de origen y salida son diferentes.
- [ ] Los resultados numéricos se calculan desde modelos, no se escriben a mano.
- [ ] Los dos formatos producen los mismos resultados matemáticos.
- [ ] Implementé pruebas de validación, cálculos, errores y conversión JSON.
- [ ] Comprobé los casos A–L de la integración.
- [ ] `dart analyze` y `dart test` se ejecutan sin problemas pendientes.
- [ ] Eliminé los fragmentos `TODO` y `UnimplementedError` de la implementación final.

### Preguntas para explicar tu solución

1. ¿Por qué `CropArea` y `AgriculturalRecord` no necesitan heredar uno del otro?
2. ¿Qué beneficio tiene `ReportFormatter` como interfaz?
3. ¿Qué ventaja ofrece inyectar un formateador?
4. ¿Qué invariantes garantiza el constructor del registro agrícola?
5. ¿Por qué `jsonDecode` necesita una etapa de conversión a modelos?
6. ¿Qué sucede al buscar un campo ausente o de tipo incorrecto en un mapa JSON?
7. ¿Cuál es la diferencia entre errores de formato y errores del sistema de archivos?
8. ¿Por qué el codec no debe leer archivos directamente?
9. ¿Qué comprobación corresponde a una prueba unitaria y cuál a una prueba manual de integración?
10. ¿Por qué no conviene sobrescribir el archivo de origen?
11. ¿Qué ocurre si se recibe un arreglo JSON vacío?
12. ¿Por qué un total que funciona en una observación puede desbordarse al sumar muchas observaciones?

### Criterios de finalización

El laboratorio está completo cuando puedes **leer, validar, calcular, presentar y exportar observaciones**, demostrar los dos formateadores, comprobar los errores del archivo y reproducir las pruebas automáticas. La revisión estática no sustituye las pruebas de resultados y de fallos.

## Continuidad — Laboratorio 06

Ya tienes un núcleo que trabaja con modelos, datos y formatos sin depender de Flutter. En el **Laboratorio 06** introducirás `Future`, `async`, `await`, operaciones HTTP, manejo de errores de red y nociones introductorias de `Stream`. El objetivo será cambiar la procedencia de los datos sin desorganizar el modelo ni las reglas ya aprendidas.

## Referencias oficiales

- [Dart — Clases](https://dart.dev/language/classes)
- [Dart — Modificadores de clases](https://dart.dev/language/class-modifiers)
- [Dart — Constructores](https://dart.dev/language/constructors)
- [Dart — Null safety](https://dart.dev/null-safety)
- [Dart — Manejo de errores](https://dart.dev/language/error-handling)
- [Dart — Uso de JSON](https://dart.dev/libraries/serialization/json)
- [Dart — JSON y modelos tipados](https://dart.dev/learn/tutorial/data-and-json)
- [Dart — Paquetes y organización](https://dart.dev/tools/pub/package-layout)
- [Dart — Clase File](https://api.dart.dev/dart-io/File-class.html)
- [Dart — Pruebas](https://dart.dev/tools/testing)
- [Dart — Tutorial de pruebas](https://dart.dev/learn/tutorial/testing)
- [Dart — Análisis estático](https://dart.dev/tools/dart-analyze)
