#import "uc3mreport.typ": conf

#show: conf.with(
  degree: "Grado en Ingeniería Informática",
  subject: "Heurística y Optimización",
  year: (25, 26),
  project: "Practica 1",
  title: "Programación Lineal",
  group: 81,
  authors: (
    (
      name: "Noa",
      surname: "López Fernández",
      nia: 100522230
    ),
    (
      name: "Guillermo",
      surname: "González Avilés",
      nia: 100522146
    ),
  ),
  professor: "Carlos Linares López",
  toc: true,
  logo: "old",
  language: "es"
)

= Introducción al documento <introducción-al-documento.>
En el presente documento se pretende presentar el desarrollo y análisis de la primera práctica de la asignatura Heurística y Optimización. En ella se abordan diferentes problemas de programación lineal, todos ellos aplicados al caso de una empresa de transporte de autobuses, más concretamente a la gestión de averías y la prevención de las mismas mediante la asignación de los autobuses a talleres. Para ello, el documento consta de tres grandes apartados diferenciados entre sí.

En la primera parte de la memoria se presenta un modelo simple que únicamente tiene en cuenta los autobuses y la distancia de dichos autobuses a sus talleres correspondientes. En el apartado se define el problema así como el proceso seguido para la modelización, que pretenden hacer ver la comprensión del problema para su resolución. Además, dado que este problema debía ser resuelto mediante el solver disponible en LibreOffice Calc, también se presenta el resultado obtenido en el solver y sus correspondientes interpretaciones.

En la segunda parte se presenta el modelo de dos problemas más complejos y avanzados para su resolución mediante GLPK. El primer problema establece una conexión entre las ganancias de la empresa de transporte, pretendiendo minimizar las pérdidas asociadas a la asignación de los autobuses en un único taller con diferentes franjas horarias disponibles para realizar reparaciones a los autobuses. El segundo pretende minimizar los efectos de las reparaciones de los autobuses en aquellos pasajeros que tienen contratados dos autobuses de manera simultánea, pero en este caso se disponen de diferentes talleres con múltiples franjas horarias, añadiendo complejidad al modelo.Para ambos modelos se sigue un proceso similar al de la primera parte del problema, expresando nuestro entendimiento de ambos problemas y definiendo parámetros, variables, restricciones y la función objetivo de dichos problemas de programación lineal.

Por último, se presenta una sección de análisis de los resultados en la que se pretende analizar y comparar los resultados obtenidos en la sección anterior.

En definitiva, el objetivo de dicho documento es presentar y afianzar los conocimientos adquiridos en el ámbito de la programación lineal y los diferentes mecanismos de resolución de problemas de este tipo mediante la realización de ejercicios prácticos cercanos a la vida cotidiana.

= Parte 1: Modelo básico en Calc.  <parte-1-modelo-básico-en-calc.>
Dado el problema presentado, se pretende realizar una asignación de 5 autobuses entre los 5 talleres disponibles mediante la resolución de un problema de programación lineal.

Definiendo un taller cualquiera como $t_i$ y un bus cualquiera como $a_j$ , donde i es el número de talleres disponibles y j el número de autobuses disponibles una posible representación de las variables de decisión podría ser la siguiente:
#align(center)[
  $
  x_(i,j) <= cases(
    1 quad "si a_j se asigna a t_j",
    0 quad "en cualquier otro caso"
  ) med med , med med forall i , j in {1 , 2 , 3 , 4 , 5}
  $
]

Donde la variable $x_(i j)$ es #strong[binaria] y toma el valor 0 si no se asigna el taller $t_i$ al autobús $a_j$ y 1 en caso de que la asignación si se realice.

Para asegurarnos de que las asignaciones se realizan de manera correcta, debemos asegurar que a cada taller no se le asigna más de un autobús y que cada autobús tiene un único taller asignado. En base a ello, definimos las siguientes restricciones en nuestro problema de asignación:


#block[
  #set enum(numbering: "1.", start: 1)
  + #strong[Un bus sólo puede tener asignado un único taller]; O lo que es lo mismo, la suma de las variables binarias de decisión para un autobús $a_j$ es igual a 1.

  #align(center)[
  $
  sum_(j = 1)^5 x_(i j) = 1$ $med,,med forall j in {1 , 2 , 3 , 4 , 5}
  $
  ]
]

