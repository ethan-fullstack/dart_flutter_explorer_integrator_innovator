# Laboratorio 05 — POO avanzada, manejo de datos, JSON y pruebas en Dart

En el [Laboratorio 03](laboratorio-03.md) construiste un catálogo de observaciones agrícolas con `List`, `Set` y `Map`. La etapa siguiente de la ruta, el Laboratorio 04, está dedicada a clases, objetos, constructores, encapsulamiento y colaboración entre objetos.

En este laboratorio aprenderás a **extender el diseño mediante interfaces, herencia y composición**, detectar datos inválidos con excepciones, organizar el código en módulos, convertir modelos tipados a JSON y probar el comportamiento automáticamente.

> **Continuidad:** el Laboratorio 04 todavía no está publicado en este repositorio. El Laboratorio 05 mantiene la numeración acordada y contiene un recordatorio de clases, pero **no sustituye la enseñanza completa de POO básica**. Cuando el 04 esté disponible, estúdialo antes de este.

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

