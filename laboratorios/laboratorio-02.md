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

### Organización del trabajo en GitHub

Desde este laboratorio, utiliza **un único repositorio individual y acumulativo** para toda la ruta. Guarda este proyecto en `lab-02/dart_lab_02/`; conserva `lab-01/` y las demás carpetas anteriores cuando existan. Ejecuta `dart create -t console dart_lab_02` desde `lab-02/`, y ejecuta `dart run`, `dart analyze` y las instrucciones de cada práctica desde la raíz de `dart_lab_02/`.

La estructura anterior es la del **repositorio personal de desarrollo**, no la del repositorio que aloja las guías. Después de terminar, actualiza el README principal con el estado, las instrucciones de ejecución y los cambios de las versiones anteriores. Registra commits significativos, sin una cantidad mínima artificial. Cada laboratorio requiere también un **informe PDF obligatorio** como segunda evidencia; se prepara para la entrega, sin reducir las horas de programación.

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

## Práctica 2.4 — Ciclo `for`, contadores, acumuladores y máximos (40 min)

### Objetivos

Repetir una cantidad conocida de veces, calcular totales sin copiar instrucciones y conservar el mayor valor observado.

### 1. Repetir sin duplicar código

Crea `bin/practice_24.dart`:

~~~dart
void main() {
  for (int index = 1; index <= 3; index++) {
    print('Observation $index');
  }
}
~~~

En el encabezado del ciclo encontrarás tres partes:

- `int index = 1`: valor inicial.
- `index <= 3`: condición que se revisa antes de cada iteración.
- `index++`: incrementa el índice después de cada ejecución del cuerpo.

**Antes de ejecutar:** predice exactamente las tres líneas. Cambia el límite a `5`, y luego reemplaza `index <= 3` por `index < 3`. Explica por qué cambió la cantidad de repeticiones.

### 2. Contadores y acumuladores

Un **contador** registra cuántas veces ocurre algo; un **acumulador** reúne cantidades sucesivas. Ejecuta:

~~~dart
void main() {
  int processedCrops = 0;
  double totalArea = 0.0;

  for (int index = 1; index <= 3; index++) {
    processedCrops++;
    totalArea += 20.0;
  }

  print('Crops: $processedCrops');
  print('Total area: $totalArea ha');
}
~~~

`processedCrops++` incrementa el valor en uno. `totalArea += 20.0` equivale a `totalArea = totalArea + 20.0`.

**Ejercicio:** modifica el límite a cuatro iteraciones y acumula `12.5` en cada una. Calcula los dos resultados manualmente antes de ejecutar.

### 3. Leer varias superficies desde la terminal

~~~dart
import 'dart:io';

void main() {
  double totalArea = 0.0;

  for (int index = 1; index <= 3; index++) {
    stdout.write('Area for crop $index (ha): ');
    double area = double.parse(stdin.readLineSync() ?? '');
    totalArea += area;
  }

  String formattedTotal = totalArea.toStringAsFixed(2);
  print('Total area: $formattedTotal ha');
}
~~~

Por ahora **ingresa únicamente números correctos**, como `20`, `30` y `50`. Debes obtener `100.00 ha`. En la práctica siguiente sustituirás la conversión insegura por una lectura validada.

### 4. Promedio

~~~dart
void main() {
  const int cropCount = 4;
  double totalArea = 0.0;

  for (int index = 1; index <= cropCount; index++) {
    totalArea += 12.5;
  }

  double averageArea = totalArea / cropCount;

  print('Total area: $totalArea');
  print('Average area: $averageArea');
}
~~~

El promedio necesita una cantidad positiva de cultivos. No escribas una fórmula con una cantidad cero; más adelante validarás este dato antes de utilizarlo.

### 5. Encontrar el mayor valor

~~~dart
void main() {
  double largestArea = 0.0;

  for (int index = 1; index <= 4; index++) {
    double currentArea = index * 12.5;

    if (currentArea > largestArea) {
      largestArea = currentArea;
    }

    print('Area $index: $currentArea ha');
  }

  print('Largest area: $largestArea ha');
}
~~~

