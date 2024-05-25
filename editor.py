import yaml
import sys

def edit(value, key):
    with open('/Users/timopheymazurenko/projects/course_work_2/fabric/sampleconfig/core.yaml', 'r') as file:
        content = yaml.safe_load(file)

    keys = key.split('.')
    d = content
    for k in keys[:-1]:
        d = d.setdefault(k, {})

    d[keys[-1]] = value

    with open('/Users/timopheymazurenko/projects/course_work_2/fabric/sampleconfig/core.yaml', 'w') as file:
        yaml.dump(content, file)


if __name__ == "__main__":
    value = int(sys.argv[1])
    key = sys.argv[2]
    edit(value, key)

    print('----------------------------')
    print('Editing is done successfully')
    print('----------------------------')
