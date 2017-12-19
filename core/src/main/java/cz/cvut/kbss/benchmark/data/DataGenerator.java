package cz.cvut.kbss.benchmark.data;


import cz.cvut.kbss.benchmark.model.*;

import java.net.URI;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static cz.cvut.kbss.benchmark.util.Constants.ITEM_COUNT;
import static cz.cvut.kbss.benchmark.util.Constants.SUMMARY;

public abstract class DataGenerator {

    protected final Random random = new Random();

    private List<OccurrenceReport> reports;
    private List<Person> persons;

    public void generate() {
        this.persons = generatePersons();
        this.reports = generateReports();
    }

    protected List<OccurrenceReport> generateReports() {
        final List<OccurrenceReport> reports = new ArrayList<>();
        for (int i = 0; i < ITEM_COUNT; i++) {
            final OccurrenceReport r = report();
            r.setOccurrence(generateOccurrence());
            r.setAuthor(randomItem(persons));
            r.setFileNumber(random.nextLong());
            r.setDateCreated(new Date());
            r.setLastModified(new Date());
            r.setLastModifiedBy(randomItem(persons));
            r.setAttachments(generateAttachments());
            r.setRevision(random.nextInt(ITEM_COUNT));
            r.setSummary(SUMMARY + System.currentTimeMillis() + i);
            reports.add(r);
        }
        return reports;
    }

    protected abstract OccurrenceReport report();

    protected <T> T randomItem(List<T> items) {
        return items.get(random.nextInt(items.size()));
    }

    protected Occurrence generateOccurrence() {
        final Occurrence occurrence = occurrence();
        occurrence.setName("Occurrence" + random.nextInt());
        occurrence.setStartTime(new Date(System.currentTimeMillis() - 10000));
        occurrence.setEndTime(new Date());
        return occurrence;
    }

    protected abstract Occurrence occurrence();

    protected Set<Resource> generateAttachments() {
        return IntStream.range(0, 3).mapToObj(i -> {
            final Resource attachment = resource();
            attachment.setIdentifier("resource" + i + ".doc");
            attachment.setDescription("This resource was attached to further document the reported occurrence.");
            return attachment;
        }).collect(Collectors.toSet());
    }

    protected abstract Resource resource();

    protected List<Person> generatePersons() {
        final List<Person> list = new ArrayList<>();
        for (int i = 0; i < ITEM_COUNT; i++) {
            final Person p = person();
            p.setPassword("password-" + i);
            p.setFirstName("firstName" + i);
            p.setLastName("lastName" + i);
            p.setUsername("user" + i);
            p.setContacts(IntStream.range(0, 5)
                                   .mapToObj(j -> String.format("%s_%d@kbss.felk.cvut.cz", p.getUsername(), j))
                                   .collect(Collectors.toSet()));
            list.add(p);
        }
        return list;
    }

    protected abstract Person person();

    protected URI generateUri(Class<?> type) {
        return URI.create(Vocabulary.BASE_URI + type.getSimpleName() + random.nextInt());
    }

    public List<Person> getPersons() {
        return Collections.unmodifiableList(persons);
    }

    public List<OccurrenceReport> getReports() {
        return Collections.unmodifiableList(reports);
    }
}