#block[
  #set enum(numbering: "1.", start: 2)
  + #strong[Un taller no puede tener más de un autobús asignado]; O, dicho de otra forma, la suma de las variables binarias de decisión para un taller cualquiera $t_i$ es menor o igual a 1.

  #align(center)[
  $
  sum_(j = 1)^5 x_(i j) = 1$ $med,,med med forall i in {1 , 2 , 3 , 4 , 5}
  $
  ]
]

#block[
  #set enum(numbering: "1.", start: 3)
  + #strong[Las variables de decisión deben ser binarias y no negativas]; pues las únicas posibilidades son asignar o no la variable. Definimos la última restricción como:

  #align(center)[
  $
  x_(i j) in { 0 , 1 } med med forall i , j in {1 , 2 , 3 , 4 , 5}
  $
  ]
]


Por último, se pide que la distancia recorrida por los autobuses sea mínima, es decir, debemos #strong[minimizar la suma total de las distancias] recorridas por todos los autobuses. Dada la definición de la distancia unitaria de un taller $t_i$ a un autobús $a_j$ como $c_(i j)$ kilómetros, nuestra función objetivo para el problema de programación lineal se definiría como:

#align(center)[
  $m i n med z med = med sum_(i = 1)^5 sum_(j = 1)^5 c_(i j) dot.op med x_(i j)$ $, , med med i , j in {1 , 2 , med 3 , med 4 , med 5}$
]

En la que $c_(i j)$ es un elemento de la matriz de costes $c_(5 x 5)$ que define las distancias en kilómetros de todos los autobuses a todos los talleres. Y la función objetivo #emph[z] define la suma de las distancias de las asignaciones realizadas puesto que las variables de decisión tomarán el valor 0 en caso de que no se realice la asignación y por tanto solo se tendrá en cuenta la distancia de aquellos autobuses a los talleres que les han sido asignados.

Y con todo lo anterior, podemos concluir que nos encontramos ante #strong[un problema de programación lineal de minimización] que se #strong[ajusta a un Modelo de Asignación] (pues se asigna un único bus a un único taller y viceversa) en el que tratamos de minimizar los costes (en este caso las distancias en km entre autobuses y talleres).

Cuya definición matricial es:

#figure(
  align(center,)[
    $m i n med z med = med c^T dot.op med X$

    $s . t . med A X = b$

    $x_(i j) gt.eq 0 , med forall i , j in {1 , med 2 , med 3 , med 4 , med 5}$
    ],
)

Donde:

- #emph[X] es el vector de variables de decisión

- #emph[c] es el vector de costes $mat(
  206, 66, 263, 104, 154;
  285, 86, 111, 300, 110;
  164, 251, 109, 220, 177;
  264, 175, 217, 147, 149;
  141, 75, 218, 87, 228
)
$

- A les la matriz de coeficientes tecnológicos.

- #emph[b] el vector de recursos #emph[:] $b = med$#emph[#strong[1];]

Dada la modelización explicada y utilizando el solver #emph[LibreOffice CoinMP Linear Solver] el #strong[resultado óptimo obtenido de la función objetivo es 573 km];, produciendo las siguientes asignaciones de talleres a autobuses que minimizan la distancia en caso de avería:

- Taller 1 al autobús 2 (66 km)

- Taller 2 al autobús 5 (110 km)

- Taller 3 al autobús 3 (109 km)

- Taller 4 al autobús 4 (147 km)

- Taller 5 al autobús 1 (141 km)

Definidas por el resultado matricial:
$mat(
  0, 1, 0, 0, 0;
  0, 0, 0, 0, 1;
  0, 0, 1, 0, 0;
  0, 0, 0, 1, 0;
  1, 0, 0, 0, 0
)
$

= Parte 2: Modelo avanzado en GLPK. <parte-2-modelo-avanzado-en-glpk.>
== Minimización del impacto de averías. <minimización-del-impacto-de-averías.>
Dado el problema presentado, se pretende #strong[minimizar la pérdida económica resultante de las averías inesperadas] que se producen al inicio del servicio. Para ello, haremos una modelización del problema como un problema de programación lineal.

Para ello, definimos un taller único que contiene #emph[n] franjas diferentes para realizar reparaciones, denominamos $s_i$ a una franja cualquiera del taller. En este caso disponemos de #emph[m] autobuses en el servicio, y como en la primera parte de la práctica, denominaremos $a_j$ a un autobús cualquiera del servicio.

