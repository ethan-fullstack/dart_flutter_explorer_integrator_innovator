# Laboratorio 02 — Decisiones, ciclos y validación de datos en Dart

En el [Laboratorio 01](laboratorio-01.md) construiste una ficha de observación agrícola que recibía nombres y áreas, calculaba totales y mostraba porcentajes. El programa funcionaba con entradas correctas, pero se interrumpía cuando alguien escribía letras donde esperaba un número. Además, las instrucciones para leer cada cultivo estaban repetidas.

En este laboratorio aprenderás a **tomar decisiones, repetir instrucciones y validar entradas**. Al final desarrollarás un explorador de consola capaz de registrar entre uno y cinco cultivos, conservar el último resumen durante la ejecución y mostrar qué cultivo tiene la mayor participación en el área ingresada.

No necesitas conocimientos previos de Java, Python ni Flutter. La única base necesaria es el Laboratorio 01: variables, operaciones, funciones elementales y entrada por terminal.

> **Contexto del proyecto:** los municipios, cultivos y superficies utilizados aquí son **datos ficticios para aprender programación**. La proporción del cultivo con mayor área es un cálculo descriptivo sobre lo que se ingresó; no mide por sí sola riesgos, sostenibilidad, productividad ni diversificación agrícola real.

## Ruta del laboratorio

| Práctica | Aprendizaje principal | Tiempo efectivo |
|---|---|---:|
| 2.1 | Comparaciones, valores booleanos y operadores lógicos | 35 min |
| 2.2 | Decisiones: `if`, `else if` y `else` | 40 min |
| 2.3 | Opciones concretas con `switch` | 40 min |
| 2.4 | Repetición con `for`, contadores, acumuladores y máximos | 40 min |
| 2.5 | `while`, `do while` y validación segura de entradas | 45 min |
| 2.6 | Reto integrador: explorador agrícola interactivo | 70 min |
| **Total** | **Prácticas, retos, depuración y comprobación** | **270 min (4,5 h)** |

La duración es para trabajo práctico; la instalación del entorno se realiza antes.

### Objetivos

Al finalizar podrás:

- Distinguir la asignación de una comparación y obtener resultados `bool`.
- Expresar reglas combinadas mediante `&&`, `||` y `!`.
- Seleccionar un camino de ejecución con `if` y un caso discreto con `switch`.
- Repetir operaciones mediante `for`, `while` y `do while`.
- Utilizar contadores, acumuladores y variables que conservan un máximo.
- Leer texto y números con reintentos y sin conversiones que interrumpan el programa.
- Diseñar un menú de consola que conserva y consulta el último resumen.
- Comprobar resultados, casos límite y errores intencionales.

## Preparación

Conserva tu carpeta del Laboratorio 01 sin reemplazarla. En el directorio en el que guardas los proyectos, ejecuta:

~~~bash
dart create -t console dart_lab_02
cd dart_lab_02
dart run
~~~

Trabajaremos con Dart 3 estable. Crea un archivo nuevo en `bin/` para cada práctica, junto con el proyecto que genera la plantilla:

~~~text
dart_lab_02/
├── bin/
│   ├── dart_lab_02.dart
│   ├── practice_21.dart
│   ├── practice_22.dart
│   ├── practice_23.dart
│   ├── practice_24.dart
│   ├── practice_25.dart
│   └── agricultural_explorer.dart
└── pubspec.yaml
~~~

Los archivos de prácticas se crearán progresivamente. Para ejecutar uno específico, desde la raíz del proyecto:

~~~bash
dart run bin/practice_21.dart
~~~

Los identificadores, mensajes y comentarios **dentro del código** están en inglés. Las explicaciones se presentan en español. En cada práctica: **predice, ejecuta, modifica, depura y comprueba**.

La ruta principal utiliza Dart en una terminal: los ejercicios con `dart:io` y `stdin.readLineSync()` no funcionan de la misma manera en DartPad.

---

## Práctica 2.1 — Comparaciones y lógica booleana (35 min)

### Objetivos

Reconocer comparaciones que devuelven `true` o `false` y combinar condiciones para formular reglas sencillas.

### 1. Comparar no es asignar

