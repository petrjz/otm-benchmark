package cz.cvut.kbss.benchmark.jopa;

import cz.cvut.kbss.benchmark.jopa.util.JopaFinder;
import cz.cvut.kbss.jopa.model.EntityManager;

public class ReadOnlyRetrieveBenchmarkRunner extends RetrieveBenchmarkRunner {
    @Override
    public void execute() {
        final EntityManager em = persistenceFactory.readOnlyEntityManager();
        executeRetrieve(new JopaFinder(em));
    }
}
