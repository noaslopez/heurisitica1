#!env python3
import re
import sys
import os
import subprocess

def parse_input(filename):
    with open(filename, 'r') as f:
        content = f.read().strip()
    
    pattern = r'^\s*(?P<n>\d+)\s+(?P<m>\d+)\s*[\r\n]+\s*(?P<kd>[\d.]+)\s+(?P<kp>[\d.]+)\s*[\r\n]+\s*(?P<distancias>[\d.,]+)\s*[\r\n]+\s*(?P<pasajeros>[\d,]+)\s*$'
    
    match = re.match(pattern, content, re.MULTILINE | re.DOTALL)
    if not match:
        raise ValueError("Input file format is incorrect")
    
    n = int(match.group('n'))
    m = int(match.group('m'))
    kd = float(match.group('kd'))
    kp = float(match.group('kp'))
    
    distancias = list(map(float, re.findall(r'[\d.]+', match.group('distancias'))))
    pasajeros = list(map(int, re.findall(r'\d+', match.group('pasajeros'))))
    
    if len(distancias) != m or len(pasajeros) != m:
        raise ValueError(f"Count mismatch: expected {m} items")

    data = {
        'n': n,
        'm': m,
        'kd': kd,
        'kp': kp,
        'distancias': distancias,
        'pasajeros': pasajeros
    }
    
    return data

def generate_dat(data, output_file):
    with open(output_file, 'w') as f:
        f.write("set AUTOBUSES :=")
        for i in range(1, data['m'] + 1):
            f.write(f" a{i}")
        f.write(";\n\n")
        
        f.write("set FRANJAS :=")
        for j in range(1, data['n'] + 1):
            f.write(f" s{j}")
        f.write(";\n\n")
        
        # Parameters
        f.write(f"param Precio := {data['kd']};\n")
        f.write(f"param Penalizacion := {data['kp']};\n\n")
        
        f.write("param Distancia :=\n")
        for i, d in enumerate(data['distancias'], 1):
            f.write(f"a{i} {d}\n")
        f.write(";\n\n")
        
        f.write("param Pasajeros :=\n")
        for i, p in enumerate(data['pasajeros'], 1):
            f.write(f"a{i} {p}\n")
        f.write(";\n\n")
        f.write("end;\n")

def solve_with_glpk(dat_file):
    s = subprocess.check_call(f"glpsol -m problema1.mod -d {dat_file}",
                              shell=True,
                              stdout=subprocess.DEVNULL,
                              stderr=subprocess.STDOUT)
def print_result(output_file):
    #unfeasible
    #unfound

ass

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

    # print_result('output.out')

if __name__ == "__main__":
    main()