Crea `bin/practice_21.dart`:

~~~dart
void main() {
  double cropArea = 75.0;
  double totalArea = 250.0;

  print(cropArea > 100.0);
  print(cropArea < totalArea);
  print(cropArea == totalArea);
  print(cropArea != totalArea);
  print(cropArea >= 75.0);
  print(cropArea <= 74.0);
}
~~~

| Operador | Significado |
|---|---|
| `==` | Igual |
| `!=` | Diferente |
| `>` y `<` | Mayor y menor |
| `>=` y `<=` | Mayor o igual y menor o igual |

**Antes de ejecutar:** predice las seis líneas como `true` o `false`. Luego comprueba el resultado.

`=` asigna un valor; `==` compara valores. La condición de `if`, que estudiarás enseguida, necesita un `bool`, no una asignación.

### 2. Guardar el resultado de la comparación

~~~dart
void main() {
  double area = 125.0;

  bool isPositive = area > 0;
  bool isAtLeastOneHundred = area >= 100;

  print('Positive: $isPositive');
  print('At least 100 ha: $isAtLeastOneHundred');
}
~~~

**Ejercicio:** cambia `area` a `0.0`, `99.9`, `100.0` y `150.0`. Predice la pareja de respuestas antes de cada ejecución.

### 3. Igualdad de cadenas

~~~dart
void main() {
  String firstCrop = 'Coffee';
  String secondCrop = 'coffee';

  print(firstCrop == secondCrop);
  print(firstCrop.toLowerCase() == secondCrop.toLowerCase());
}
~~~

Una comparación directa distingue mayúsculas de minúsculas. `toLowerCase()` te permite normalizar texto cuando esa sea la regla deseada.

**Ejercicio:** prueba `'Coffee'` y `'Cocoa'`. Explica por qué los resultados cambian.

### 4. Combinar condiciones

~~~dart
void main() {
  double area = 120.0;
  int year = 2025;
  bool isPreliminary = false;

  bool meetsBoth = area > 0 && year >= 2000;
  bool requiresReview = area <= 0 || isPreliminary;
  bool isFinal = !isPreliminary;

  print(meetsBoth);
  print(requiresReview);
  print(isFinal);
}
~~~

- `&&` es verdadero si **ambas** condiciones se cumplen.
- `||` es verdadero cuando **al menos una** se cumple.
- `!` invierte `true` y `false`.

La condición `year >= 2000` es un **criterio inventado para practicar**, no una regla oficial sobre datos agrícolas.

### Predicción — Tabla de verdad

Completa esta tabla antes de experimentar:

| `hasName` | `hasPositiveArea` | `hasName && hasPositiveArea` | `hasName || hasPositiveArea` |
|---|---|---|---|
| `true` | `true` | ¿? | ¿? |
| `true` | `false` | ¿? | ¿? |
| `false` | `true` | ¿? | ¿? |
| `false` | `false` | ¿? | ¿? |

Comprueba cada fila cambiando las variables:

~~~dart
void main() {
  bool hasName = true;
  bool hasPositiveArea = false;

  print(hasName && hasPositiveArea);
  print(hasName || hasPositiveArea);
  print(!hasName);
}
~~~

### Laboratorio de errores — Operador equivocado

Copia temporalmente:

~~~dart
void main() {
  int observationYear = 2025;
  bool matchesYear = observationYear = 2025;

  print(matchesYear);
}
~~~

El programa no tiene el tipo esperado a la derecha de la asignación a `matchesYear`. Identifica y corrige **un solo operador**, sin cambiar el tipo de `matchesYear`.

### Reto — Registro utilizable

Declara `municipality`, `plantedArea` y `observationYear`. Calcula `bool isUsable` que sea verdadero cuando:

- El nombre contenga al menos un carácter distinto de espacios.
- El área sea positiva.
- El año sea mayor que cero.

Prueba cinco combinaciones, incluyendo un nombre formado por espacios, un área cero y un año cero.

### Comprobación

¿Por qué `100 >= 100` es verdadero? ¿En qué difieren `&&` y `||`? ¿Por qué no debes intercambiar `=` y `==`?

---

## Práctica 2.2 — Decisiones con `if`, `else if` y `else` (40 min)