Predice los cuatro valores generados para `currentArea`. Indica cuándo cambia `largestArea`.

**Ejercicio — Empate:** imagina que dos cultivos tienen la misma superficie. Si deseas conservar el **primer** cultivo con el valor máximo, ¿debes usar `>` o `>=` al actualizar el máximo? Comprueba el comportamiento con un ejemplo que guarde también una etiqueta de texto.

### 6. Terminar u omitir una iteración

~~~dart
void main() {
  for (int index = 1; index <= 5; index++) {
    if (index == 2) {
      continue;
    }

    if (index == 5) {
      break;
    }

    print(index);
  }
}
~~~

`continue` omite lo que resta de la iteración actual; `break` sale del ciclo. Predice los números impresos antes de ejecutar.

### Depuración — Un error en el límite

~~~dart
void main() {
  int cropCount = 3;
  int processed = 0;

  for (int index = 1; index < cropCount; index++) {
    processed++;
  }

  print(processed);
}
~~~

La intención era procesar tres cultivos, pero el programa solo cuenta dos. Corrige la condición sin añadir una instrucción manual después del ciclo.

### Reto — Registro con cantidad variable

Solicita una cantidad de cultivos entre `1` y `5`. Para esta práctica puedes asumir que la persona escribe números válidos. Repite la lectura de superficies tantas veces como indique la cantidad, y muestra:

- Cuántos cultivos se procesaron.
- Superficie total en hectáreas.
- Promedio por cultivo.
- Mayor superficie ingresada.

**Pruebas:** ejecuta con un único cultivo de `12.5`, tres cultivos de `20`, `30` y `50`, y cinco cultivos de `1`, `2`, `3`, `4` y `5`. Verifica las sumas y el máximo antes de ejecutar.

### Comprobación

¿Cuál es la diferencia entre un contador y un acumulador? ¿Por qué `for` puede ejecutar cero veces su cuerpo? ¿Qué cambia si actualizas el máximo con `>=` en vez de `>`?

---

## Práctica 2.5 — Ciclos `while` y `do while`, y entradas seguras (45 min)

### Objetivos

Repetir una operación cuando no conoces la cantidad de intentos, convertir entradas sin excepciones por formato y terminar correctamente cuando finaliza la entrada estándar.

### 1. `while`: comprobar antes de repetir

Crea `bin/practice_25.dart`:

~~~dart
void main() {
  int attempts = 1;

  while (attempts <= 3) {
    print('Attempt $attempts');
    attempts++;
  }
}
~~~

Predice las tres líneas. Ahora inicializa `attempts` en `4`: el cuerpo no se ejecuta.

**Error intencional:** analiza qué sucedería si eliminas `attempts++`. No es necesario ejecutar ese cambio: explica por qué la condición permanecería verdadera y el programa entraría en un **ciclo infinito**.

### 2. `do while`: repetir antes de comprobar

~~~dart
void main() {
  int attempts = 4;

  do {
    print('Attempt $attempts');
    attempts++;
  } while (attempts <= 3);
}
~~~

A diferencia de `while`, `do while` ejecuta su cuerpo **al menos una vez**, incluso si la condición inicial es falsa.

**Ejercicio:** sustituye `attempts = 4` por `attempts = 1` en ambos programas. Compara cuántas veces se muestran los mensajes.

### 3. Validar conversiones con `tryParse`

En el Laboratorio 01 utilizaste `int.parse` y `double.parse`. Esas funciones pueden lanzar una excepción cuando el texto no representa un número válido. Para validar entradas, usa `tryParse`:

~~~dart
void main() {
  int? validNumber = int.tryParse('12');
  int? invalidNumber = int.tryParse('abc');

  print(validNumber);
  print(invalidNumber);
}
~~~

`int.tryParse` produce un `int?`: un entero o `null` si la conversión falla. Para decimales existe `double.tryParse`:

~~~dart
void main() {
  double? area = double.tryParse('42.5');

  if (area == null) {
    print('Invalid number.');
  } else {
    print('Area: $area ha');
  }
}
~~~

**Ejercicio:** prueba `'0'`, `'-4.5'`, `'abc'` y `' 42.5 '`. Explica por qué `-4.5` puede convertirse sin ser aceptable para una regla que exige áreas positivas.

### 4. No aceptar `NaN` ni valores infinitos

Una conversión válida no implica que el dato sirva para el cálculo. `double.tryParse` puede interpretar `NaN` e `Infinity`, que no representan superficies finitas.

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

Prueba `'NaN'`, `'Infinity'`, `'-1'`, `'0'` y `'12.5'`.

Observa el orden de la condición compuesta: si `area` es `null`, el operador `||` evita evaluar las condiciones siguientes.

### 5. Primera función reutilizable: texto obligatorio

Vuelve a escribir `bin/practice_25.dart` con este programa:

~~~dart
import 'dart:io';

String? readRequiredText(String prompt) {
  while (true) {
    stdout.write(prompt);
    String? rawInput = stdin.readLineSync();

    if (rawInput == null) {
      print('Input ended.');
      return null;
    }

    String value = rawInput.trim();

    if (value.isNotEmpty) {
      return value;
    }

    print('A non-empty value is required.');
  }
}

void main() {
  String? municipality = readRequiredText('Municipality: ');

  if (municipality == null) {
    return;
  }

  print('Municipality: $municipality');
}
~~~

`String?` señala que la función puede devolver texto o `null`. La lectura `stdin.readLineSync()` devuelve `null` cuando **termina la entrada**, por ejemplo al recibir fin de archivo; no es lo mismo que una cadena vacía. Por eso, al recibir `null` no repetimos eternamente la petición.

**Pruebas:** introduce espacios, una cadena vacía y después `Andes`. La función debe seguir preguntando hasta que el nombre no esté vacío.

### 6. Segunda función: entero dentro de límites

Agrega esta función **después de la función anterior y antes de `main()`**:

~~~dart
int? readIntInRange(String prompt, int minimum, int maximum) {
  while (true) {
    stdout.write(prompt);
    String? rawInput = stdin.readLineSync();

    if (rawInput == null) {
      print('Input ended.');
      return null;
    }

    int? value = int.tryParse(rawInput.trim());

    if (value != null && value >= minimum && value <= maximum) {
      return value;
    }

    print('Enter an integer from $minimum to $maximum.');
  }
}
~~~

Para comprobarla, reemplaza temporalmente **solo `main()`**:

~~~dart
void main() {
  int? cropCount = readIntInRange('Crop count (1-5): ', 1, 5);

  if (cropCount == null) {
    return;
  }

  print('Accepted crop count: $cropCount');
}
~~~

En una misma ejecución escribe `abc`, `0`, `6` y después `3`. La función solo debe finalizar al recibir el dato válido. Haz otra ejecución con `1` y otra con `5` para comprobar los límites.

### 7. Tercera función: área positiva y finita

Agrega también esta función antes de `main()`:

~~~dart
double? readPositiveArea(String prompt) {
  while (true) {
    stdout.write(prompt);
    String? rawInput = stdin.readLineSync();

    if (rawInput == null) {
      print('Input ended.');
      return null;
    }

    double? value = double.tryParse(rawInput.trim());

    if (value != null && value.isFinite && value > 0) {
      return value;
    }

    print('Enter a positive finite area.');
  }
}
~~~

Sustituye temporalmente `main()`:

~~~dart
void main() {
  double? area = readPositiveArea('Planted area (ha): ');

  if (area == null) {
    return;
  }

  String formattedArea = area.toStringAsFixed(2);
  print('Accepted area: $formattedArea ha');
}
~~~

Introduce valores inválidos y finalmente uno válido: `abc`, `0`, `-3`, `NaN`, `Infinity` y `12.5`. El programa solo acepta el último.

