import sys
import argparse
import subprocess

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


if __name__ == '__main__':
    #print(sys.argv)
    PLANNER_PATH, D_PATH, P_PATH = read_input()
    result = subprocess.run([PLANNER_PATH, D_PATH, P_PATH], stdout=subprocess.PIPE)
    print(result.stdout.decode())
