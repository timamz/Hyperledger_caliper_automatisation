from bs4 import BeautifulSoup
import csv
import yaml


with open('/Users/timopheymazurenko/projects/course_work_2/automatisation/report.html') as report:
    good_soup = BeautifulSoup(report, 'html.parser')

row = good_soup.find('td', string='readAsset').find_parent('tr')
data = [td.text for td in row.find_all('td')][1:]

with open('/Users/timopheymazurenko/projects/course_work_2/fabric/sampleconfig/core.yaml', 'r') as file:
    content = yaml.safe_load(file)

batchSize_value = content['peer']['gossip']['state']['batchSize']
row = [batchSize_value]
row += data

with open('reports.csv', 'a') as table:
    writer = csv.writer(table)
    writer.writerow(row)

print('adding report data is done successfully')