Además disponemos también de parámetros que tienen un impacto en el coste de dichas asignaciones. En primer lugar, definimos la distancia de un autobús cualquiera $a_j$ al taller que contiene las franjas como $d_j$ y la cantidad de viajeros del mismo como $p_j$ .

El problema tiene los siguientes costes asociados:

- $k^d$ : euros por kilómetros que nos cuesta mover un autobús hacia un destino

- $k^p$ : penalización por pasajero asociada a no poder asignar un autobús a una franja

Con los que podemos definir los siguientes parámetros del problema:

- $k^d d_j$ : coste de asignar un autobús $a_j$ a una franja del taller

- $k^p p_j$ : penalización de no asignar un autobús $a_j$ a ninguna franja del taller

Una vez definidos los parámetros, definiremos nuestra variable de decisión $x_(i j)$ de manera muy similar a como lo hicimos en la primera parte de la práctica.
#align(center)[
  $
  x_(i,j) <= cases(
    1 quad "si a_j se asigna a s_j",
    0 quad "en cualquier otro caso"
  ) med med , med med forall i in {1 , ... , n} med , 
    med med forall j in {1 , ... , n}
  $
]

En este caso, dado que todos los autobuses acuden al mismo taller y no se tienen en cuenta otros talleres, el modelo de asignación sólo depende del autobús y la franja asignada, de la misma forma que en la parte anterior. Por tanto $x_(i j)$ determina si se ha realizado una asignación entre un autobús y una franja.

Una vez tenemos las restricciones, podemos definir las restricciones de nuestro problema:

+ #strong[Cada franja ofertada por el taller solo puede ser asignada a un bus.] Es decir, el sumatorio de las asignaciones realizadas en la franja no debe ser mayor que uno. Nótese cómo en este caso, se pueden dejar franjas vacías en el caso en que #emph[m \< n];.

#align(center)[
$sum_(j = 1)^m x_(i j) lt.eq 1$ $, , med med forall i in {1 , med . med . med . med , med n}$
]

#block[
  #set enum(numbering: "1.", start: 2)
  + #strong[Un autobús no puede estar en dos franjas simultáneamente.] Es decir, el sumatorio de las asignaciones del autobús deben ser menores que uno. Pueden quedar autobuses sin asignar por falta de espacio en el caso de que #emph[n \< m];.
]
#align(center)[
$sum_(i = 1)^n x_(i j) lt.eq 1$ $, , med med forall j in {1 , med . med . med . med , med m}$
]

#block[
  #set enum(numbering: "1.", start: 3)
  + #strong[Las variables de decisión deben ser no negativas.] Y en el caso particular de $x_(i j)$ , además, debe ser binaria pues para realizar correctamente las asignaciones, sólo debe poder tomar los valores 0 y 1.
]

#align(center)[
$x_(i j) in { 0 , med 1 } med med , , med med p_j med , med d_j gt.eq 0 med med med forall i in { 1 , . . . , n } med med forall j in { 1 , . . . , m } med$
]

Por tanto, dado que la intención del problema es minimizar los costos asociados a dichas asignaciones de autobuses a sus respectivas franjas, #strong[podemos definir nuestra función objetivo como la minimización del sumatorio del coste de la asignación de cada autobús] como vemos a continuación:
#align(center)[
$m i n med z med = med sum_(j = 1)^m \[ med k^d d_j dot.op (sum_(i = 1)^n x_(i j)) med + k^p p_j dot.op (1 - sum_(i = 1)^n x_(i j)) \] med$ ,, $i in { 1 , . . . , n } med med j in { 1 , . . . , m }$
]

En la que por cada autobús calculamos si tiene o no asignada una franja mediante el sumatorio $sum_(i = 1)^n x_(i j)$ que como se define mediante las restricciones sólo podrá tomar los valores 1 en caso de que exista una asignación para ese autobús o 0 en caso de que no tenga ninguna asignación. De la misma manera, mediante $(1 - sum_(i = 1)^n x_(i j))$ obtenemos el valor 1 si no se ha realizado una asignación y el 0 en caso de que si, pues una vez más el sumatorio se acota mediante las restricciones, y de este modo solo añadimos el coste de penalización en caso de que no se realice ninguna asignación para el autobús y el coste de desplazamiento en caso de que se realice la asignación.

