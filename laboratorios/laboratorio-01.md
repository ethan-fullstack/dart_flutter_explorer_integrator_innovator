# Laboratorio 01 — Primeros pasos en programación con Dart

En este laboratorio aprenderás a escribir y ejecutar programas desde cero. Comenzarás mostrando mensajes en la terminal y terminarás construyendo una pequeña **ficha de observación agrícola** que recibe datos, realiza cálculos y presenta un informe legible.

No necesitas conocer Python, Java, Flutter ni ningún otro lenguaje. Aquí trabajarás únicamente con **Dart y programas de consola**. La interfaz móvil llegará en una etapa posterior, cuando los fundamentos de programación ya tengan sentido.

> **Sobre los datos:** todos los nombres, cantidades y superficies que aparecen en los ejemplos son **ficticios y didácticos**. No representan estadísticas oficiales, recomendaciones agronómicas ni resultados de una fuente pública.

## Ruta del laboratorio

| Práctica | Qué aprenderás | Tiempo de trabajo |
|---|---|---:|
| 1.1 | Verificar el entorno, crear un proyecto y ejecutar el primer programa | 30 min |
| 1.2 | Variables, tipos de datos, inferencia, `final` y `const` | 40 min |
| 1.3 | Operadores, expresiones, cálculos y conversiones numéricas | 40 min |
| 1.4 | Cadenas de texto, interpolación y entrada por terminal | 40 min |
| 1.5 | Funciones, parámetros, argumentos y valores de retorno | 40 min |
| 1.6 | Reto integrador: ficha de observación agrícola | 80 min |
| **Total** | **Trabajo práctico guiado, ejercicios y verificaciones** | **270 min (4,5 h)** |

Los tiempos se refieren al trabajo práctico de las seis actividades. La instalación del software puede requerir tiempo adicional según tu equipo.

### Al finalizar podrás

- Diferenciar un algoritmo sencillo de su implementación como programa.
- Crear y ejecutar archivos `.dart` y localizar la función `main()`.
- Declarar, leer y modificar variables con tipos apropiados.
- Explicar las diferencias entre `var`, `final` y `const`.
- Construir expresiones aritméticas sin confundir valores enteros y decimales.
- Mostrar datos usando interpolación de cadenas.
- Leer datos desde una terminal y convertirlos a números.
- Separar cálculos reutilizables mediante funciones básicas.
- Comprobar resultados, provocar errores controlados y corregirlos.

**Forma de trabajo:** lee cada explicación, **predice** antes de ejecutar cuando se te indique, ejecuta el ejemplo, realiza las modificaciones propuestas y comprueba el resultado. Los fragmentos se escriben en inglés (nombres, mensajes y comentarios); las explicaciones están en español.

---

## Práctica 1.1 — Verificación del entorno y primera ejecución (30 min)

### 1. ¿Qué es programar?

Un **algoritmo** es una secuencia de instrucciones para resolver un problema. Por ejemplo, calcular la superficie total registrada de tres cultivos puede describirse sin escribir código:

1. Obtener las superficies de los tres cultivos.
2. Sumarlas.
3. Mostrar el resultado con la unidad correspondiente.

Un **programa** expresa esas instrucciones mediante un lenguaje que el computador puede ejecutar. En este caso utilizaremos **Dart**.

La **terminal** es una interfaz de texto desde la que puedes ejecutar comandos y observar sus resultados. No es necesario construir una ventana o una aplicación móvil para empezar a programar.

### 2. Verificar Dart

Abre una terminal (la integrada de Visual Studio Code también sirve) y ejecuta:

~~~bash
dart --version
~~~

Debes ver información sobre la versión del SDK. No es necesario que el número coincida con el de otra persona. Para esta ruta utilizaremos **Dart 3 estable**.

