#!/usr/bin/env python3 
import re
import sys
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
    # s = subprocess.check_call(f"glpsol -m parte-2-1.mod -d {dat_file} -o output.out",
    #                           shell=True,
    #                           stdout=subprocess.DEVNULL,
    #                           stderr=subprocess.STDOUT)
    subprocess.run(["glpsol", "-m", "parte-2-1.mod", "-d", dat_file, "-o", "output.out"], capture_output=True)

def obtain_result(output_file):
    with open(output_file, 'r') as f:
        content = f.read().strip()

    basic_info = re.search(
        r"Rows:\s*(?P<constraints>\d+).*?Columns:\s*(?P<variables>\d+).*?Objective:\s*(?P<function>\w+)\s*=\s*(?P<value>[\d.-]+)",
        content, re.DOTALL
    )
    
    # Extract assignments as raw tuples
    raw_assignments = re.findall(r"x\[(\w+),(\w+)\]\s*\*\s*1", content)
    
    # All unique buses
    all_buses = set(re.findall(r"x\[(\w+),", content))
    
    # Assigned buses
    assigned_buses = {bus for bus, slot in raw_assignments}
    
    # Unassigned buses
    unassigned_buses = all_buses - assigned_buses
    
    return {
        'optimal_value': basic_info.group('value') if basic_info else None,
        'num_variables': basic_info.group('variables') if basic_info else None,
        'num_constraints': basic_info.group('constraints') if basic_info else None,
        'raw_assignments': raw_assignments,  # Raw data for printing
        'assignments': [f"Autobús {bus} → Franja {slot}" for bus, slot in raw_assignments],
        'raw_unassigned': list(unassigned_buses),  # Raw data for printing
        'unassigned': [f"Autobús {bus} no asignado" for bus in unassigned_buses]
    }

def print_result(result_dict):
    #unfeasible
    #unfound
    
    print(f"Valor óptimo: {result_dict['optimal_value']} | N variables: {result_dict['num_variables']} | N restricciones: {result_dict['num_constraints']}")
    
    # Print assignments (if stored as raw pairs)
    if 'raw_assignments' in result_dict:
        for bus, slot in result_dict['raw_assignments']:
            print(f"{bus} {slot}")
    else:
        # Fallback: parse from formatted strings
        for assignment in result_dict['assignments']:
            bus = assignment.split()[1]  # Get "a1" from "Autobús a1 → Franja s1"
            slot = assignment.split()[4] # Get "s1" from "Autobús a1 → Franja s1"
            print(f"{bus} {slot}")
    
    # Print unassigned buses
    for unassigned in result_dict['unassigned']:
        bus = unassigned.split()[1]  # Get "a2" from "Autobús a2 no asignado"
        print(f"{bus} (no asignado)")
    

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

    res = obtain_result("output.out")

    print_result(res)

if __name__ == "__main__":
    main()
