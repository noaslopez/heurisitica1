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

Por último, se presenta una sección de análisis de los resultados en la que se pretende analizar y comparar los resultados obtenidos. En este caso, realizaremos unas pruebas que nos permitan comprobar un comportamiento adecuado de los modelos diseñados en el segundo apartado. Además, después realizaremos una comparación de los resultados obtenidos y el comportamiento observado entre ambos modelos.

En definitiva, el objetivo de dicho documento es presentar y afianzar los conocimientos adquiridos en el ámbito de la programación lineal y los diferentes mecanismos de resolución de problemas de este tipo mediante la realización de ejercicios prácticos cercanos a la vida cotidiana  haciendo uso de diferentes solvers como son el _Solver de LibrOffice_ y el de _GLPK_.

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
Dado el problema presentado, se pretende #strong[minimizar la pérdida económica resultante de las averías inesperadas] que se producen al inicio del servicio, para ello, debemos minimizar el coste asociado con el desplazamiento de un autobus a su correspondiente franja del taller y la penalización resultante del efecto de aisgnar una franja a un autobus en los viajeros que lo utilizan. Para ello, haremos una modelización del problema como un problema de programación lineal.

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

En la que por cada autobús calculamos si tiene o no asignada una franja mediante el sumatorio $sum_(i = 1)^n x_(i j)$ que como se define mediante las restricciones sólo podrá tomar los valores 1 en caso de que exista una asignación para ese autobús o 0 en caso de que no tenga ninguna asignación. De la misma manera, mediante $(1 - sum_(i = 1)^n x_(i j))$ obtenemos el valor 1 si no se ha realizado una asignación y el 0 en caso de que si, pues una vez más el sumatorio se acota mediante las restricciones, y de este modo *solo añadimos el coste de penalización en caso de que no se realice ninguna asignación para el autobús y el coste de desplazamiento en caso de que se realice la asignación*.

Este problema, se trata de un *problema de asignación* dado que las asignaciones que se realizan son únicas, es decir una franja solo puede asignarse a un autobús y viceversa. Y por tanto, *cumple con la posibilidad de generar con nuestro problema un grafo bipartito de consexiones únicas y unidireccionales que caracteriza a los problemas de asignación*.

== Maximización de la satisfacción de los pasajeros. <maximización-de-la-satisfacción-de-los-pasajeros.>
Dado el mismo contexto que en los problemas anteriores relacionado con la asignación de talleres a los autobuses de una empresa de transporte. En este caso, se pretende maximizar la satisfacción de los clientes #strong[minimizando el número total de pasajeros cuyos autobuses tienen un taller asignado en la misma franja horaria];.

En este caso, la empresa dispone de u talleres donde $t_i$ es un taller cualquiera y cada taller dispone de n franjas horarias, contando todos los talleres con el mismo número de franjas horarias y siendo $s_i$ una franja cualquiera de un taller. Por último, en el problema actual debemos asignar los m autobuses que trabajan en dicha empresa a una franja horaria en el taller de tal modo que un autobús cualquiera $a_i$ solo pueda estar asignado a una franja $s_k$ de un taller $t_j$ .

Para ello, definimos el siguiente parámetro necesario para dicha resolución:

$c_(i j)$ : número de pasajeros que han contratado simultáneamente el autobús $a_i med$y el $a_j$ .

Y el siguiente parámetro $o_(i j)$ que define la disponibilidad de una franja $s_i$ en un taller $t_j$ definiéndose como:
#align(center)[
  $
  o_(i,j) <= cases(
    0 quad "si s_i de t_j está ocupada",
    1 quad "si la franja está disponible para su uso"
  ) med med , med med forall i in {1 med , . . . med , med n} med med forall j in {1 med , . . . med , med u}$
]

A continuación, definimos las variables de decisión del problema que definen las asignaciones realizadas y la coincidencia de dos autobuses en una misma franja horaria..
#align(center)[
  $
  x_(i,j,k) <= cases(
    1 quad "si a_i se asigna a s_k de t_j",
    0 quad "en cualquier otro caso"
  ) med med , med med forall i in {1 med , . .  . med , med m} med med forall j in {1 med , . . . med , med u} med med forall k in {1 med , . . . med , med n}$
]