### Objetivos

Ejecutar diferentes instrucciones según condiciones, ordenar correctamente los límites y evitar operaciones inválidas.

### 1. Primera decisión

Crea `bin/practice_22.dart`:

~~~dart
void main() {
  double area = 0.0;

  if (area > 0) {
    print('Area is positive.');
  }
}
~~~

Con `0.0`, el mensaje no aparece. Cambia el área a `15.0`. La condición debe dar como resultado `true` o `false`; Dart no considera automáticamente los números como valores booleanos.

### 2. Dos alternativas

~~~dart
void main() {
  double area = -2.0;

  if (area >= 0) {
    print('Area is non-negative.');
  } else {
    print('Area cannot be negative.');
  }
}
~~~

**Ejercicio:** ejecuta con `-2.0`, `0.0` y `2.0`. Explica por qué cero recorre la primera rama.

### 3. Leer un nombre y comprobarlo

~~~dart
import 'dart:io';

void main() {
  stdout.write('Municipality: ');
  String municipality = (stdin.readLineSync() ?? '').trim();

  if (municipality.isEmpty) {
    print('Municipality is required.');
  } else {
    print('Municipality: $municipality');
  }
}
~~~

Prueba un nombre, una cadena vacía y solo espacios. Por ahora el programa **informa** del error; más adelante aprenderás a solicitar otra entrada.

### 4. Varias decisiones y orden de prioridad

Este ejemplo inventa categorías de participación porcentual **para estudiar el código**, no para emitir diagnósticos agrícolas:

~~~dart
void main() {
  double largestShare = 62.5;

  if (largestShare >= 75) {
    print('Very high share.');
  } else if (largestShare >= 50) {
    print('High share.');
  } else if (largestShare >= 25) {
    print('Moderate share.');
  } else {
    print('Low share.');
  }
}
~~~

**Antes de ejecutar:** determina las salidas para `24.99`, `25`, `49.99`, `50`, `74.99` y `75`. Ejecútalas una a una.

Ahora provoca un error lógico: coloca `largestShare >= 25` antes que `largestShare >= 75`. ¿Qué categoría recibe `80` y por qué? Corrige la prioridad.

### 5. Proteger una división

La ficha del Laboratorio 01 calculaba porcentajes suponiendo un total positivo. Con decisiones puedes verificarlo:

~~~dart
void main() {
  double cropArea = 0.0;
  double totalArea = 0.0;

  if (totalArea > 0) {
    double share = cropArea / totalArea * 100;
    String formattedShare = share.toStringAsFixed(2);
    print('Share: $formattedShare%');
  } else {
    print('Total area must be positive.');
  }
}
~~~

Cambia los datos a `cropArea = 40.0` y `totalArea = 100.0`. Comprueba que ahora se ejecuta la rama de cálculo.

### 6. Condiciones anidadas y condiciones compuestas

~~~dart
void main() {
  String municipality = 'Andes';
  double area = 30.0;

  if (municipality.isNotEmpty) {
    if (area > 0) {
      print('Accepted.');
    }
  }
}
~~~

Resuelve la misma regla con una sola condición que use `&&`. Compara legibilidad y resultado. No toda condición anidada es un error: usa la forma que exprese mejor la regla.

### Depuración — Un punto y coma importante

~~~dart
void main() {
  double area = -10.0;

  if (area > 0);
  {
    print('Area accepted.');
  }
}
~~~

Ejecuta y observa por qué aparece el mensaje aun con área negativa. Corrige el carácter responsable. Evita mantener el ejemplo incorrecto en la versión final.

### Reto — Clasificación con función

Escribe `String classifyShare(double share)`. Debe devolver las cuatro etiquetas anteriores para porcentajes entre `0` y `100`. Fuera de ese intervalo, devuelve `'Invalid share'`. Valida también que el número sea finito con `share.isFinite`.

Prueba `-1`, `0`, `25`, `50`, `75`, `100` y `101`. Comprueba los límites sin cambiar la función para cada caso.

### Comprobación

¿Por qué importa el orden de `else if`? ¿Cuándo necesitas un `else`? ¿Cuál es la diferencia entre detectar un error y permitir corregirlo sin reiniciar el programa?

