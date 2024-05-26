from bs4 import BeautifulSoup
import csv
import sys


def parse_results(parameter_value, output_path):
    with open('/Users/timopheymazurenko/projects/course_work_2/HLC_automatisation/report.html') as report:
        good_soup = BeautifulSoup(report, 'html.parser')

    row = good_soup.find('td', string='readAsset').find_parent('tr')
    data = [td.text for td in row.find_all('td')][1:]

    row = [parameter_value]
    row += data

    with open(output_path, 'a') as table:
        writer = csv.writer(table)
        writer.writerow(row)


if __name__ == "__main__":
    value = int(sys.argv[1])
    path = str(sys.argv[2])
    parse_results(value, path)

    print('---------------------------------------')
    print('Adding report data is done successfully')
    print('---------------------------------------')