== Maximización de la satisfacción de los pasajeros. <maximización-de-la-satisfacción-de-los-pasajeros.>
Dado el mismo contexto que en los problemas anteriores relacionado con la asignación de talleres a los autobuses de una empresa de transporte. En este caso, se pretende maximizar la satisfacción de los clientes #strong[minimizando el número total de pasajeros cuyos autobuses tienen un taller asignado en la misma franja horaria];.

En este caso, la empresa dispone de u talleres donde $t_i$ es un taller cualquiera y cada taller dispone de n franjas horarias, contando todos los talleres con el mismo número de franjas horarias y siendo $s_i$ una franja cualquiera de un taller. Por último, en el problema actual debemos asignar los m autobuses que trabajan en dicha empresa a una franja horaria en el taller de tal modo que un autobús cualquiera $a_i$ solo pueda estar asignado a una franja $s_k$ de un taller $t_j$ .

Para ello, definimos el siguiente parámetro necesario para dicha resolución:

$c_(i j)$ : número de pasajeros que han contratado simultáneamente el autobús $a_i med$y el $a_j$ .

Y el siguiente parámetro $o_(i j)$ que define la disponibilidad de una franja $s_i$ en un taller $t_j$ definiéndose como:
#align(center)[
  $
  o_(i,j) <= cases(
    1 quad "si s_i de t_j está ocupada",
    0 quad "en cualquier otro caso"
  ) med med , med med forall i in {1 med , . . . med , med n} med med forall j in {1 med , . . . med , med u}$
]

A continuación, definimos las variables de decisión del problema que definen las asignaciones realizadas y la coincidencia de dos autobuses en una misma franja horaria (pero, evidentemente, en talleres diferentes).
#align(center)[
  $
  x_(i,j, k) <= cases(
    1 quad "si a_i se asigna a s_k de t_j",
    0 quad "en cualquier otro caso"
  ) med med , med med forall i in {1 med , . .  . med , med m} med med forall j in {1 med , . . . med , med u} med med forall k in {1 med , . . . med , med n}$
]

#align(center)[
  $
  y_(i,j) <= cases(
    1 quad "si a_i y a_ tienen la misma franja asignada ",
    0 quad "en cualquier otro caso"
  ) med med , med med forall i in {1 med , . . . med , med m} med med forall j in {1 med , med . . . med , med m}$
]

Como podemos observar, en este caso las variables de decisión tienen mayor complejidad que en los casos anteriores dado que en este caso la asignación de un autobús a una franja también depende del taller al que pertenece la franja.

Una vez definidas nuestras variables de decisión, definimos las restricciones de nuestro problema como:

+ #strong[Un autobús solo debe estar asignado a una única franja horaria en un único taller.]
#align(center)[
$sum_(j = 1)^u sum_(k = 1)^n x_(i j k) = 1$   ,   $$$forall med i med med 1 lt.eq i lt.eq m$
]

#block[
  #set enum(numbering: "1.", start: 2)
  + #strong[Cada franja horaria de un taller debe tener como máximo un autobús asignado.]
]
#align(center)[
$sum_(i = 1)^m x_(i j k) <= 1  ,   $$$$forall med j med : med 1 lt.eq j lt.eq u$ , $$$forall med k med : med 1 lt.eq k lt.eq n$
]

#block[
  #set enum(numbering: "1.", start: 3)
  + #strong[Una franja horaria de un taller no puede ser asignada a un autobús en caso de ya estar reservada para otro uso.]
]
#align(center)[
  #quote(
    block: true,
  )[
    $x_(i j k) lt.eq med 1- o_(k j)$ $med med med med med med forall med i med : med 1 lt.eq j lt.eq m$ , $forall med j med : med 1 lt.eq j lt.eq u$ , $$$forall med k med : med 1 lt.eq k lt.eq n$
  ]
]
#block[
  #set enum(numbering: "1.", start: 4)
  + La variable $y_(i j)$ determina si #strong[para un par de autobuses ambos tienen asignadas las mismas franjas horarias] (que deben estar en talleres diferentes como se define en la primera restricción. Para ello, su #strong[definición se realizará de manera muy similar a la definición de un AND lógico], en el que acotamos inferiormente el valor de $y_(i j)$ mediante las restricciones 4.1 y 4.2 en los que forzamos a la variable a tomar el valor 0 en caso de que ambas no estén asignadas a la misma franja, y superiormente mediante 4.3 en el caso de que ambas estén asignadas a la misma franja. Por tanto, en el caso de que ambos la tengan asignada , la variable de decisión tomará el valor 1, en cualquier otro caso, la variable tomará el valor 0.
  #align(center)[
    #block[
      #set enum(numbering: "4.1.", start: 1)
      + $y_(i t) lt.eq sum_(j = 1)^u x_(i j k)$
      + $y_(i t) lt.eq sum_(j = 1)^u x_(t j k)$
      + $y_(i t) gt.eq sum_(j = 1)^u x_(i j k) + sum_(j = 1)^u x_(t j k) - 1$
    ]
  ]
]

