import yaml
import sys

def change_BatchSize(value):
    with open('/Users/timopheymazurenko/projects/course_work_2/fabric/sampleconfig/core.yaml', 'r') as file:
        content = yaml.safe_load(file)

    content['peer']['gossip']['state']['batchSize'] = value

    with open('/Users/timopheymazurenko/projects/course_work_2/fabric/sampleconfig/core.yaml', 'w') as file:
        yaml.dump(content, file)


if __name__ == "__main__":
    value = int(sys.argv[1])
    change_BatchSize(value)
    print('Editing is done successfully')