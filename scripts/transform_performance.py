import sys
import glob
from os import listdir


class Transformer:
    """
    Consolidates raw performance benchmark results into one CSV file suitable for processing in R

    The transformation includes generating nicer names for providers (e.g., alibaba to AliBaba) and operation names
    (e.g., create to OP1 - Create)

    CLI parameters are: directory containing the result files and target file
    """
    OPERATIONS = {
                  "retrieve": "OP1 - Retrieve",
                  "retrieve-all": "OP2 - Retrieve all",
                  }

    def __init__(self, directory, target):
        self.directory = directory
        self.target = target

    def transform(self):
        out = open(self.target, 'w')
        out.write('operation,provider,time,time_s\n')
        out.close()
        for operation_path in Transformer.OPERATIONS.keys():
            file_paths = glob.glob(f"{self.directory}/jopa-benchmark*_{operation_path}.data")
            for file_path in file_paths:
                print(file_path)
                self.transform_file(file_path)
        print("Data written into file " + str(self.target))

    def transform_file(self, file_path):
        path = str(self.directory)
        if not path.endswith('/'):
            path += '/'
        file = open(file_path, 'r')
        out = open(self.target, 'a')
        operation = Transformer.resolve_operation_name(file_path.split('_')[1].replace(".data", ""))
        provider = "Read-only" if "read-only" in file_path.split('_')[0] else "Read-write"

        i = 0
        for line in file:
            i = i + 1
            time_ms = float(line)
            time_s = round(time_ms / 1000, 3)
            out.write('{},{},{},{}\n'.format(operation, provider, str(time_ms), str(time_s)))
        out.close()

    @staticmethod
    def resolve_operation_name(operation):
        return Transformer.OPERATIONS.get(operation)


if __name__ == "__main__":
    directory = sys.argv[1]
    target = sys.argv[2]
    transformer = Transformer(directory, target)
    transformer.transform()
