import os, argparse
from collections import defaultdict

intValues = [
    "RunTime(ms)",
    "Count",
    "Time(ms)",
    "MinLatency(us)",
    "MaxLatency(us)",
    "95thPercentileLatency(us)",
    "99thPercentileLatency(us)",
    "Return=OK",
    "Operations"
]

def parseFile(filePath: str):
    with open(filePath) as file:
        lines = file.readlines()

    resultDict = dict()
    for l in lines:
        # Split the line into key, unit, value
        splits = l.strip().split(',')

        # Split line into parts and remove unnecessary whitespace
        try:
            key = splits[0].strip()
            # Get text between brackets
            key = key[key.find("[")+1:key.find("]")]
            unit = splits[1].strip()
            value = float(splits[2].strip())
        except IndexError as e:
            print(filePath)
            raise e

        if key not in resultDict:
            resultDict[key] = {}
        resultDict[key][unit] = value
            
    return resultDict

def calculateAverage(files: list, resultPath: str):
    # If no files where provided exit
    if not files:
        print("No files found")
        return
        # Filename for details is: resultpath_details.csv
    detailsFileName = resultPath.replace('.log', '_details.log')
    # Empty file content
    open(detailsFileName, 'w').close()

    avgDict = defaultdict(lambda: defaultdict(str)) 
    for f in files:
        res = parseFile(f)

        for key, valueDict in res.items():
            # Create a new empty dict, if key not present yet
             for unit, value in valueDict.items():
                if unit not in avgDict[key]:
                    avgDict[key][unit] = 0 
                avgDict[key][unit] += value 

        # Read file and append to details file
        file = open(f, "r")
        file.seek(0)
        content = file.read()
        filename=os.path.basename(f)
        # Write file to summary file
        with open(detailsFileName, 'a') as detailsFile:
            detailsFile.write("{}\n".format(filename))
            detailsFile.write(content)

        file.close()
        os.remove(f)
                

    # For all values of one section
    # Devide the sum of all values (unit : sumValue) by the number of files taken into consideration
    with open(resultPath, 'w', newline='') as avgfile:
        for op, valueDict in avgDict.items():
            for unit, value in valueDict.items():
                if unit in intValues:
                    avgfile.write("[{}], {}, {:.0f}\n".format(op, unit, value/len(files)))
                else:
                    avgfile.write("[{}], {}, {:.6f}\n".format(op, unit, value/len(files)))

    return avgDict


def main():
    parser = argparse.ArgumentParser(description='Writes all files into one file by calculating the average off all values')

    optional = parser._action_groups.pop()
    requiredGroup = parser.add_argument_group("required named arguments")

    requiredGroup.add_argument("-f","--files", required=True, dest="files", type=str, nargs='+', metavar="FILES",
                help="List of files for which the average values should be calculated")
    requiredGroup.add_argument("-r","--result", required=True, dest="resultFilename", type=str, metavar="FILENAME",
                help="Filename for the result of the calculated average file")

    parser._action_groups.append(optional) # Make sure optional is last
    args = parser.parse_args()

    calculateAverage(args.files, args.resultFilename)


if __name__ == '__main__':
    main()