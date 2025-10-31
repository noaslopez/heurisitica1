/* Definicon de autobuses y franjas del taller */
set AUTOBUSES;
set FRANJAS;

/* Parámetros */
param Precio;
param Penalizacion;
param Distancia{AUTOBUSES};
param Pasajeros{AUTOBUSES};

/* Variable de decision */
var x{AUTOBUSES, FRANJAS}, binary;

/* Funcion objetivo */
minimize Total_Cost:
    sum{j in AUTOBUSES} ( 
        Precio * Distancia[j] * (sum{i in FRANJAS} x[j,i]) + 
        Penalizacion * Pasajeros[j] * (1 - sum{i in FRANJAS} x[j,i])
    );

/* Restricciones */
s.t. Franja_unica {i in FRANJAS}: 
	sum{j in AUTOBUSES} x[j,i] <= 1;

s.t. Autobus_unico {j in AUTOBUSES}:
    sum{i in FRANJAS} x[j,i] <= 1;


end;