La restricción de área positiva corresponde al ejercicio; un conjunto de datos real podría contener valores cero cuyo significado tendría que analizarse, no descartarse automáticamente.

### 8. Repetir el menú

Para estudiar un menú persistente crea **otro archivo**, `bin/menu_loop.dart`, sin reemplazar tus tres funciones anteriores:

~~~dart
import 'dart:io';

void main() {
  while (true) {
    print('1. Say hello');
    print('0. Exit');
    stdout.write('Option: ');

    String? option = stdin.readLineSync();

    if (option == null) {
      print('Input ended.');
      return;
    }

    switch (option.trim()) {
      case '1':
        print('Hello!');
      case '0':
        print('Goodbye!');
        return;
      default:
        print('Unknown option.');
    }
  }
}
~~~

Después de cada opción, el menú vuelve a mostrarse hasta que elijas `0`. `return` sale de `main()` y termina el programa.

**Ejercicio:** agrega la opción `'2'` para mostrar otro mensaje; comprueba que el menú continúa después de elegirla.

### Depuración — Ciclo que nunca lee otro dato

~~~dart
import 'dart:io';

void main() {
  String? input = stdin.readLineSync();

  while (input != '0') {
    print('Waiting for 0...');
  }
}
~~~

**No ejecutes la versión incorrecta sin control:** si la primera entrada es distinta de `0`, `input` nunca cambia. Corrige el programa para leer nuevamente **dentro del ciclo** y terminar también si la nueva lectura es `null`.

### Reto — Entrada confiable

Crea `bin/validated_observation.dart`. Reutiliza las tres funciones para solicitar:

- Nombre de cultivo no vacío.
- Año entero en el rango **didáctico** `2000` a `2100`.
- Área positiva y finita.

Muestra el registro solo si las tres lecturas terminaron correctamente. Prueba nombres vacíos, letras en vez de números, año fuera del rango y `NaN` antes de una entrada válida.

### Comprobación

¿Por qué `tryParse` permite validar sin depender de una excepción por formato? ¿En qué se diferencian `null` y `''`? ¿Cómo termina una función que repite lecturas cuando la entrada estándar llega a su fin?

---

## Práctica 2.6 — Reto integrador: explorador agrícola interactivo (70 min)

### El problema

La ficha del Laboratorio 01 siempre pedía tres cultivos. Ahora debes construir un programa de consola que solicite **entre uno y cinco cultivos**, calcule sus áreas y permita revisar el **último resumen guardado en memoria** sin capturar de nuevo los datos.

El programa no tendrá interfaz gráfica, archivos, API, clases ni colecciones. Todavía **no guarda cada cultivo para consultas posteriores**: conserva únicamente los datos generales del último resumen y el cultivo con mayor área. Esa limitación motivará el Laboratorio 03, dedicado a funciones y colecciones.

### Requisitos

El programa debe permitir:

1. Registrar una observación con nombre de municipio y año.
2. Pedir una cantidad de cultivos entre `1` y `5`.
3. Para cada cultivo, leer un nombre obligatorio y una superficie positiva y finita.
4. Calcular suma y promedio.
5. Conservar el nombre y el área del cultivo de mayor superficie.
6. Calcular la participación de ese cultivo respecto del total ingresado.
7. Consultar el último resumen sin volver a leer datos.
8. Reemplazar el resumen anterior con una nueva captura **completa**.
9. Avisar si se intenta consultar antes de registrar.
10. Salir mediante la opción `0`, también cuando la entrada estándar termine.

**Política de empate:** si dos cultivos tienen la misma área máxima, conserva el **primero ingresado**. Para eso la actualización del máximo utiliza `>` y no `>=`.

**Límites didácticos:** el año debe estar entre `2000` y `2100`. No son límites institucionales ni una validación de datos oficiales.

### Ejemplo de uso

~~~text
================================
       AGRODIVERSA CONSOLE