Tambien definimos la siguiente variable auxiliar que nos servira para calular $y_(i,j)$ para definir el caso en que dos autobuses están asignados a la misma franja pero en talleres diferentes.
#align(center)[
  $
  z_(i,j,k) <= cases(
    1 quad "si a_i y a_j están asignados a la misma franja s_k",
    0 quad "en cualquier otro caso"
  ) med med , med med forall i, j in {1 med , . .  . med , med m} med med forall k in {1 med , . . . med , med n}$
]

#align(center)[
  $
  y_(i,j) <= cases(
    1 quad "si a_i y a_ tienen la misma franja asignada ",
    0 quad "en cualquier otro caso"
  ) med med , med med forall i in {1 med , . . . med , med m} med med forall j in {1 med , med . . . med , med m}$
]

Como podemos observar, en este caso las variables de decisión tienen mayor complejidad que en los casos anteriores dado que en este caso la asignación de un autobús a una franja también depende del taller al que pertenece la franja.

Además, definimos las restricciones de nuestro problema como:

+ #strong[Un autobús debe estar asignado a una única franja horaria en un único taller.] De este modo, forzamos a que todos los autobuses sean asignados. 
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
  + #strong[Una franja horaria de un taller no puede ser asignada a un autobús en caso de ya estar reservada para otro uso.] Por tanto, en caso de que $o_(i,j)$ sea 1, podemos o no asignar la franja, en caso de que sea 0, debemos forzar a que la franja no se asigne.
]
#align(center)[
  #quote(
    block: true,
  )[
    $x_(i j k) lt.eq med o_(k j)$ $med med med med med med forall med i med : med 1 lt.eq j lt.eq m$ , $forall med j med : med 1 lt.eq j lt.eq u$ , $$$forall med k med : med 1 lt.eq k lt.eq n$
  ]
]
#block[
  #set enum(numbering: "1.", start: 4)
  + La variable $z_(i j k)$ determina si #strong[para un par de autobuses ambos tienen asignadas la misma franja horaria] (que deben estar en talleres diferentes tal y como se define en la primera restricción. Para ello, su #strong[definición se realizará de manera muy similar a la definición de un AND lógico], en el que acotamos inferiormente el valor de $z_(i j k)$ mediante las restricciones 4.1 y 4.2 en los que forzamos a la variable a tomar el valor 0 en caso de que ambas no estén asignadas a la misma franja, y superiormente mediante 4.3 en el caso de que ambas estén asignadas a la misma franja. Por tanto, en el caso de que ambos la tengan asignada , la variable de decisión tomará el valor 1, en cualquier otro caso, la variable tomará el valor 0.
  #align(center)[
    #block[
      #set enum(numbering: "4.1.", start: 1)
      + $z_(i t k) lt.eq sum_(j = 1)^u x_(i j k)$
      + $z_(i t k) lt.eq sum_(j = 1)^u x_(t j k)$
      + $z_(i t k) gt.eq sum_(j = 1)^u x_(i j k) + sum_(j = 1)^u x_(t j k) - 1$
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
  #set enum(numbering: "1.", start:5)
  + Finalmente definimos *$y_(i j)$ que viene dada por la suma de todas las franjas que comparten los autobuses $a_i$ y $a_j$*. Dado el problema, solo puede tomar el valor 1 o 0, pues una franja solo puede tener asignada un autobús y viceversa. De este modo aseguramos que las condiciones se comprueban para cada franja. 
]
#align(center)[
  $y_(i j) eq sum_(k = 1)^n x_(i j k)$
]

#block[
  #set enum(numbering: "1.", start: 6)
  + #strong[Todas las variables de decisión definidas deben ser binarias];.
]
#align(center)[
  $x_(i j k) med , med z_(i j k) med, med y_(i,j) in {0 , med 1}$
]

