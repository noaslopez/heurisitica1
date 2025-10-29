/* Definicion de autobuses, talleres y sus respectivas franjas */
set AUTOBUSES;
set TALLERES;
set FRANJAS;

/* Parametros */
param c{AUTOBUSES, AUTOBUSES};
param o{FRANJAS, TALLERES}, binary;

/* Variables de decision */
var x{AUTOBUSES, TALLERES, FRANJAS}, binary;
var y{AUTOBUSES, AUTOBUSES}, binary;
 
/* Función objetivo */
minimize Pasajeros_afectados: 
    sum{i in AUTOBUSES, j in AUTOBUSES: i < j} c[i,j] * y[i,j];

/* Restricciones */
s.t. Asignacion_bus {i in AUTOBUSES}: 
    sum{j in TALLERES, k in FRANJAS} x[i,j,k] = 1;

s.t. Franja_unica {j in TALLERES, k in FRANJAS}: 
    sum{i in AUTOBUSES} x[i,j,k] <= 1;

s.t. Franja_reservada {i in AUTOBUSES, j in TALLERES, k in FRANJAS}: 
    x[i,j,k] <= 1 - o[k,j];

s.t. Definicion_y_i {i in AUTOBUSES, t in AUTOBUSES, k in FRANJAS: i<t}: 
    y[i,t] <= sum{j in TALLERES} x[i,j,k];

s.t. Definicion_y_t {i in AUTOBUSES, t in AUTOBUSES, k in FRANJAS i<t}: 
    y[i,t] <= sum{j in TALLERES} x[t,j,k];

s.t. Asegurar_ambas {i in AUTOBUSES, t in AUTOBUSES, k in FRANJAS: i<t}: 
    y[i,t] >= sum{j in TALLERES} x[i,j,k] + sum{j in TALLERES} x[i,j,k]-1;

end;
