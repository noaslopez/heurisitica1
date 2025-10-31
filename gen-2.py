#!/usr/bin/env python3 
import re
import sys
import os
import subprocess

def parse_input(filename):
    """
    Parses the file by applying three separate regex validation steps.
    """
    with open(filename, 'r') as f:
        content = f.read().strip()

    lines = [line for line in content.strip().splitlines() if line]
    if not lines:
        raise ValueError("File content is empty.")

    # --- 1. Apply Header Regex ---
    header_pattern = r"^(?P<n>\d+)\s+(?P<m>\d+)\s+(?P<u>\d+)\s*$"
    header_match = re.match(header_pattern, lines[0])
    if not header_match:
        raise ValueError("Invalid header format.")
    
    n, m, u = [int(g) for g in header_match.groups()]

    # Check if there are enough lines in the file
    if len(lines) < 1 + n + u:
        raise ValueError(f"Insufficient lines. Header expects {n}+{u} matrix lines, but only {len(lines)-1} found.")

    # --- 2. Apply First Matrix Regex ---
    # Dynamically build the regex for a row with 'm' columns
    row_pattern_m = re.compile(f"^(?:\\d+\\s+){{{m - 1}}}\\d+\\s*$")
    
    matrix = []
    matrix_lines = lines[1 : n]
 
    for i, line in enumerate(matrix_lines):
        if not row_pattern_m.match(line):
            raise ValueError(f"First matrix format error on row {i+1}: Expected {m} columns.")
        matrix.append([int(num) for num in line.split()])

    # --- 3. Apply Cost Matrix Regex ---
    # Dynamically build the regex for a row with 'u' columns
    row_pattern_u = re.compile(f"^(?:\\d+\\s+){{{u - 1}}}\\d+\\s*$")

    cost_matrix = []
    cost_matrix_lines = lines[ n : 1 + n + m]

    for i, line in enumerate(cost_matrix_lines):
        if not row_pattern_u.match(line):
            raise ValueError(f"Cost matrix format error on row {i+1}: Expected {u} columns.")
        cost_matrix.append([int(num) for num in line.split()])

    return {
        'header': (n, m, u),
        'matrix': matrix,
        'cost_matrix': cost_matrix
    }
def generate_dat(data, output_file):
    """
    Generates a .dat file based on the parsed data structure with corrected
    matrix dimensions (m x m and u x n).
    """
    n, m, u = data['header']

    # Your original code used 'coincidentes' for the m x m matrix
    # and 'disponibles' for what seems to be the u x n matrix.
    # We will map our parser output to that logic.
    coincidentes = data['matrix']       # The m x m matrix
    disponibles = data['cost_matrix']   # The u x n matrix

    with open(output_file, 'w') as f:
        # Sets (AUTOBUSES=m, TALLERES=u, FRANJAS=n)
        f.write("set AUTOBUSES :=")
        for i in range(1, m + 1):
            f.write(f" a{i}")
        f.write(";\n\n")
        
        f.write("set TALLERES :=")
        for j in range(1, u + 1):
            f.write(f" t{j}")
        f.write(";\n\n")
        
        f.write("set FRANJAS :=")
        for k in range(1, n + 1):
            f.write(f" f{k}")
        f.write(";\n\n")
        
        # --- Parameters ---

        # param c (the symmetrical m x m matrix)
        f.write("param c :")
        for j in range(1, m + 1): # m columns: a1, a2, ...
            f.write(f" a{j}")
        f.write(" :=\n")
        
        for i in range(m): # m rows: a1, a2, ...
            f.write(f"a{i+1}")
            for j in range(m):
                # This loop now correctly iterates from 0 to m-1
                f.write(f" {coincidentes[i][j]}")
            f.write("\n")
        f.write(";\n\n")

        # param o (the u x n cost matrix)
        # This seems to map Talleres (u) to Franjas (n)
        f.write("param o :")
        for j in range(1, u + 1):  # n columns: f1, f2, ...
            f.write(f" t{j}")
        f.write(" :=\n")
        
 
        for i in range(n):  # u rows: t1, t2, ...
            f.write(f"f{i+1}")
            for j in range(u):
                # This loop now correctly iterates from 0 to u-1 and 0 to n-1
                f.write(f" {disponibles[i][j]}")
            f.write("\n")
        f.write(";\n\n")
        f.write("end;\n")
 