Dadas las restricciones especificadas, podemos definir nuestra función objetivo de la siguiente forma, que pretende #strong[minimizar el número de clientes afectados por la asignación de la misma franja horaria a los dos autobuses que tienen contratados];:
#align(center)[
  $m i n med z med = med sum_(i = 1)^m sum_(j = i + 1)^m c_(i j) dot.op med y_(i j)$ $, , med med 1 lt.eq i < j lt.eq m$
]
En el que mediante el sumatorio podemos analizar todos los pares de autobuses de la empresa de transporte sin repeticiones (ya que el segundo sumatorio garantiza que los pares que ya han sido sumados con anterioridad no se vuelvan a tener en cuenta) y, dado que la variable de decisión $y_(i j)$ es binaria y obtiene el valor 1 sólo si dos autobuses tienen asignada la misma franja horaria, obtendremos el número total de clientes cuyos autobuses reservados simultáneamente tienen asignada la misma franja horaria para su revisión de averías en el taller.
\ Una vez hemos realizado todo el modelo del problema, podemos determinar claramente nos encontramos ante un *problema de asignación*, pues el problema puede representarse como un grafo bipartito en el que partiendo de los nodos de origen (autobuses) hacia los destinos (franjas de un taller) estos se conectan de manera única y unidireccional, es decir, *las asignaciones son únicas y un autobús solo puede asignarse a una franja y viceversa*. 

= Análisis de resultados. <análisis-de-resultados.>
Para analizar los resultados obtenidos, primero relizaremos algunos casos de test que comprueban el correcto funcionamiento de nuestros modelos, también comprobaremos la variación de los modelos con respecto al número de variables y compararemos ambos modelos entre ellos. 

== Pruebas de funcionamiento para el problema 2.2.1.
En primer lugar, hemos realizado dos tests muy sencillos, cuyos resultados se pueden determinar a simple vista y que nos permiten comprobar algunas cualidades importantes del modelo diseñado:
  #set enum(numbering: "1.", start: 1)
  + En caso de haber más autobuses que franjas, algunos autobuses quedarán sin asignar, pues nos encontramos ante un problema de transporte y los valores n y m no tienen por qué ser iguales. 
  + Del mismo modo, en caso de haber más franjas que autobuses, algunas quedarán sin asignar.
  + Las soluciones óptimas son las esperadas. 

*Prueba 1:* Este primer test (cuyo fichero de entrada se puede encontrar en el ficher _input1.in_) consite en comprobar un caso trivial cuyo resultado bien puede determinarse a simple vista, pero con una particularidad que nos permite comprobar un caso extremo para nuesro problema. En este caso, hay más autobuses que posibles franjas a asignar en el taller. Caso en el cual esperamos que el resultado sea perfectamente factible y que podamos encontrar una solución óptima, pero que algunos autobuses queden sin asignar a una franja. Una vez empleamos el solver, nos damos cuenta de que los resultados son los esperados y que, ante la falta de franjas suficientes, el modelo se comporta de la manera esperada, proporcionando un correcto valor para la función objetivo y dejando aquellos autobuses con mayor penalización de no asignación asignados y aquellos con mayor coste de transporte sin asignar.
\
*Prueba 2:* Del mismo modo, en el caso de un segundo test trivial(_input2.in_) que en este caso comprueba precisamente lo contario, es decir, que ante un mayor número de franjas que de autobuses todos los autobuses se asignan y quedan franjas sin asignar. Como en el caso anterior, el resultado es perfectamente factible y que simplemente las franjas sobrantes quedan sin asignar.
\
Pese al caracter trivial de los tests, nos permiten entender correctamente el funcionamiento del modelo y confirmar aspectos claves del diseño realizado.
\
*Prueba 3:* Este test aumentara significativamente el número de autobuses y franjas, y tomará parámetros con valores más variopintos que, de nuevo se pueden encontrar en el fichero de entrada _input3.in_.
En este caso, dado que el numero de sets de autobuses y franjas es considerablemente mayor, ocurre un comportamiento que cabe la pena mencionar, *dado que debemos contemplar el caso en que $n < m$ y viceversa, también damos lugar a que en caso de que el coste de asignación sea mayor que la penalización queden franjas vacias y autobuses sin asignar*. Un ejemplo claro en este problema concreto es el del autobús _$a_(11)$_ , cuyo coste de asignación es $105·25=2625$ mientras que la penalización de no asignación es $20·63=1260$. De hecho, en este caso pese a haber 10 franjas disponibles, solo se realiza la asignación de 7 autobuses ya que para los demás la penalización de no asignación es considerablemente menor que el coste de asignación, de este modo obtenemos muy buenos resultados para nuestra función objetivo pero, a cambio de, pese a tener suficiente hueco para las asignaciones, dejar autobuses sin su correspondiente franja asignada.
\
Además de los tests presentados con anterioridad, se han realizado 6 tests diferentes que, mediante un aumento del número de autobuses y franjas, nos permite realizar la gráfica siguiente:
#image("/memoria/media/grafica1.png", width: 75%)
En ellos podemos observar que el numero de variables de decisión crece notablemente más lento que el número de variables de decisión. De hecho observamos que:
- *El número de variables de decisión es _n·m_*, presentando una complejidad polinómica.
- *El número de restricciones a nuestro problema viene dado por a _n+m+1_* teniendo complejidad lineal O(n+m+1). 
Estos resultados son interesantes, ya que pese a que el numero de variables de decisión incrementa como un producto de ambas, las restricciones aumentan como una 
suma (en comparación crecen muy lentamente).Esto es algo muy positivo, dado que *la complejidad de un problema no está tan afectada por el número de variables como por el número de restricciones* y por tanto, en nuestro problema conseguimos mantener un número de restricciones moderado pese al número de variables de decisión. De este modo, el modelo *demuestra además una buena capacidad de escalabilidad de cara a casos complejos* con un alto número de autobuses y franjas, y por tanto de variables de decisión. Cabe también destacar que el tiempo de ejecución del problema ha sido minúsculo (con un máximo de 3 segundos en el último caso).

