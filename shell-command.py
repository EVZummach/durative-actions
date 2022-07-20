import sys
import argparse
import subprocess

import numpy as np
import pandas as pd

import matplotlib.pyplot as plt

from os.path import exists, join

peso_modelos = {'1':90,
               '2':130,
               '3':60,
               '4':83}

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
    global peso_modelos
    seq = []
    trocas = []
    fornos = []

    metal_forno = 0

    for (id, output) in enumerate(output_string):
        if 'empurrar' in output:
            tempo_empurrada = float(output.split('[')[-1][0:-1])
            break


    for (id, output) in enumerate(output_string):
        if ':' in output:
            time, command_aux = output.split(':')
            if 'produzir' in command_aux:
                model = command_aux.split(' modelo')[1][0]
                cycle_time = float(command_aux.split('[')[-1][0:-1]) + tempo_empurrada
                seq.append([time, model, cycle_time])

                peso = peso_modelos[model]
                metal_forno = -float(peso)
                time_forno = float(time)+float(cycle_time)
                sel_forno = command_aux.split('cap')[1][0]

                fornos.append([sel_forno, metal_forno, time_forno])

            elif 'trocar' in command_aux:
                model_from = command_aux.split(' modelo')[1][0]
                model_to = command_aux.split(' modelo')[2][0]
                tempo = float(command_aux.split('[')[-1][0:-1])
                trocas.append([model_from, model_to, tempo])

            elif 'fundir' in command_aux:
                sel_forno = command_aux.split('cap')[1][0]
                metal_forno = 200
                time_forno = float(time)+60
                fornos.append([sel_forno, metal_forno, time_forno])

    seq = np.vstack(seq)
    fornos = np.vstack(fornos)
    return seq, trocas, fornos

def count_sequence(sequence):
    model = sequence[0,1][0]
    model_sequence = []
    counter = 0
    for _, current_model, _ in sequence:
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

def fornos_report(fornos):
    df = pd.DataFrame(fornos, columns=['Forno', 'Metal', 'Timestamp'])
    df['Timestamp'] = pd.to_numeric(df['Timestamp'])
    df['Metal'] = pd.to_numeric(df['Metal'])
    df['Forno'] = pd.to_numeric(df['Forno'])

    df = df.sort_values(by='Timestamp')
    last_tp = df['Timestamp'].max()

    df = df[df['Forno']==1]

    #df_f1 = df[df['Forno']=='1']
    df['Acumulado'] = df['Metal'].expanding(min_periods=1).sum()
    plt.figure(figsize=(15, 10))
    plt.plot(df['Timestamp'], df['Acumulado'])
    plt.xlabel('Timestamp')
    plt.ylabel('Acumulado de Metal')
    plt.savefig('Vazamento.png')

    return df

if __name__ == '__main__':
    #print(sys.argv)
    PLANNER_PATH, D_PATH, P_PATH = read_input()
    planner_output = handle_planner(PLANNER_PATH, D_PATH, P_PATH)
    production_info, changes, fornos = process_output(planner_output)
    df_fornos = fornos_report(fornos)
    model_sequence = count_sequence(production_info)
    planner_cycle, true_cycle = analyze_efficiency(production_info)
    changes_time = np.vstack(changes).astype(float)[:,2]
    changes_time = np.sum(changes_time, axis=0)
    print(f'{model_sequence}\n')
    print(f'Planner production time:\t{planner_cycle:0.2f}')
    print(f'True production time:\t{true_cycle:0.2f}')
    print(f'Changes occured:\t{len(changes)}')
    print(f'Change time:\t{changes_time:0.2f}')
    print(f'Stopped time:\t{planner_cycle-true_cycle-changes_time:0.2f}')

    #print(production_info)