================================
1. Register observation
2. View latest summary
0. Exit
Option: 1
Municipality: Andes
Year (2000-2100): 2025
Crop count (1-5): 3
Crop 1 name: Coffee
Crop 1 area (ha): 125
Crop 2 name: Plantain
Crop 2 area (ha): 75
Crop 3 name: Avocado
Crop 3 area (ha): 50
Observation saved in memory.

1. Register observation
2. View latest summary
0. Exit
Option: 2

Municipality: Andes
Year: 2025
Crops processed: 3
Total area: 250.00 ha
Average area: 83.33 ha
Largest crop: Coffee
Largest area: 125.00 ha
Largest share: 50.00%

1. Register observation
2. View latest summary
0. Exit
Option: 0
Goodbye!
~~~

El formato no tiene que ser idéntico, pero los cálculos y comportamientos deben coincidir.

### Etapa 1 — Diseñar las variables y el flujo (10 min)

Antes de codificar, responde:

- ¿Cómo identificas si todavía no existe un resumen?
- ¿Qué datos permanecen entre una opción del menú y otra?
- ¿Qué datos deben comenzar en cero cada vez que se inicia un **nuevo** registro?
- ¿Cómo sabes cuándo termina la captura de cultivos?
- ¿Cuándo se actualiza la información que ve la opción de consulta?
- ¿Por qué no es necesario tener una variable por cada cultivo para calcular total y máximo?

### Etapa 2 — Reutilizar funciones de lectura (10 min)

Crea `bin/agricultural_explorer.dart`. Coloca al inicio:

~~~dart
import 'dart:io';
~~~

Después del `import` y **antes de `main()`**, copia las funciones ya elaboradas y verificadas en la práctica 2.5, sin duplicarlas:

- `String? readRequiredText(String prompt)`.
- `int? readIntInRange(String prompt, int minimum, int maximum)`.
- `double? readPositiveArea(String prompt)`.

Agrega esta función de cálculo:

~~~dart
double calculateShare(double area, double totalArea) {
  return area / totalArea * 100;
}
~~~

Úsala solo cuando `totalArea` sea mayor que cero. La captura de al menos un cultivo con superficie positiva garantizará esa condición si el registro terminó correctamente.

### Etapa 3 — Menú y estado de la sesión (15 min)

Agrega un único `main()` al mismo archivo:

~~~dart
void main() {
  bool hasSummary = false;

  String latestMunicipality = '';
  int latestYear = 0;
  int latestCropCount = 0;
  double latestTotalArea = 0.0;
  double latestLargestArea = 0.0;
  String latestLargestCrop = '';

  while (true) {
    print('1. Register observation');
    print('2. View latest summary');
    print('0. Exit');

    int? option = readIntInRange('Option: ', 0, 2);

    if (option == null || option == 0) {
      print('Goodbye!');
      return;
    }

    switch (option) {
      case 1:
        // Read a complete observation and update the latest values.
        print('Registration not implemented yet.');
      case 2:
        if (!hasSummary) {
          print('No observation has been registered.');
        } else {
          // Display the latest values and their statistics.
          print('Summary not implemented yet.');
        }
      default:
        print('Unknown option.');
    }
  }
}
~~~

**Este es un esqueleto incompleto**, no la solución final. Los mensajes `not implemented yet` señalan las partes que debes reemplazar.

`hasSummary` se vuelve `true` solo **después** de completar satisfactoriamente un registro.

### Etapa 4 — Capturar los cultivos y calcular (15 min)

Reemplaza el contenido del `case 1` leyendo primero municipio, año y cantidad:

~~~dart
String? municipality = readRequiredText('Municipality: ');
if (municipality == null) {
  return;
}

int? year = readIntInRange('Year (2000-2100): ', 2000, 2100);
if (year == null) {
  return;
}

int? cropCount = readIntInRange('Crop count (1-5): ', 1, 5);
if (cropCount == null) {
  return;
}
~~~

Este fragmento pertenece **dentro del `case 1`**, no a una nueva función `main()`.