#quote(
  block: true,
)[
  Dándose en todas las restricciones definidas en este apartado que:
  #align(center)[
    $forall i , med t med : 1 lt.eq i < t lt.eq m$ ,, $forall k med : 1 lt.eq k lt.eq n$
  ]
]

#block[
  #set enum(numbering: "1.", start: 5)
  + #strong[Todas las variables de decisión definidas deben ser binarias];.
]
#align(center)[
  $x_(i j k) med , med y_(i j med) in {0 , med 1}$
]
Dadas las restricciones especificadas, podemos definir nuestra función objetivo de la siguiente forma, que pretende #strong[minimizar el número de clientes afectados por la asignación de la misma franja horaria a los dos autobuses que tienen contratados];:
#align(center)[
  $m i n med z med = med sum_(i = 1)^m sum_(j = i + 1)^m c_(i j) dot.op med y_(i j)$ $, , med med 1 lt.eq i < j lt.eq m$
]
En el que mediante el sumatorio podemos analizar todos los pares de autobuses de la empresa de transporte sin repeticiones (ya que el segundo sumatorio garantiza que los pares que ya han sido sumados con anterioridad no se vuelvan a tener en cuenta) y, dado que la variable de decisión $y_(i j)$ es binaria y obtiene el valor 1 sólo si dos autobuses tienen asignada la misma franja horaria obtendremos el número total de clientes cuyos autobuses reservados simultáneamente tienen asignada la misma franja horaria para su revisión de averías en el taller.

= Análisis de resultados. <análisis-de-resultados.>
Para analizar los resultados obtenidos, primero relizaremos algunos casos de test que comprueban el correcto funcionamiento de nuestros modelos, también comprobaremos la variación de los modelos con respecto al número de variables y compararemos ambos modelos entre ellos. 

== Pruebas de funcionamiento para el problema 2.2.1.
En primer lugar, hemos realizado dos tests muy sencillos, cuyos resultados se pueden determinar a simple vista y que nos permiten comprobar algunas cualidades importantes del modelo diseñado:
  #set enum(numbering: "1.", start: 1)
  + En caso de haber más autobuses que franjas, algunos autobuses quedarán sin asignar, pues nos encontramos ante un problema de transporte y los valores n y m no tienen por qué ser iguales. 
  + Del mismo modo, en caso de haber más franjas que autobuses, algunas quedarán sin asignar.
  + Las soluciones óptimas son las esperadas. 

*Prueba 1:* Tomará los siguientes valores:
- n = 1 , m = 2 (1 sola franja y dos autobuses)
- $k^d$ = 1 , $k^p$ = 10
- A1 : el autobús se encuentra a 5km del taller y tiene 100 pasajeros
- A2 : el autobús se encuentra a 10km del taller y tiene 2 pasajeros
Una vez pasamos el archivo input con los datos indicados por el solver obtenemos los siguientes resultados:
- _Objective:  Total_Cost = 25 (MINimum)_
- _Rows:       4_
- _Número de variables de decisión (columns):    2_
- _x[a1,s1]=1_ ,, _x[a2,s1]=0_
Como podemos observar, ante un problema trivial se cumple que el valor de la función objetivo es correcto (pués el coste de asignación es $5·10$ y la penalización por no asignar a2 es $2·10$ que en total suman 25). Además comprobamos que ante el caso $n<m$, los resultados son los esperados, hay autobuses que se quedan sin asignar. 
\
*Prueba 2* Del mismo modo, con un segundo test trivial en el que se evalua precisamente el caso contrario (tenemos más franjas que autobuses) con los siguientes datos:
- n = 3 , m = 2 (3 franjas y dos autobuses)
- $k^d$ = 1 , $k^p$ = 10
- A1 : el autobús se encuentra a 5km del taller y tiene 100 pasajeros
- A2 : el autobús se encuentra a 10km del taller y tiene 2 pasajeros
Los resultados obtenidos son:
- _Objective:  Total_Cost = 15 (MINimum)_
- _Rows:       6_
- _Número de variables de decisión (columns):    6_ 
- x[a1,s1]=1 , x[a1,s2]=0 , x[a1,s3]=0 ,, x[a2,s1]=0 , x[a2,s2]=1 , x[a2,s3]=0