---

## Práctica 2.3 — Opciones conocidas con `switch` (40 min)

### Objetivos

Seleccionar entre comandos concretos, incorporar una rama para opciones desconocidas y separar decisiones de la lectura.

### 1. Selección por valor

Crea `bin/practice_23.dart`:

~~~dart
void main() {
  int option = 2;

  switch (option) {
    case 1:
      print('Register observation.');
    case 2:
      print('View summary.');
    case 0:
      print('Exit.');
    default:
      print('Unknown option.');
  }
}
~~~

Antes de ejecutar, predice qué se muestra para `2`. Prueba después `1`, `0` y `9`.

**En Dart 3**, los casos no vacíos de un `switch` de instrucciones terminan al ejecutar su cuerpo. **No necesitas agregar `break` tras cada caso**. La sintaxis antigua de otros lenguajes no debe copiarse automáticamente.

### 2. Elegir la estructura correcta

~~~dart
void main() {
  String format = 'compact';

  switch (format) {
    case 'compact':
      print('One-line summary.');
    case 'detailed':
      print('Detailed summary.');
    default:
      print('Unsupported format.');
  }
}
~~~

`switch` se lee bien cuando una variable puede tomar varias **opciones específicas**. Una regla como `area > 0 && year >= 2000` se expresa más directamente con `if`.

**Ejercicio:** agrega `'header'` como tercer formato y prueba uno desconocido.

### 3. Selección desde la terminal

~~~dart
import 'dart:io';

void main() {
  print('1. Register');
  print('2. Summary');
  print('0. Exit');
  stdout.write('Option: ');

  String option = (stdin.readLineSync() ?? '').trim();

  switch (option) {
    case '1':
      print('Register selected.');
    case '2':
      print('Summary selected.');
    case '0':
      print('Exit selected.');
    default:
      print('Invalid option.');
  }
}
~~~

Esta versión compara **texto**. No requiere conversión, pero se ejecuta una sola vez. Prueba entradas `'1'`, `' 2 '`, `'9'` y la cadena vacía.

### 4. Separar la elección de su presentación

~~~dart
String getOptionName(String option) {
  switch (option) {
    case '1':
      return 'Register';
    case '2':
      return 'Summary';
    case '0':
      return 'Exit';
    default:
      return 'Unknown';
  }
}

void main() {
  print(getOptionName('1'));
  print(getOptionName('2'));
  print(getOptionName('8'));
}
~~~

La función recibe un valor y devuelve una etiqueta. No necesita mostrar un menú ni leer la terminal: **cada parte tiene una responsabilidad**.

### 5. Una alternativa de Dart 3: expresión `switch`

~~~dart
void main() {
  String option = '2';

  String label = switch (option) {
    '1' => 'Register',
    '2' => 'Summary',
    '0' => 'Exit',
    _ => 'Unknown',
  };

  print(label);
}
~~~

Observa que aquí se utilizan `=>`, comas y `_`. Esta alternativa produce directamente un resultado; no es obligatoria para el reto integrador. Trabajaremos principalmente con `switch` de instrucciones.

### Laboratorio de errores — Caso repetido

~~~dart
void main() {
  String option = '2';

  switch (option) {
    case '1':
      print('Register');
    case '1':
      print('Summary');
    default:
      print('Unknown');
  }
}
~~~

Guarda el ejemplo en una copia temporal y analízalo:

~~~bash
dart analyze bin/practice_23.dart
~~~

Identifica por qué el segundo caso no representa una alternativa distinta. Corrígelo reemplazando el valor repetido por `'2'`.

### Reto — Menú de secciones

Crea una función que acepte los comandos de texto `'a'`, `'b'`, `'c'` y `'q'` y devuelva una etiqueta para cada uno; en otros casos debe devolver `'Unknown'`. Muéstrala con distintas entradas. Todavía no hace falta repetir el menú.

### Comprobación

¿Cuándo conviene `switch`? ¿Qué hace `default`? ¿Qué diferencia hay entre la instrucción `switch` y una expresión `switch`? ¿Por qué no es necesario `break` después de cada caso en los ejemplos de Dart 3?

---

