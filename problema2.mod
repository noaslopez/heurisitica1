set AUTOBUSES;
set TALLERES;
set FRANJAS;

param c{AUTOBUSES, AUTOBUSES};
param o{FRANJAS, TALLERES}, binary;

var x{AUTOBUSES, TALLERES, FRANJAS}, binary;
var y{AUTOBUSES, AUTOBUSES}, binary;

minimize Pasajeros_afectados: sum{i in AUTOBUSES, j in AUTOBUSES: i < j} c[i,j] * y[i,j];

subject to Asignacion_bus {i in AUTOBUSES}: sum{j in TALLERES, k in FRANJAS} x[i,j,k] = 1;
subject to Franja_unica {j in TALLERES, k in FRANJAS}: sum{i in AUTOBUSES} x[i,j,k] = 1;
subject to Franja_reservada {i in AUTOBUSES, j in TALLERES, k in FRANJAS}: x[i,j,k] <= 1 - o[k,j];
subject to Definicion_y_i {i in AUTOBUSES, t in AUTOBUSES, k in FRANJAS: i!=t}: y[i,t] <= sum{j in TALLERES} x[i,j,k];
subject to Dfinicion_y_t {i in AUTOBUSES, t in AUTOBUSES, k in FRANJAS i!=t}: y[i,t] <= sum{j in TALLERES} x[t,j,k];
subject to Asegurar_ambas {i in AUTOBUSES, t in AUTOBUSES, k in FRANJAS: i!=t}: y[i,t] >= sum{j in TALLERES} x[i,j,k] + sum{j in TALLERES} x[i,j,k]-1;

end;