A continuación inicializa **variables locales**. No reutilices el acumulador del registro anterior:

~~~dart
double totalArea = 0.0;
double largestArea = 0.0;
String largestCrop = '';
~~~

Completa este ciclo con las funciones de lectura que ya creaste:

~~~dart
for (int index = 1; index <= cropCount; index++) {
  // TODO: Read a non-empty crop name.
  // TODO: Read a positive finite area.
  // TODO: Return from main if the input ends.
  // TODO: Add the area to totalArea.
  // TODO: Update largestArea and largestCrop if area is greater.
}
~~~

**Pistas para completar el ciclo:** usa `readRequiredText('Crop $index name: ')` y `readPositiveArea('Crop $index area (ha): ')`; comprueba `null` inmediatamente; usa `totalArea += area`; compara `area > largestArea` y actualiza nombre y superficie en el mismo bloque.

Al terminar el ciclo, asigna los valores locales a `latestMunicipality`, `latestYear`, `latestCropCount`, `latestTotalArea`, `latestLargestArea` y `latestLargestCrop`. Luego establece `hasSummary = true` y muestra `'Observation saved in memory.'`.

**Importante:** no reemplaces los valores `latest...` antes de terminar toda la captura. Si el flujo se interrumpe, no debe quedar un resumen parcialmente actualizado. Este ejercicio termina `main()` cuando ocurre fin de entrada; más adelante aprenderás estrategias para recuperar sesiones.

### Etapa 5 — Consultar el resumen (10 min)

En `case 2` conserva:

~~~dart
if (!hasSummary) {
  print('No observation has been registered.');
} else {
  // Display the existing summary.
}
~~~

En la rama `else` calcula las dos cantidades derivadas:

~~~dart
double averageArea = latestTotalArea / latestCropCount;
double largestShare = calculateShare(
  latestLargestArea,
  latestTotalArea,
);
~~~

Muestra nombre del municipio, año, cantidad de cultivos, superficie total, promedio, nombre y superficie del cultivo mayor y su porcentaje. Utiliza `toStringAsFixed(2)` para mostrar superficies y porcentaje con dos decimales.

**La consulta no debe solicitar entradas adicionales:** todos esos resultados se derivan de las variables de resumen.

### Etapa 6 — Pruebas obligatorias (10 min)

| Caso | Secuencia | Comportamiento esperado |
|---|---|---|
| A — Sin datos | Iniciar → opción `2` | Avisa que no existe observación; conserva el menú |
| B — Normal | Áreas `125`, `75`, `50` | Total `250.00`; promedio `83.33`; máximo `125.00`; participación `50.00%` |
| C — Un solo cultivo | Una superficie `12.5` | Total, promedio y máximo `12.50`; participación `100.00%` |
| D — Empate | Áreas `20`, `20`, `10` | Conserva el **primer** nombre de área `20`; total `50.00`; participación `40.00%` |
| E — Entradas inválidas | Año `abc`; cantidad `0`; áreas `NaN`, `-3`, `0` y luego `12.5` | Repite preguntas; solo acepta valores válidos |
| F — Reemplazo | Registrar B y luego un cultivo de `8` | La consulta posterior muestra **solo** el nuevo resumen de `8.00` |
| G — Opción inválida | Menú: `9`, `hello` y después `0` | Repite solicitud de opción; permite terminar |
| H — Fin de entrada | Finalizar entrada estándar durante una lectura | Termina ordenadamente, sin ciclo infinito |

Si tu terminal permite enviar fin de archivo, comprueba el caso H durante una captura. En numerosos sistemas Unix se utiliza `Ctrl+D`; en otros entornos la combinación es diferente.

### Revisión del proyecto

Desde la raíz de `dart_lab_02`, con todos los errores intencionales corregidos, ejecuta:

~~~bash
dart format bin
dart analyze
dart run bin/agricultural_explorer.dart
~~~

