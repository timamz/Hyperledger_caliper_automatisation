import sys
import json
import os

def create_output_file(path, param_name):
    with open(path, 'w') as table:
        table.write(f'{param_name},Succ,Fail,Send rate,Max latency,Min Latency,Avg Latency,Throughput\n')


def add_field(param_name, key, values):
    with open('parameters.json', 'r') as parameters:
        data = json.load(parameters)
    
    path_to_output = f'/Users/timopheymazurenko/projects/course_work_2/automatisation/benchmark_result/{param_name}_reports.csv'
    
    data[param_name] = {
        "key": key,
        "values": values,
        "path_to_output": path_to_output
    }

    with open('parameters.json', 'w') as file:
        json.dump(data, file, indent=4)

    create_output_file(path_to_output, param_name)

    print(f'{param_name} is added successfully')


def delete_field(param_name):
    with open('parameters.json', 'r') as parameters:
        data = json.load(parameters)

    if param_name not in data:
        print(f'There is no parameter with name {param_name} in json')
        return

    path = data[param_name]['path_to_output']
    os.remove(path)
    
    del data[param_name]

    with open('parameters.json', 'w') as file:
        json.dump(data, file, indent=4)

    print(f'{param_name} is deleted successfully')


if __name__ == "__main__":
    cmd = sys.argv[1]

    if cmd == 'del':
        delete_field(input('Input name of parameter to delete: '))
    elif cmd == 'add': 
        param_name = input('Input name of parameter to add: ')
        key = input('Enter key of parameter: ')
        values = list(map(int, input('Enter list of values to test: ').split()))
        add_field(param_name, key, values)
    else:
        print('Invalid command')