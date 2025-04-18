package cz.cvut.kbss.benchmark.jopa;

import cz.cvut.kbss.benchmark.jopa.util.JopaFinder;
import cz.cvut.kbss.jopa.model.EntityManager;

public class ReadOnlyRetrieveAllBenchmarkRunner extends RetrieveAllBenchmarkRunner {
    @Override
    public void execute() {
        final EntityManager em = persistenceFactory.readOnlyEntityManager();
        executeRetrieveAll(new JopaFinder(em));
    }
}