Como podemos ver, el valor de la función objetivo es  el esperado (solo se tienen en cuenta los costes de transporte ya que no hay penalizaciones de no asignación), ningún autobus es asignado a la misma franja y queda una franja sin asignar. 
\
Pese al caracter trivial de los tests, nos permiten entender correctamente el funcionamiento del modelo y confirmar aspectos claves del diseño realizado.

\
No obstante, para estudiar la variación del número de restricciones y variables de decisión en base al número de franjas y de autobuses realizaremos dos tests más complejos, y con ellos,trataremos de encontrar patrones.
\
*Prueba 3:* Este test aumentara significativamente el número de autobuses y franjas, y tomará parámetros con valores más variopintos, como son (representados como en el fichero de entrada para mayor simplicidad):

10 15

25 63

5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125, 135, 145

10, 25, 8, 40, 15, 30, 5, 35, 12, 45, 20, 50, 18, 38, 22
\
Los resultados obtenidos en este caso son:
- _Objective:  Total_Cost = 18569 (MINimum)_
- _Número de restricciones (rows):       26_
- _Número de variables de decisión (columns):    150_
- Asignaciones realizadas: [a1,s4] , [a2, s2] , [a4,s1], [a6, s3] , [a8, s6] , [a10, s5] , [a12, s7] 
En este caso ocurre un comportamiento que cabe la pena mencionar, *dado que debemos contemplar el caso en que $n < m$ y viceversa, también damos lugar a que en caso de que el coste de asignación sea mayor que la penalización queden franjas vacias y autobuses sin asignar*. Un ejemplo claro en este problema concreto es el del autobús _$a_(11)$_ , cuyo coste de asignación es $105·25=2625$ mientras que la penalización de no asignación es $20·63=1260$. De hecho, en este caso pese a haber 10 franjas disponibles, solo se realiza la asignación de 7 autobuses ya que para los demás la penalización de no asignación es considerablemente menor que el coste de asignación. 
\
Ya una vez realizados estos tres casos de estudio, podemos realizar algunas conculsiones interesantes acerca del coportamiento de las variables de decisión y las restricciones:
#set enum(numbering: "1.", start: 1)
+ *El número de variables de decisión es _n·m_* , cosa que esperabamos dado que las variables de restricción representan una matriz nxm cuyos valores representan las asignaciones realizadas.
+ *El número de restricciones a nuestro problema viene dado por a _n+m+1_*, teniendo complejidad lineal O(n+m+1). Esto, también era un resultado esperado, pues definimos una restricción que restringe la asignación única por cada franja y cada bus, más la restricción de definción del dominio (establecemos que las variables de decisión sean binarias). 
Estos resultados son interesantes, ya que pese a que el numero de variables de decisión incrementa como un producto de ambas, las restricciones aumentan como una 
suma (en comparación crecen muy lentamente).Esto es algo muy positivo, dado que *la complejidad de un problema no está tan afectada por el número de variables como por el número de restricciones* y por tanto, en nuestro problema conseguimos mantener un número de restricciones moderado pese al número de variables de decisión. Además, si nos fijamos en los tres casos presentados, observamos que para valores pequeños de n y de m el número de restricciones es mayor o igual al número de variables de decisión, pero a medida que el numero de franjas y autobuses crece, esta situación se mitiga, lo que *demuestra además que el modelo tiene una buena capacidad de escalabilidad de cara a casos complejos* con un alto número de autobuses y franjas, y por tanto de variables de decisión.

== Pruebas de funcionamiento para el problema 2.2.2.
hola