`dart format` organiza el formato y `dart analyze` revisa problemas estáticos. Si tienes un ejemplo incorrecto que conservaste para depuración, corrígelo antes de analizar el proyecto completo.

### Depuración intencional — Una modificación cada vez

En **copias temporales** introduce y corrige:

1. Sustituye `index <= cropCount` por `index < cropCount`. ¿Qué registro falta?
2. No reinicies `totalArea` al comenzar una nueva observación. ¿Qué total aparece en el segundo registro?
3. Actualiza `largestCrop` siempre, sin comprobar el máximo. ¿Por qué ahora guarda el último cultivo?
4. Cambia `area > largestArea` por `area >= largestArea`. ¿Qué ocurre con el empate?
5. Establece `hasSummary = true` antes de leer todas las áreas. ¿Por qué puede resultar engañoso, aunque el programa termine si la entrada finaliza?

Después de cada experimento restaura la versión correcta.

### Ampliación opcional (fuera de las 4,5 horas)

Agrega una opción que muestre únicamente el nombre del cultivo predominante y su participación, o conserva la cantidad total de observaciones **completas** registradas durante la sesión. No utilices todavía `List`, `Set`, `Map` ni clases.

---

## Entrega y autoevaluación

La entrega de este laboratorio consta de **dos evidencias obligatorias**: un repositorio individual acumulativo en GitHub y un **informe PDF**. El código debe poder ejecutarse y verificarse; el PDF explica sus resultados y decisiones.

### Evidencia 1 — GitHub

- Utilizar el **mismo repositorio individual** desde el Laboratorio 01; conservar las carpetas de los laboratorios anteriores sin sobrescribir sus versiones.
- Agregar la carpeta `lab-02/dart_lab_02/`, con el proyecto Dart, su configuración y los archivos de ejercicios desarrollados.
- Incluir como producto principal bin/agricultural_explorer.dart y conservar los demás archivos correspondientes a las prácticas de este laboratorio.
- Implementar y demostrar: Menú, condiciones, ciclos, validaciones `tryParse`, acumulación y máximo; pruebas A–H.
- Registrar **commits significativos** que evidencien implementación, mejoras, depuración y correcciones reales, sin exigir un número fijo.
- Actualizar el **README principal** con el estado y las instrucciones de ejecución de los laboratorios 01 al 02, así como las funcionalidades incorporadas.
- Evitar subir credenciales, archivos temporales o resultados generados innecesarios.

### Evidencia 2 — Informe PDF

El documento debe incluir:

1. Identificación de la persona que desarrolla, número del laboratorio y enlace al repositorio individual.
2. Descripción de las nuevas funcionalidades de explorador interactivo y de sus archivos principales.
3. Decisiones técnicas justificadas: condiciones, ciclos, validaciones y estado del menú.
4. Resultados de las pruebas y verificaciones: casos probados, resultados esperados y observados, errores y correcciones.
5. Seguimiento de GitHub y evolución del sistema: commits representativos y cambios progresivos. Comparar las validaciones y el menú del Laboratorio 02 con la ficha del 01; explicar qué falta conservar.
6. Respuestas argumentadas a las cinco situaciones de análisis siguientes.

El PDF no necesita una extensión fija ni capturas de cada instrucción; **sí debe explicar y respaldar el trabajo con evidencias concretas** de código, resultados y commits. Su preparación es parte de la entrega posterior a la sesión práctica de 4,5 horas.

### Preguntas de análisis

Responde **estas cinco preguntas en el PDF**. En cada caso explica cómo identificarías el problema, qué cambio aplicarías con los conceptos del laboratorio y cómo verificarías que funciona.

**1. ¿Qué harías si una superficie `abc` cierra inesperadamente el programa?**

Explica el cambio de `parse` a `tryParse`, la repetición de la entrada y las comprobaciones del menú.

**2. ¿Qué harías si la aplicación solicita cultivos indefinidamente?**

Revisa condición y actualización del contador; comprueba límites de uno y cinco cultivos.

**3. ¿Qué harías si el segundo registro acumula áreas del primero?**