== Pruebas de funcionamiento para el problema 2.2.2.
En este caso, del mismo modo que en el anterior, hemos realizado tres pruebas que nos permiten comprobar algunos casos críticos a los que se puede encontrar el solver. 

*Prueba 1:* En este caso probaremos que una de la restricciones más significativas del problema, que todos los autobuses deben tener asignada una franja en un taller.Para ello, hemos generado un test con valores de entrada que fuerzan que no todos los autobuses definidos se puedan asignar: 2 talleres de 3 franjas y 2 autobuses por asignar con solo una franja de un taller disponible. 
El resultado obtenido es el siguiente:
- _Status:  INTEGER EMPTY_
- _SOLUTION IS INFEASIBLE_
Como podemos comprobar,con este caso sencillo y trivial, *en el caso de no tener franajas suficientes disponibles para los autobuses presentados, el problema es infactible*, y así lo identifica el solver.

*Prueba 2:* Realizamos otro problema verdaderamente trivial que se puede resolver a simple vista y que nos permite ver claramente que la asignación de franjas es funcional. En este caso, forzamos que al menos dos autobuses compartan franja. Para ello introducimos un fichero de entrada (_input21.in_) que contiene 4 autobuses y cuya distribución de franjas y talleres colapsa el acceso a dos franjas que no se pueden usar. De este modo y habiendo establecido un par de autobuses con un número de pasajeros comunes mucho menor al de los demás. De este modo podemos determinar a simple vista, el resultado se deben asignar la misma franja a este par de autobuses. \ Una vez emplemos el solver, determinamos que los resultados son los esperados. Se ha asignado la misma franja (como es evidente en talleres diferentes) a este par de autobuses ($a_(1) , a_(4)$).
Además, podemos identificar un buen comportamiento de nuestro cálculo de la función objetivo dado que *no se duplica el conteo de personas* (es decir, no estamos contando las personas afectadas tanto para el par $[a_(1), a_(4)]$ como para el par [$a_(4), a_(1)]$) si no que *las parejas coincidentes en franjas solo se tienen en cuenta una vez*.
\

