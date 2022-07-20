import sys
import argparse
import subprocess

import numpy as np

from os.path import exists, join

def read_input():
    parser = argparse.ArgumentParser(prog='IA', description='Runs domain and problem with the OPTIC-CLP planner for the AI work. This work plans an optimal sequence of production in a foundry. The parameters must be set in the problem.pddl file.')
    parser.add_argument('-p', help='Path of OPTIC-CLP planner.', type=str)
    parser.add_argument('-f', help='Path of domain.pddl and problem.pddl files. Both files must exist in this path and should be named as domain and problem, respectively.', type=str)

    args = parser.parse_args()

    error = False
    if not args.p:
        print('Must enter planner path!')
        error = True
    if not args.f:
        print('Must enter files path!')
        error = True

    if error:
        parser.print_help()
        sys.exit()

    error = False
    if not exists(args.p):
        print('Invalid planner path!')
        error = True
    if not exists(join(args.f, 'domain.pddl')) or not exists(join(args.f, 'problem.pddl')):
        print('Invalid files path!')
        error = True

    if error:
        parser.print_help()
        sys.exit()

    return join('.', args.p), join(args.f, 'domain.pddl'), join(args.f, 'problem.pddl')

def handle_planner(PLANNER, DOMAIN, PROBLEM):
    result = subprocess.run([PLANNER, DOMAIN, PROBLEM], stdout=subprocess.PIPE)
    shell_output = result.stdout.decode()
    shell_output_list =shell_output.split('\n')
    output_index = shell_output_list.index('Problem Unsolvable')+5
    output_sequence = shell_output_list[output_index:]
    return output_sequence

def process_output(output_string):
    seq = []
    for (id, output) in enumerate(output_string):
        if ':' in output:
            time, command_aux = output.split(':')
            if 'produzir' in command_aux:
                model = command_aux.split(' modelo')[1][0]
                cycle_time = command_aux.split('[')[-1][0:-1]
                seq.append([time, model, cycle_time])
    seq = np.vstack(seq)
    return seq

def count_sequence(sequence):
    model = sequence[0]
    model_sequence = []
    counter = 0
    for current_model in sequence:
        if model != current_model:
            model_sequence.append(f'Produzir {counter} peças do modelo {model}')
            counter = 1
            model = current_model
        else:
            counter += 1

    model_sequence.append(f'Produzir {counter} peças do modelo {model}')

    model_sequence = np.vstack(model_sequence)
    return model_sequence

def analyze_efficiency(sequence):
    planner_cycle = sequence[:,0][-1].astype(float)
    true_cycle = np.sum(sequence[:,2].astype(float), axis=0)
    return planner_cycle, true_cycle

if __name__ == '__main__':
    #print(sys.argv)
    PLANNER_PATH, D_PATH, P_PATH = read_input()
    planner_output = handle_planner(PLANNER_PATH, D_PATH, P_PATH)
    production_info = process_output(planner_output)
    model_sequence = count_sequence(production_info[:,1])
    planner_cycle, true_cycle = analyze_efficiency(production_info)

    print(f'{model_sequence}\n')
    print(f'Planner production time:{planner_cycle:%0.2f}')
    print(f'True production time:{true_cycle}')
    print(f'Stopped time:{planner_cycle-true_cycle}')
    #print(production_info)
