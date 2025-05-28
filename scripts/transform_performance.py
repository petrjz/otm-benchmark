import sys


class Transformer:
    """
    Consolidates raw performance benchmark results into one CSV file suitable for processing in R

    The transformation includes generating nicer names for providers (e.g., alibaba to AliBaba) and operation names
    (e.g., create to OP1 - Create)

    CLI parameters are: directory containing the result files and target file
    """
    OPERATIONS = [
        ["/jopa-benchmark-read-only_retrieve.data", "OP1 - Retrieve", "Read-only"],
        ["/jopa-benchmark_retrieve.data", "OP1 - Retrieve", "Read-write"],
        ["/jopa-benchmark-read-only_retrieve-all.data", "OP2 - Retrieve all", "Read-only"],
        ["/jopa-benchmark_retrieve-all.data", "OP2 - Retrieve all", "Read-write"],
    ]

    def __init__(self, directory, target):
        self.directory = directory
        self.target = target

    def transform(self):
        out = open(self.target, 'w')
        out.write('Operation,Transaction mode,time,time_s\n')
        out.close()

        for op in self.OPERATIONS:
            self.transform_file(*op)

        print("Data written into file " + str(self.target))

    def transform_file(self, file_path, operation, mode):
        path = str(self.directory)
        if not path.endswith('/'):
            path += '/'
        file = open(self.directory + file_path, 'r')
        out = open(self.target, 'a')
        operation = operation
        provider = mode

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
