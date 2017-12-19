package cz.cvut.kbss.benchmark.alibaba.util;

import cz.cvut.kbss.benchmark.alibaba.model.Resource;
import cz.cvut.kbss.benchmark.model.OccurrenceReport;
import cz.cvut.kbss.benchmark.util.AbstractBenchmarkUtil;
import org.openrdf.query.QueryEvaluationException;
import org.openrdf.repository.RepositoryException;
import org.openrdf.repository.object.ObjectConnection;

import java.util.List;

public class BenchmarkUtil {

    private BenchmarkUtil() {
        throw new AssertionError();
    }

    public static void persistAll(ObjectConnection connection, List<OccurrenceReport> reports)
            throws RepositoryException {
        connection.begin();
        for (OccurrenceReport report : reports) {
            final cz.cvut.kbss.benchmark.alibaba.model.OccurrenceReport r = (cz.cvut.kbss.benchmark.alibaba.model.OccurrenceReport) report;
            connection.addObject(r.getUri().toString(), r);
            connection.addObject(r.getOccurrence().getUri().toString(), r.getOccurrence());
            for (Resource a : r.getAttachments()) {
                connection.addObject(a.getUri().toString(), a);
            }
        }
        connection.commit();
    }

    public static void retrieveAll(ObjectConnection connection, List<OccurrenceReport> reports)
            throws QueryEvaluationException, RepositoryException {
        for (OccurrenceReport report : reports) {
            final cz.cvut.kbss.benchmark.alibaba.model.OccurrenceReport r = (cz.cvut.kbss.benchmark.alibaba.model.OccurrenceReport) report;
            final OccurrenceReport result = connection.getObject(OccurrenceReport.class, r.getUri().toString());
            AbstractBenchmarkUtil.checkReport(report, result);
        }
    }
}