Si la terminal informa que no encuentra el comando, sigue la instalación oficial para tu sistema operativo: [Obtener Dart SDK](https://dart.dev/get-dart). Si ya tienes instalado Flutter, este **incluye Dart SDK**; normalmente no hace falta instalarlo otra vez. Tras corregir la instalación o el PATH, abre una terminal nueva y verifica de nuevo.

Puedes editar con [Visual Studio Code](https://code.visualstudio.com/) y su extensión oficial **Dart**, o utilizar otro editor de texto compatible.

### 3. Crear un proyecto de consola

Ubícate en la carpeta donde guardas tus ejercicios. En la terminal ejecuta:

~~~bash
dart create -t console dart_lab_01
cd dart_lab_01
dart run
~~~

El comando `dart create` prepara un proyecto; la opción `-t console` selecciona la plantilla de consola; `cd` entra a la carpeta creada y `dart run` ejecuta el programa principal del proyecto.

Deberías encontrar una estructura semejante a esta (la plantilla puede incluir archivos adicionales):

~~~text
dart_lab_01/
├── bin/
│   └── dart_lab_01.dart
├── pubspec.yaml
└── ...
~~~

- `bin/` contiene los programas ejecutables.
- `pubspec.yaml` identifica y configura el proyecto Dart.
- Los archivos terminados en `.dart` contienen el código fuente.

### 4. Tu primer programa

Abre `bin/dart_lab_01.dart` y reemplaza su contenido por:

~~~dart
void main() {
  print('Hello, Dart!');
  print('My first program is running.');
}
~~~

Desde la raíz del proyecto ejecuta:

~~~bash
dart run
~~~

Resultado esperado:

~~~text
Hello, Dart!
My first program is running.
~~~

**Lee el código:** `void main()` declara el punto de entrada del programa; las llaves delimitan las instrucciones; `print(...)` muestra información; el punto y coma finaliza una instrucción. Las comillas delimitan un valor de texto.

### 5. Ejecutar archivos adicionales

Durante el laboratorio conservarás un archivo independiente por práctica en `bin/`. Crea `bin/practice_01.dart`:

~~~dart
void main() {
  print('AgroDiversa');
  print('Exploring agricultural observations with Dart.');
}
~~~

Ejecútalo desde la raíz del proyecto:

~~~bash
dart run bin/practice_01.dart
~~~

Observa que `dart run` ejecuta el programa principal, mientras `dart run bin/practice_01.dart` ejecuta el archivo que indiques.

### Ejercicio — Personalizar un mensaje

Modifica `practice_01.dart` para que muestre al menos cuatro líneas: un título, el propósito del programa, el nombre de un municipio ficticio y una despedida. No copies un resultado de memoria: piensa qué instrucciones necesitas.

### Laboratorio de errores

Haz cada cambio **por separado** y vuelve al código correcto después de observar el error.

**Error A — Falta un punto y coma**

~~~dart
void main() {
  print('Hello')
}
~~~

**Error B — Texto sin comillas**

~~~dart
void main() {
  print(Hello);
}
~~~

**Error C — Nombre incorrecto**

~~~dart
void main() {
  pirnt('Hello');
}
~~~

En cada caso responde: ¿el mensaje indica un problema de sintaxis o un nombre que no se reconoce?, ¿en qué línea aparece?, ¿qué cambio mínimo lo soluciona?

### Alternativa temporal sin instalación

Si aún no puedes utilizar la terminal, puedes ejecutar los **ejemplos sin entrada de teclado** en [DartPad](https://dartpad.dev/). DartPad es útil para practicar `print`, variables y funciones, pero **no permite ejecutar los ejercicios que dependen de `dart:io` y `stdin.readLineSync()`** como si fueran programas de consola local. Para la práctica 1.4 y el reto final, utiliza el SDK local o las variantes de datos fijos indicadas más adelante.

### Comprobación

Explica con tus palabras qué hace `main()`, qué diferencia hay entre un archivo y un proyecto Dart, y cómo identificas si un programa llegó a ejecutarse correctamente.

---

## Práctica 1.2 — Variables, tipos de datos y constantes (40 min)

### 1. ¿Para qué sirve una variable?

Una **variable** permite guardar un valor al que damos un nombre. En este ejemplo, cada dato corresponde a una observación inventada.

Crea `bin/practice_02.dart`:

~~~dart
void main() {
  String municipality = 'Andes';
  String crop = 'Coffee';
  int observationYear = 2025;
  double plantedArea = 125.5;
  bool isPreliminary = true;

  print(municipality);
  print(crop);
  print(observationYear);
  print(plantedArea);
  print(isPreliminary);
}
~~~

Ejecuta:

~~~bash
dart run bin/practice_02.dart
~~~

Los tipos utilizados son:

| Tipo | Ejemplo | Qué representa |
|---|---|---|
| `String` | `'Coffee'` | Texto |
| `int` | `2025` | Número entero |
| `double` | `125.5` | Número decimal |
| `bool` | `true` | Valor verdadero o falso |
| `num` | `10` o `10.5` | Un número entero o decimal |

**Importante:** en Dart los valores booleanos son `true` y `false`, escritos en minúsculas. Para escribir un decimal en el código se utiliza **punto**, no coma.

### 2. Cambiar el valor de una variable

Prueba:

~~~dart
void main() {
  double plantedArea = 125.5;

  print(plantedArea);

  plantedArea = 130.0;

  print(plantedArea);
}
~~~

Antes de ejecutarlo, predice las dos líneas. La reasignación utiliza `=`, pero no repite el tipo `double`, porque la variable ya fue declarada.

Ahora experimenta con lo siguiente:

~~~dart
void main() {
  int cropCount = 3;
  cropCount = 4;

  print(cropCount);
}
~~~

**Ejercicio:** crea una ficha que primero muestre una superficie registrada de `80.0` hectáreas y después una superficie corregida de `82.5` hectáreas. Conserva ambos momentos en la salida.

### 3. Inferencia de tipos con `var`

Dart puede inferir el tipo a partir del valor inicial:

~~~dart
void main() {
  var department = 'Antioquia';
  var cropCount = 3;
  var averageArea = 42.5;

  print(department.runtimeType);
  print(cropCount.runtimeType);
  print(averageArea.runtimeType);
}
~~~

Aunque escribas `var`, **Dart no convierte automáticamente una variable en un contenedor de cualquier tipo**.

Compruébalo de manera intencional:

~~~dart
void main() {
  var municipality = 'Andes';
  municipality = 2025;
  print(municipality);
}
~~~

Corrige el ejemplo conservando la intención de guardar un nombre de municipio.

### 4. `final` y `const`: valores que no se reasignan

Crea este programa:

~~~dart
void main() {
  final municipality = 'Andes';
  const areaUnit = 'ha';

  print(municipality);
  print(areaUnit);
}
~~~

- `final`: la variable solo puede recibir un valor una vez; ese valor puede determinarse durante la ejecución.
- `const`: representa un valor constante conocido en tiempo de compilación.

Compara:

~~~dart
void main() {
  final startedAt = DateTime.now();
  const reportTitle = 'Agricultural observation';

  print(startedAt);
  print(reportTitle);
}
~~~

`DateTime.now()` se obtiene cuando se ejecuta el programa, por eso `final` es apropiado. En cambio, `reportTitle` es un texto fijo.

**Depuración:** cambia temporalmente `final startedAt` por `const startedAt`. Lee el error, explica la causa y restaura la versión válida. No necesitas estudiar todavía los objetos de fecha.

### 5. Nombres comprensibles y null safety

Prefiere `plantedArea` a `a` o `x1`. Para variables y funciones de varios términos, utilizaremos la convención `lowerCamelCase`.

Dart incorpora **null safety**, que ayuda a evitar accesos accidentales a valores ausentes. Por ahora basta con reconocer esta diferencia:

~~~dart
void main() {
  String municipality = 'Andes';
  String? optionalNote;

  print(municipality);
  print(optionalNote);
}
~~~

El signo `?` permite que `optionalNote` no contenga un texto y tenga el valor `null`. No utilizaremos `!` para forzar valores ni profundizaremos en nulabilidad todavía; volveremos al tema al manejar datos externos.

### Antes de ejecutar — Predice la salida

~~~dart
void main() {
  var crop = 'Beans';
  double area = 12.5;

  print(crop);
  print(area);

  crop = 'Corn';
  area = 20.0;

  print(crop);
  print(area);
}
~~~

Escribe primero las cuatro líneas que esperas. Luego ejecuta y compara.

### Reto — Ficha de un cultivo

Declara y muestra `department`, `municipality`, `crop`, `observationYear`, `plantedArea` y `isPreliminary`. Elige tipos apropiados y modifica al menos uno de los valores antes de mostrar una segunda versión de la ficha. Incluye una constante para la unidad de superficie.

### Comprobación

Explica la diferencia entre **valor**, **variable** y **tipo**. Indica cuál de `var`, `final` o `const` elegirías para cada caso: superficie que será corregida, nombre de municipio recibido durante la ejecución y etiqueta fija `'ha'`.

---

## Práctica 1.3 — Operadores, expresiones y cálculos (40 min)

### 1. Operaciones aritméticas

Crea `bin/practice_03.dart`:

~~~dart
void main() {
  int a = 10;
  int b = 3;

  print(a + b);
  print(a - b);
  print(a * b);
  print(a / b);
  print(a ~/ b);
  print(a % b);
}
~~~

| Operador | Acción | Ejemplo |
|---|---|---|
| `+` | Sumar | `10 + 3` |
| `-` | Restar | `10 - 3` |
| `*` | Multiplicar | `10 * 3` |
| `/` | Dividir y producir un valor `double` | `10 / 3` |
| `~/` | División entera con truncamiento | `10 ~/ 3` |
| `%` | Calcular el residuo de la división | `10 % 3` |

**Antes de ejecutar:** escribe tu predicción para cada expresión. Observa que `/` y `~/` **no** son equivalentes.

### 2. Construir un cálculo por etapas

Queremos calcular el área total reportada de tres cultivos. Crea:

~~~dart
void main() {
  double coffeeArea = 125.5;
  double plantainArea = 74.5;
  double avocadoArea = 50.0;

  double totalArea = coffeeArea + plantainArea + avocadoArea;

  print(totalArea);
}
~~~

El resultado esperado es `250.0`. Separamos los valores originales del resultado calculado para poder revisarlos.

**Ejercicio:** modifica `plantainArea` a `80.0`. Antes de ejecutar, calcula el nuevo total en papel. Después comprueba la salida.

### 3. Porcentaje de participación

Para conocer la participación de un cultivo en el **total de superficie registrado en este pequeño ejemplo**, usamos:

**Participación (%) = superficie del cultivo / superficie total × 100**

~~~dart
void main() {
  double coffeeArea = 125.0;
  double totalArea = 250.0;

  double coffeeShare = coffeeArea / totalArea * 100;

  print(coffeeShare);
}
~~~

Resultado:

~~~text
50.0
~~~

Este porcentaje **no** mide por sí solo riesgo climático, rentabilidad ni sostenibilidad; solo compara superficies dentro del conjunto de datos utilizado.

**Ejercicio:** sustituye los valores por `coffeeArea = 75.0` y `totalArea = 300.0`. Predice el porcentaje y verifica.

### 4. Orden de las operaciones

Predice estas salidas:

~~~dart
void main() {
  print(10 + 5 * 2);
  print((10 + 5) * 2);
}
~~~

Los paréntesis modifican el orden del cálculo. Utilízalos también cuando hagan más comprensible una fórmula, incluso si el resultado sería el mismo.

### 5. Números enteros, decimales y conversiones

Observa:

~~~dart
void main() {
  int fields = 3;
  double totalArea = 75.0;

  double averageArea = totalArea / fields;

  print(averageArea);
  print(averageArea.toStringAsFixed(2));
}
~~~

`toStringAsFixed(2)` produce **texto** con dos cifras decimales, apropiado para presentar un resultado. No altera el valor original almacenado en `averageArea`.

Una conversión explícita puede ser necesaria cuando tienes texto y necesitas números:

~~~dart
void main() {
  String areaText = '125.5';
  double plantedArea = double.parse(areaText);

  print(plantedArea + 10.0);
}
~~~

`double.parse` espera una representación numérica válida. Prueba intencionalmente el texto `'one hundred'`, identifica la excepción y recupera el valor válido. En un laboratorio posterior aprenderás a prevenir y manejar este tipo de fallos con validaciones.

### Depuración — Un cálculo equivocado

~~~dart
void main() {
  double firstArea = 20.0;
  double secondArea = 30.0;

  double averageArea = firstArea + secondArea / 2;

  print(averageArea);
}
~~~

¿Cuál era el promedio esperado? ¿Por qué el programa produce otro número? Corrige la expresión sin modificar los datos originales.

### Reto — Resumen numérico

Con tres superficies ficticias (`120.0`, `80.0` y `50.0`), calcula y muestra:

- Total registrado en hectáreas.
- Promedio por cultivo en hectáreas.
- Participación del primer cultivo en porcentaje.
- Total y promedio con dos posiciones decimales.

Después modifica una superficie y comprueba que los resultados se actualicen **sin escribir valores calculados manualmente**.

### Comprobación

Explica por qué `10 / 4` y `10 ~/ 4` dan resultados diferentes, qué devuelve `toStringAsFixed(2)` y por qué importa agrupar una suma antes de dividir para obtener el promedio.

---

## Práctica 1.4 — Texto, interpolación y entrada de datos (40 min)

### 1. Construir mensajes legibles

Crea `bin/practice_04.dart`:

~~~dart
void main() {
  String municipality = 'Andes';
  String crop = 'Coffee';
  double plantedArea = 125.5;

  print('Municipality: $municipality');
  print('Crop: $crop');
  print('Planted area: $plantedArea ha');
}
~~~

La notación `$municipality` inserta el valor de esa variable dentro del texto. Es preferible a copiar el mismo valor manualmente en cada mensaje.

Prueba además:

~~~dart
void main() {
  String crop = 'Coffee';

  print(crop.toUpperCase());
  print(crop.toLowerCase());
  print(crop.length);
}
~~~

`toUpperCase()` y `toLowerCase()` producen otras representaciones del texto; `length` informa su longitud. Modifica `crop` y compara resultados.

### 2. Leer un texto desde la terminal

La biblioteca estándar `dart:io` permite leer una línea escrita por la persona usuaria en aplicaciones de consola. **Este bloque requiere Dart instalado localmente; no funciona en DartPad.**

Reemplaza `practice_04.dart` por:

~~~dart
import 'dart:io';

void main() {
  stdout.write('Enter a municipality: ');
  String municipality = stdin.readLineSync() ?? '';

  print('Selected municipality: $municipality');
}
~~~

- `import 'dart:io';` permite utilizar entrada y salida de consola.
- `stdout.write` muestra un mensaje sin agregar automáticamente una línea final.
- `stdin.readLineSync()` intenta leer una línea y devuelve `String?`.
- `?? ''` utiliza una cadena vacía si no se recibió texto (por ejemplo, por fin de entrada). **No valida** que el usuario haya escrito un municipio real.

Ejecuta y escribe un municipio cuando la terminal lo solicite.

### 3. Leer y convertir números

La entrada llega como texto, incluso si escribes `2025` o `125.5`.

~~~dart
import 'dart:io';

void main() {
  stdout.write('Enter observation year: ');
  String yearText = stdin.readLineSync() ?? '';
  int observationYear = int.parse(yearText);

  stdout.write('Enter planted area (ha): ');
  String areaText = stdin.readLineSync() ?? '';
  double plantedArea = double.parse(areaText);

  print('Year: $observationYear');
  print('Area: $plantedArea ha');
}
~~~

Primero usa entradas válidas, como `2025` y `125.5`. Luego introduce `abc` para un número y observa qué ocurre. **Todavía no es necesario corregir automáticamente entradas inválidas**: en D02 estudiarás condiciones y validaciones, y después profundizarás en excepciones.

### 4. Espacios y formato

Prueba:

~~~dart
void main() {
  String municipality = '  Andes  ';
  String cleanMunicipality = municipality.trim();

  print(municipality);
  print(cleanMunicipality);
}
~~~

`trim()` elimina espacios iniciales y finales. Úsalo cuando prepares texto ingresado desde una terminal.

### Ejercicio — Registro descriptivo

Crea `bin/observation_description.dart`. Debe solicitar:

1. Departamento.
2. Municipio.
3. Cultivo.
4. Año.
5. Área sembrada en hectáreas.

Muestra después un resumen con las cinco respuestas y una unidad visible para el área.

**Pruebas manuales:** ejecuta una vez con datos válidos, otra cambiando la localidad y una tercera con un número inválido. Anota qué ocurre en cada caso; no ocultes los errores.

### Alternativa para DartPad

Para estudiar interpolación sin terminal, sustituye temporalmente la lectura por datos declarados:

~~~dart
void main() {
  String municipality = 'Andes';
  int observationYear = 2025;
  double plantedArea = 125.5;

  print('Municipality: $municipality');
  print('Year: $observationYear');
  print('Area: $plantedArea ha');
}
~~~

Esta alternativa **no demuestra lectura de teclado**. Completa la variante local cuando dispongas de Dart SDK.

### Comprobación

Explica la diferencia entre mostrar un dato con `print` y recibirlo con `stdin.readLineSync()`. ¿Por qué utilizas `int.parse` o `double.parse` antes de calcular? ¿Qué problema podría ocasionar una entrada numérica inválida?

---

## Práctica 1.5 — Introducción a las funciones (40 min)

### 1. ¿Por qué separar operaciones?

Si un programa necesita calcular áreas totales en varios lugares, copiar la misma expresión muchas veces dificulta su mantenimiento. Una **función** asigna un nombre a una operación que puede ejecutarse con diferentes datos.

Crea `bin/practice_05.dart`:

~~~dart
void showTitle() {
  print('============================');
  print('     AGRICULTURAL REPORT');
  print('============================');
}

void main() {
  showTitle();
  print('First observation');
  showTitle();
}
~~~

`showTitle()` es una función que no recibe argumentos y no devuelve un valor. `void` indica que su propósito es realizar una acción, en este caso mostrar texto.

### 2. Parámetros y argumentos

~~~dart
void showCrop(String crop, double plantedArea) {
  print('Crop: $crop');
  print('Area: $plantedArea ha');
}

void main() {
  showCrop('Coffee', 125.5);
  showCrop('Plantain', 74.5);
}
~~~

En la declaración, `crop` y `plantedArea` son **parámetros**. En cada llamada, los valores `'Coffee'` y `125.5` son **argumentos**.

**Antes de ejecutar:** predice qué sucede si intercambias el orden de los argumentos en una llamada, usando primero el número y después el texto. Prueba y corrige el error.

### 3. Devolver un valor con `return`

Una función de cálculo suele ser más útil si **devuelve** un resultado para reutilizarlo:

~~~dart
double calculateTotalArea(double firstArea, double secondArea) {
  return firstArea + secondArea;
}

void main() {
  double total = calculateTotalArea(125.5, 74.5);

  print(total);
}
~~~

El tipo `double` antes del nombre de la función indica el tipo de valor devuelto. `return` entrega el resultado al lugar desde el que se llamó a la función.

Compara la función anterior con:

~~~dart
void showTotalArea(double firstArea, double secondArea) {
  print(firstArea + secondArea);
}
~~~

La segunda **imprime** un resultado, pero no lo devuelve para que el resto del programa lo utilice.

### 4. Una función para calcular porcentajes

~~~dart
double calculateShare(double cropArea, double totalArea) {
  return cropArea / totalArea * 100;
}

void main() {
  double share = calculateShare(50.0, 250.0);
  print(share.toStringAsFixed(1));
}
~~~

Resultado esperado:

~~~text
20.0
~~~

Por ahora llamaremos esta función únicamente con `totalArea` mayor que cero. En el siguiente laboratorio aprenderás a definir una decisión que evite dividir entre cero; no construyas todavía una validación que no sabes explicar.

### 5. Variables locales y responsabilidades

~~~dart
double calculateAverage(double totalArea, int cropCount) {
  double result = totalArea / cropCount;
  return result;
}

void main() {
  double average = calculateAverage(250.0, 3);

  print(average.toStringAsFixed(2));
}
~~~

`result` existe dentro de `calculateAverage`. `average` existe dentro de `main`. Ambos nombres indican el propósito del dato en su contexto. La función no debe depender de valores ocultos si puede recibirlos mediante parámetros.

### Ejercicios — Funciones pequeñas

Crea tres funciones independientes:

- `calculateTotalArea(double first, double second, double third)` devuelve una suma.
- `calculateAverageArea(double total, int count)` devuelve un promedio.
- `showObservation(String municipality, String crop, double area)` muestra una ficha breve.

Desde `main()`, llama cada función con al menos dos juegos de datos y verifica resultados diferentes.

### Depuración — Falta devolver un dato

~~~dart
double calculateTotal(double first, double second) {
  double total = first + second;
}

void main() {
  print(calculateTotal(20.0, 30.0));
}
~~~

Localiza la causa del error y corrígelo sin cambiar el tipo de retorno a `void`.

### Comprobación

Diferencia **parámetro** de **argumento**, **imprimir** de **devolver** y **función** de **llamada a función**. Explica por qué las funciones de cálculo no necesitan imprimir por sí mismas.

---

## Práctica 1.6 — Reto integrador: ficha de observación agrícola (80 min)

### El problema

Una persona está organizando un pequeño registro **ficticio** de áreas sembradas para tres cultivos en un municipio. Necesita un programa que reúna los datos, calcule el área total, estime el promedio por cultivo y muestre qué porcentaje representa cada cultivo del total registrado.

La aplicación definitiva **AgroDiversa** explorará información agrícola de Colombia; este primer ejercicio construye solo una de sus piezas más sencillas: **capturar, calcular y presentar datos**. No habrá interfaz gráfica, archivo persistente, API ni datos reales todavía.

### Requisitos funcionales

El programa debe:

1. Pedir el departamento, municipio y año de observación.
2. Pedir el nombre y la superficie sembrada de tres cultivos distintos.
3. Guardar cada dato en una variable con nombre significativo.
4. Calcular el **total** de superficie registrada, en hectáreas.
5. Calcular el **promedio** por cultivo.
6. Calcular el **porcentaje de participación** de cada cultivo respecto del total.
7. Presentar un informe identificable, ordenado y legible.
8. Mostrar superficies y porcentajes con dos cifras decimales.
9. Utilizar por lo menos una función de cálculo con `return` y una función de presentación.
10. Conservar separados los datos originales y los resultados derivados.

**Condiciones del primer laboratorio:** ingresa números válidos y un **total de superficie mayor que cero**. Esta es una precondición documentada del ejercicio, no una validación del programa. En D02 aprenderás a verificar entradas mediante decisiones y repeticiones.

### Qué no debes añadir todavía

No necesitas `if`, `for`, `while`, `List`, `Map`, clases, bases de datos, Flutter, paquetes de terceros o servicios web. Esos conceptos tendrán sus propios laboratorios. Resolver el problema con variables y funciones sencillas es precisamente la meta de esta práctica.

### 1. Diseña la solución antes de escribirla (10 min)

En papel o en un comentario temporal, identifica:

- **Entradas:** departamento, municipio, año, tres nombres y tres superficies.
- **Procesamiento:** suma, promedio y tres porcentajes.
- **Salidas:** encabezado, datos, áreas, porcentajes, total y promedio.

Escribe las fórmulas que utilizarás. Piensa qué operaciones conviene poner en funciones y cuáles pertenecen a la interacción con la terminal.

### 2. Prepara el archivo y las funciones (15 min)

Crea `bin/agricultural_observation.dart`. Comienza con este esqueleto **incompleto a propósito**:

~~~dart
import 'dart:io';

double calculateTotalArea(
  double firstArea,
  double secondArea,
  double thirdArea,
) {
  // Return the sum of the three areas.
  throw UnimplementedError();
}

double calculateAverageArea(double totalArea, int cropCount) {
  // Return the average area per crop.
  throw UnimplementedError();
}

double calculateAreaShare(double cropArea, double totalArea) {
  // Return the percentage represented by one crop.
  throw UnimplementedError();
}

void showReportHeader(String department, String municipality, int year) {
  // Print a readable report header.
  throw UnimplementedError();
}

void main() {
  // Read the observation, calculate the results, and print the report.
}
~~~

`UnimplementedError()` señala de forma intencional que todavía no escribiste la implementación. **Debes reemplazar cada marcador antes de utilizar la función.** No es una manera de manejar errores de entrada.

### 3. Implementa la lectura de datos (15 min)

Dentro de `main()` agrega instrucciones, una por una, que soliciten:

- `department` y `municipality` como texto; utiliza `trim()`.
- `observationYear` como `int`.
- `firstCrop`, `secondCrop` y `thirdCrop` como texto.
- `firstArea`, `secondArea` y `thirdArea` como `double`.

Puedes usar estas pistas para las primeras variables:

~~~dart
stdout.write('Department: ');
String department = (stdin.readLineSync() ?? '').trim();

stdout.write('Municipality: ');
String municipality = (stdin.readLineSync() ?? '').trim();

stdout.write('Observation year: ');
int observationYear = int.parse(stdin.readLineSync() ?? '');
~~~

Continúa con los tres cultivos. Evita copiar datos calculados en vez de leerlos.

### 4. Calcula los resultados (15 min)

Completa las funciones y utilízalas desde `main()`. Una secuencia posible es:

~~~dart
double totalArea = calculateTotalArea(firstArea, secondArea, thirdArea);
double averageArea = calculateAverageArea(totalArea, 3);

double firstShare = calculateAreaShare(firstArea, totalArea);
double secondShare = calculateAreaShare(secondArea, totalArea);
double thirdShare = calculateAreaShare(thirdArea, totalArea);
~~~

Estos nombres corresponden a las variables que habrás declarado en `main()`. El cálculo de los porcentajes debe usar el mismo `totalArea` para los tres cultivos.

### 5. Construye el informe (10 min)

Tu salida puede inspirarse en esta ejecución **ilustrativa**, sin necesidad de copiar exactamente el formato:

~~~text
Department: Antioquia
Municipality: Andes
Observation year: 2025
First crop: Coffee
First area (ha): 125
Second crop: Plantain
Second area (ha): 75
Third crop: Avocado
Third area (ha): 50

========================================
      AGRICULTURAL OBSERVATION
========================================
Department: Antioquia
Municipality: Andes
Year: 2025

Coffee: 125.00 ha | Share: 50.00%
Plantain: 75.00 ha | Share: 30.00%
Avocado: 50.00 ha | Share: 20.00%

Total planted area: 250.00 ha
Average area per crop: 83.33 ha

Data: fictional learning example.
~~~

Para mostrar un número con dos cifras decimales, usa `toStringAsFixed(2)`. Puedes guardar el resultado formateado en otra variable de texto antes de imprimirlo. Esto evita mezclar operaciones complejas con la presentación.

### 6. Comprueba con casos concretos (10 min)

No basta con que el programa se ejecute. Debe calcular correctamente.

| Caso | Áreas de entrada (ha) | Total esperado | Promedio esperado | Porcentajes esperados |
|---|---|---:|---:|---|
| A | 125, 75, 50 | 250.00 | 83.33 | 50.00%, 30.00%, 20.00% |
| B | 20, 20, 20 | 60.00 | 20.00 | 33.33%, 33.33%, 33.33% |
| C | 12.5, 7.5, 5 | 25.00 | 8.33 | 50.00%, 30.00%, 20.00% |
| D | 100, 0, 0 | 100.00 | 33.33 | 100.00%, 0.00%, 0.00% |

En el caso B, la suma de porcentajes **mostrados con dos decimales** es 99.99% por redondeo. No cambies artificialmente los resultados para obligarlos a sumar 100.00%.

**Nota:** un área de cero en un cultivo del caso D es válida para comprobar esta operación matemática del ejercicio; aún no estamos definiendo reglas de calidad para un dataset real.

### 7. Revisa el código (5 min)

Desde la raíz del proyecto ejecuta:

~~~bash
dart format bin
dart analyze
~~~

`dart format` organiza el formato; `dart analyze` busca problemas estáticos. Revisa los mensajes en lugar de ignorarlos. Si conservaste **errores intencionales** en otros archivos de `bin/`, corrígelos primero porque `dart analyze` inspecciona el proyecto completo.

Ejecuta de nuevo:

~~~bash
dart run bin/agricultural_observation.dart
~~~

### Reto de depuración final

En una **copia temporal** del programa, introduce y corrige estas tres fallas de una en una:

- Cambiar `totalArea` por un número escrito manualmente y observar que deja de responder a los datos ingresados.
- Dividir la primera superficie por una superficie individual en vez del total; comprobar que el porcentaje resultante es erróneo.
- Quitar el `return` de una función que promete devolver `double`.

No dejes fallos intencionales en la versión final.

### Ampliación opcional (fuera de las 4,5 horas)

Permite elegir un nombre para el informe, agrega una cuarta superficie o calcula el área no correspondiente al primer cultivo (total menos primer cultivo). Resuelve la ampliación con los conceptos ya conocidos, sin adelantar decisiones ni colecciones.

### Si trabajas en DartPad

Puedes construir una **variante de datos fijos** sin `import 'dart:io';`, sustituyendo las lecturas dentro de `main()` por declaraciones como estas:

~~~dart
String department = 'Antioquia';
String municipality = 'Andes';
int observationYear = 2025;

String firstCrop = 'Coffee';
String secondCrop = 'Plantain';
String thirdCrop = 'Avocado';

double firstArea = 125.0;
double secondArea = 75.0;
double thirdArea = 50.0;
~~~

Conserva las mismas funciones y cálculos. Esta variante te permite estudiar el procesamiento, pero **no sustituye la comprobación de entrada por terminal** cuando dispongas del SDK.

---

## Entrega y autoevaluación

El producto principal es `bin/agricultural_observation.dart`, ejecutable y con resultados comprobados. Conserva también los archivos de ejercicios en `bin/` para mostrar la evolución de tu aprendizaje. No se requiere un informe de varias páginas ni capturas de cada instrucción.

### Lista de comprobación

- [ ] Verifiqué `dart --version` y ejecuté un archivo desde la terminal.
- [ ] Distingo `String`, `int`, `double`, `bool` y la inferencia con `var`.
- [ ] Puedo explicar cuándo elegir `final` y `const`.
- [ ] Utilicé correctamente las operaciones aritméticas y los paréntesis.
- [ ] Mostré resultados usando interpolación de texto.
- [ ] Leí entradas y convertí números válidos.
- [ ] Escribí funciones con parámetros y retorno.
- [ ] Ejecuté al menos los cuatro casos numéricos del reto.
- [ ] Corregí los errores intencionales y revisé el análisis estático.
- [ ] Puedo explicar el programa sin depender de copiar el código.

### Preguntas de cierre

1. ¿Qué diferencia existe entre una instrucción `print` y una función que devuelve un resultado?
2. ¿Por qué un año puede representarse mediante `int` y una superficie mediante `double`?
3. ¿Qué sucede si declaras una variable como `final` e intentas reasignarla?
4. ¿Por qué se convierte una cadena a número antes de calcular?
5. ¿Por qué el porcentaje necesita dividir por el área total y no por otra área?
6. ¿Qué ventajas ofrece separar el cálculo de la presentación?
7. ¿Qué falla sigue teniendo este programa cuando alguien escribe texto donde debería ingresar un número?
8. ¿Por qué una suma de porcentajes redondeados puede mostrar 99.99% en vez de 100.00%?

### Criterios para considerar terminado el laboratorio

La práctica está completa si **puedes ejecutarla**, explicar qué representa cada entrada, justificar los tipos y las fórmulas, mostrar los cuatro casos de prueba, distinguir funciones que devuelven valores de las que muestran texto y reconocer la limitación de las entradas aún no validadas. Un programa que solo imprime resultados precalculados **no** satisface el reto.

## Continuidad: qué aprenderás después

En el **Laboratorio 02** introducirás comparaciones, condiciones, ciclos y validaciones. Así podrás hacer que el programa responda a entradas erróneas, ofrezca opciones y repita operaciones sin cerrar inesperadamente. Más adelante incorporarás colecciones, modelos, JSON, asincronía y Flutter.

## Referencias oficiales

- [Dart — guía de instalación](https://dart.dev/get-dart)
- [Dart — creación de proyectos](https://dart.dev/tools/dart-create)
- [Dart — ejecución de programas](https://dart.dev/tools/dart-run)
- [Dart — variables](https://dart.dev/language/variables)
- [Dart — funciones](https://dart.dev/language/functions)
- [Dart — operadores](https://dart.dev/language/operators)
- [Dart — biblioteca `dart:io`](https://api.dart.dev/dart-io/dart-io-library.html)
- [DartPad](https://dartpad.dev/)
