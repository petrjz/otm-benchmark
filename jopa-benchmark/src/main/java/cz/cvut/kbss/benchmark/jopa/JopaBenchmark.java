package cz.cvut.kbss.benchmark.jopa;

import cz.cvut.kbss.benchmark.AbstractBenchmark;
import cz.cvut.kbss.benchmark.BenchmarkRunner;

public class JopaBenchmark extends AbstractBenchmark {
    protected static final String READ_ONLY_RETRIEVE = "read-only-retrieve";
    protected static final String READ_ONLY_RETRIEVE_ALL = "read-only-retrieve-all";

    public static void main(String[] args) {
        final JopaBenchmark benchmark = new JopaBenchmark();
        benchmark.run(args);
    }

    @Override
    protected BenchmarkRunner createBenchmarkRunner(String type) {
        switch (type) {
            case CREATE:
                return new CreateBenchmarkRunner();
            case BATCH_CREATE:
                return new BatchCreateBenchmarkRunner();
            case RETRIEVE:
                return new RetrieveBenchmarkRunner();
            case RETRIEVE_ALL:
                return new RetrieveAllBenchmarkRunner();
            case UPDATE:
                return new UpdateBenchmarkRunner();
            case DELETE:
                return new DeleteBenchmarkRunner();
            case READ_ONLY_RETRIEVE:
                return new ReadOnlyRetrieveBenchmarkRunner();
            case READ_ONLY_RETRIEVE_ALL:
                return new ReadOnlyRetrieveAllBenchmarkRunner();
            default:
                throw new IllegalArgumentException("Unsupported benchmark type " + type + '.');
        }
    }
}