*Prueba 3:* En este caso, el fichero de entrada introducido (que está disponible en el repositorio de la práctica _input23.in_) tiene unas dimensiones significativamente mayores al problema anterior En este caso, dispondremos de lo siguiente: 1O talleres de 10 franjas cada uno y 20 autobuses. 
Antes de presentar los resultados, ya notamos una primera diferencia con respecto a las pruebas anteriores: el tiempo de ejecución. *Mientras que en los casos anteriores los resultados se prducían de manera practicamente instantanea, en este caso tardan unos segundos*. 
\ En cuanto a los resultados, obtenemos los siguientes, cabe destacar el número de variables de decisión y restricciones del problema obtenidas, que son las siguientes:
- _Número de restricciones (rows):              8011_
- _Número de variables de decisión (columns):   4090_
Podemos entender el motivo del tiempo de ejecución, ya que estos ha aumentado significativamente con un aumento no tan grande de valores respecto a la prueba anterior. Esto es, tomando como referencia los autobuses (dado que son los que más afectan al número de restricciones y variables), *multiplicar por cinco el número de autobuses resulta en aproximadamente 50 veces más variables de restricción y variables de decisión*. \
Para analizar este fenómeno, como en el problema anterior, intentamos realizar 6 pruebas diferentes que nos permitieran analizar la variación del número de variables y restricciones de nuestro problema con respecto al número de franjas, talleres y autobuses. No obstante dada la complejidad y el notable incremento del tiempo de ejecución, solamente pudimos hacer las pruebas hasta llegar a los 20 autobuses, a partir de ese punto, simplemente pudimos acceder al número de variables y restricciones que s emuestran en la gráfica. La misma, dado su tamaño, se ha dividido en dos, para poder aprecar debidamente el inicio de la misma:
#figure(
  grid(
    columns: 2,
    gutter: 0.75cm,
    figure(image("/memoria/media/grafica21.png", width: 100%), caption:([Inicio gráfica])),
    figure(image("/memoria/media/grafica22.png", width: 100%), caption:([Gráfica completa])),
  )
)

Dadas las pruebas realizadas y como se puede observar en la gráfica anterior, podemos observar que en este caso, *la escalabilidad de nuestro problema no es ideal*, pues el número de variables y, más importante el número de restricciones crece de manera muy rápida (llegando a 95000 restricciones en el último caso). De hecho, como observamos en la gráfica tanto el número de variables como el de restricciones crecen de manera exponencial, no ostante, se ve que en todos los casos, el número de restricciones crece notablemente más rápido y resulta mucho más alto que el número de variables de decisión.
\ Es más, la relacciones mencionadas vienen dadas por:
- *El número de variables de decisión del problema viene dado por la expresión _m·n·u + m·m·n + m·m = m(n·u + m·n + m)_ *
- *El número de restricciones viene dado por la expresión _m·n·u·n·u + m·n·u·m + m·n·u + 3·m·m·u + m·m + 3 = m·n·u(n·u + m + 1) + m·m(3u+1) + 3_.*

== Comparativa de los resultados obtenidos en ambos. 
Mientras que en el primer modelo hemos destacado que el número de restricciones se reducía con respecto al número variables de decisión en base el problema crecía, lo opuesto sucede con el segundo problema. Es más, el crecimiento de restricciones del primer problema es lineal frente al crecimiento polinómico de este segundo modelo, cosa que se puede apreciar mejor en las gráficas presentadas con anterioridad. De este modo, concluimos que *la escalabilidad del primer problema es notablemente superior a la del segundo*. 
\ Además, se produce una *gran diferencia en el tiempo de resolución de problemas más complejos*. Mientras que en en el primero hemos consguido producir los 6 casos con hasta 50 autobuses con un tiempo de resolución máximo de 5 segundos, en el segundo problema, no conseguimos resultados para casos con más de 20 autobuses, pues ya este caso llegó a requerir aproximadamente 30 minutos.
\ Por otro lado, hay una gran diferencia respecto a los dos problemas en cuanto a la asignación se refiere. *Mientras que en el primer problema no hay ninguna restricción que nos obligue a asignar todos los autobuses*, pues en caso de que el número de franjas sea muy reducido o el coste de transporte al taller sea mayor que la penalización por los pasajeros afectados el autobus puede quedar sin asignar, y esto no genera un problema de factibilidad en nuestro problema. Es decir, *aunque algunos autobuses se queden sin asignar, el problema continua siendo factible*. Sin emabrgo, como bien hemos comprobado mediante las pruebas, en el segundo problema, *en caso de que no hya franjas suficientes para asignar a un autobús, el problema se transforma en un problema infactible*, pues todos los autobuses están obligados a tener una franja cualquiera en un taller cualquiera asignada. Lo que genera resulta ser un factor diferenciador my significativo en lo que a los problemas se refiere. 
\ 
Por último, pese a todas estas diferencias, podemos observar diferentes similitudes entre ambos problemas, aunque estas no dan pie a observaciones tan interesantes. 
#set enum(numbering: "1.", start: 1)
+ Ambos problemas presentan un crecimiento polinómico de las variables de decisión respecto al número de autobuses a asignar
+ En ambos casos hay restricciones de capacidad que dan pie a variables binarias dado que un autobus solo puede estar asignado a una franja y viceversa. 