def solve_with_glpk(dat_file):
    # s = subprocess.check_call(f"glpsol -m parte-2-1.mod -d {dat_file} -o output.out",
    #                           shell=True,
    #                           stdout=subprocess.DEVNULL,
    #                           stderr=subprocess.STDOUT)
    subprocess.run(["glpsol", "-m", "parte-2-2.mod", "-d", dat_file, "-o", "output.out"], capture_output=True)


def obtain_result(output_file):
    """
    Parses the GLPK solver output to extract the optimal solution details
    using regular expressions.
    """
    with open(output_file, 'r') as f:
        content = f.read()

    # --- 1. Regex for the Header Information ---
    # This pattern captures the main summary block.
    basic_info_pattern = r"Rows:\s+(?P<constraints>\d+).*?Columns:\s+(?P<variables>\d+).*?Objective:\s+\w+\s+=\s+(?P<value>[\d\.\-e+]+)"
    basic_info = re.search(basic_info_pattern, content, re.DOTALL)

    # --- 2. Regex for the Optimal Solution (Variable Assignments) ---
    # This pattern finds all lines for the 'x' variable where the Activity is 1.
    # It looks for lines starting with a number, 'x[...]', '*', and then a '1'.
    assignments_pattern = r"^\s*\d+\s+x\[(?P<bus>\w+),(?P<taller>\w+),(?P<franja>\w+)\]\s+\*\s+1"
    
    # We use re.MULTILINE to make '^' match the start of each line.
    raw_assignments = re.findall(assignments_pattern, content, re.MULTILINE)

    # If the solver output indicates the problem is infeasible or has no solution
    is_infeasible = re.search(r"Status:\s+INTEGER NO-FEASIBLE", content)
    is_unfound = re.search(r"SOLUTION IS UNDEFINED", content)
    
    if is_infeasible:
        return {'status': 'Infeasible'}
    if is_unfound:
        return {'status': 'Unfound'}

    return {
        'status': 'Optimal',
        'optimal_value': basic_info.group('value') if basic_info else "No encontrado",
        'num_variables': basic_info.group('variables') if basic_info else "No encontrado",
        'num_constraints': basic_info.group('constraints') if basic_info else "No encontrado",
        'assignments': raw_assignments # A list of (bus, taller, franja) tuples
    }


def print_result(result_dict):
    """
    Prints the parsed result in the specified legible format.
    """
    if result_dict.get('status') == 'Infeasible':
        print("El problema es infactible y no tiene solución.")
        return
    if result_dict.get('status') == 'Unfound':
        print("No se encontró una solución óptima.")
        return

    print(f"Valor óptimo de la función objetivo: {result_dict['optimal_value']}")
    print(f"Número de variables de decisión: {result_dict['num_variables']}")
    print(f"Número de restricciones totales: {result_dict['num_constraints']}\n")
    
    print("--- Solución Óptima Calculada ---")
    if result_dict['assignments']:
        for bus, taller, franja in result_dict['assignments']:
            print(f"Autobús {bus} se asigna a la franja {franja} del taller {taller}")
    else:
        print("No se encontraron asignaciones en la solución.")
def main():
    # Check if correct number of arguments provided
    if len(sys.argv) != 3:
        print("Usage: python gen-1.py <input-file> <output-file>")
        print(f"Received {len(sys.argv)-1} arguments: {sys.argv[1:]}")
        sys.exit(1)
    
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    data = parse_input(input_file)


    generate_dat(data, "data.dat")
    solve_with_glpk("data.dat")

    res = obtain_result("output.out")

    print_result(res)

if __name__ == "__main__":
    main()
