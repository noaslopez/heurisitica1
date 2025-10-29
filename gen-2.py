#!/usr/bin/env python3 
import re
import sys
import os
import subprocess

def parse_input(filename):
    with open(filename, 'r') as f:
        content = f.read().strip()
    
    # Split into lines and clean up
    lines = [line.strip() for line in content.split('\n') if line.strip()]
    
    # Parse first line: n m u
    first_line = lines[0].split()
    if len(first_line) != 3:
        raise ValueError("First line must contain exactly 3 numbers: n m u")
    
    n = int(first_line[0]) # numero de franjas
    m = int(first_line[1]) # numero de buses
    u = int(first_line[2]) # numero de talleres
    
    # Parse cost matrix (m x m) - matriz de autobuses x autobuses
    cost_matrix = []
    for i in range(1, 1 + m):
        if i >= len(lines):
            raise ValueError(f"Expected {m} rows for cost matrix, but got only {i-1}")
        row = list(map(float, lines[i].split()))
        if len(row) != m:
            raise ValueError(f"Row {i} of cost matrix has {len(row)} elements, expected {m}")
        cost_matrix.append(row)
    
    # Parse capacity matrix (n x u) - matriz de franjas x talleres
    capacity_matrix = []
    for i in range(1 + m, 1 + m + n):
        if i >= len(lines):
            raise ValueError(f"Expected {n} rows for capacity matrix, but got only {i-1-m}")
        row = list(map(float, lines[i].split()))
        if len(row) != u:
            raise ValueError(f"Row {i-m} of capacity matrix has {len(row)} elements, expected {u}")
        capacity_matrix.append(row)
    
    data = {
        'n': n,
        'm': m,
        'u': u,
        'coincidentes': cost_matrix,
        'disponibles': capacity_matrix
    }
    
    return data

def generate_dat(data, output_file):
    with open(output_file, 'w') as f:
        # Sets (mantener igual)
        f.write("set AUTOBUSES :=")
        for i in range(1, data['m'] + 1):
            f.write(f" a{i}")
        f.write(";\n\n")
        
        f.write("set TALLERES :=")
        for j in range(1, data['u'] + 1):
            f.write(f" t{j}")
        f.write(";\n\n")
        
        f.write("set FRANJAS :=")
        for k in range(1, data['n'] + 1):
            f.write(f" f{k}")
        f.write(";\n\n")
        
        # Cost matrix (mantener igual)
        f.write("param c :")
        for j in range(1, data['m'] + 1):
            f.write(f" a{j}")
        f.write(" :=\n")
        
        for i in range(data['m']):
            f.write(f"a{i+1}")
            for j in range(data['m']):
                f.write(f" {data['coincidentes'][i][j]}")
            f.write("\n")
        f.write(";\n\n")

        # Capacity matrix - CORREGIR ESTA PARTE
        f.write("param o :")
        for j in range(1, data['u'] + 1):  # Talleres como columnas
            f.write(f" t{j}")
        f.write(" :=\n")
        
        for i in range(data['n']):  # Franjas como filas
            f.write(f"f{i+1}")
            for j in range(data['u']):
                f.write(f" {data['disponibles'][i][j]}")
            f.write("\n")
        f.write(";\n\n")
        
        f.write("end;\n")
        

def solve_with_glpk(dat_file):
    # glpsol -m model.mod -d data.dat -o output.txt según el manual del profe 
    s = subprocess.check_call(f"glpsol -m parte-2-2.mod -d {dat_file} -o output.out",
                              shell=True,
                              stdout=subprocess.DEVNULL,
                              stderr=subprocess.STDOUT)

def print_result(output_file):
    pass

def main():
    # Check if correct number of arguments provided
    if len(sys.argv) != 3:
        print("Usage: python gen-1.py <input-file> <output-file>")
        print(f"Received {len(sys.argv)-1} arguments: {sys.argv[1:]}")
        sys.exit(1)
    
    input_file = sys.argv[1]
    dat_file = sys.argv[2]
    
    data = parse_input(input_file)

    generate_dat(data, dat_file)
    solve_with_glpk(dat_file)

if __name__ == "__main__":
    main()