Identifica dónde reiniciar el acumulador y diseña una comprobación de reemplazo.

**4. ¿Qué harías si el máximo siempre corresponde al último cultivo?**

Corrige la comparación y el momento de actualizar el nombre; prueba un empate.

**5. ¿Qué harías si una opción desconocida bloquea el menú?**

Explica el uso de `switch`, `default`, `while` y la validación de opciones.

### Preguntas de repaso (opcionales)

Las siguientes preguntas originales sirven para estudiar; **no sustituyen** las cinco preguntas de análisis exigidas en el PDF.

1. ¿Qué diferencia hay entre `=` y `==`?
2. ¿Por qué una cadena no puede utilizarse directamente como condición de `if` en Dart?
3. ¿Por qué el orden de `else if` puede cambiar el resultado?
4. ¿En qué se diferencian `for` y `while`?
5. ¿Qué provoca un ciclo infinito?
6. ¿Qué diferencia hay entre `int.parse` e `int.tryParse`?
7. ¿Por qué `-10` puede convertirse a número pero no aceptarse como superficie positiva?
8. ¿Por qué debe reiniciarse el total para un registro nuevo?
9. ¿Qué sucede si hay empate entre dos superficies máximas?
10. ¿Qué información falta guardar para poder listar todos los cultivos después de capturarlos?

### Lista de verificación

- [ ] Puedo diferenciar asignación y comparación.
- [ ] Comprendo `&&`, `||` y `!`.
- [ ] Utilizo `if` y `else if` con límites correctamente ordenados.
- [ ] Uso `switch` para opciones concretas.
- [ ] Comprendo `for`, `while` y `do while`.
- [ ] Distingo contador, acumulador y mayor valor.
- [ ] Uso `tryParse` y compruebo `null` antes de calcular.
- [ ] Rechazo entradas de área negativas, cero, `NaN` e `Infinity`.
- [ ] El menú no se interrumpe al recibir una opción inválida.
- [ ] Puedo consultar sin datos y registrar una nueva observación.
- [ ] He comprobado los casos A–H.
- [ ] El código final no conserva errores intencionales.

### Criterios de finalización

El reto está completo cuando puedes registrar y consultar observaciones, explicar el recorrido de las condiciones y ciclos, reproducir las pruebas numéricas y de error, demostrar que el segundo registro reemplaza el resumen y justificar las limitaciones de la solución. **Una ejecución correcta con un solo juego de datos no es una verificación suficiente.**

### Condiciones de entrega

**Adjunta el informe PDF y proporciona el enlace al repositorio individual de GitHub.** El repositorio debe permitir revisar las versiones acumuladas desde el Laboratorio 01, los commits y las instrucciones para ejecutar el proyecto actual. El informe debe justificar las decisiones técnicas, presentar resultados de verificación y analizar la evolución de la aplicación.

## Continuidad

En el **Laboratorio 03** profundizarás en funciones y aprenderás a utilizar `List`, `Set` y `Map`: podrás conservar varios registros, recorrerlos, buscar por nombre, eliminar duplicados cuando corresponda y generar consultas sobre colecciones. Eso permitirá evolucionar de un solo resumen en memoria a un verdadero conjunto de observaciones.

## Referencias oficiales

- [Dart — Operadores](https://dart.dev/language/operators)
- [Dart — Decisiones con if y switch](https://dart.dev/language/branches)
- [Dart — Ciclos](https://dart.dev/language/loops)
- [Dart — Funciones](https://dart.dev/language/functions)
- [Dart — Null safety](https://dart.dev/null-safety)
- [Dart — int.tryParse](https://api.dart.dev/dart-core/int/tryParse.html)
- [Dart — double.tryParse](https://api.dart.dev/dart-core/double/tryParse.html)
- [Dart — Biblioteca dart:io](https://api.dart.dev/dart-io/dart-io-library.html)
- [Dart — Análisis estático](https://dart.dev/tools/dart-analyze)
