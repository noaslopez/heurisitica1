set AUTOBUSES;
set FRANJAS;

param Precio;
param Penalizacion;
param Distancia{AUTOBUSES};
param Pasajeros{AUTOBUSES};

var x{AUTOBUSES, FRANJAS}, binary;

minimize Total_Cost:
    sum{j in AUTOBUSES} ( 
    Precio * Distancia[j] * (sum{i in FRANJAS} x[j,i]) + 
        Penalizacion * Pasajeros[j] * (1 - sum{i in FRANJAS} x[j,i])
    );

subject to Franja_unica {i in FRANJAS}: 
	sum{j in AUTOBUSES} x[j,i] <= 1;

subject to Autobus_unico {j in AUTOBUSES}:
    sum{i in FRANJAS} x[j,i] <= 1;

end;
