#!/bin/bash

JAVA=java
OUTPUT=benchmark.log
LOGFILE=logback.xml

WARMUPS=20
ROUNDS=100
EXECUTIONS=5
# MEMORY=(32m 64m 128m 256m 512m 1g)
MEMORY=(1g)
DATA_FACTOR=(1 2 3 4 5)
DATA_DIR=data

GRAPHDB_HOME=/home/petrjz/ownCloud/master/codes/benchmarking/graphdb-10.8.4
GRAPHDB_PIDFILE=${GRAPHDB_HOME}/.graphdbpid

start_graphdb()
{
    echo "starting graph db"
    sudo ${GRAPHDB_HOME}/bin/graphdb -d -s -p ${GRAPHDB_PIDFILE};
    sleep 20    # Sleep to give GraphDB time to start
    echo "graph db should be ready"
}

stop_graphdb()
{
    sudo kill $(<"${GRAPHDB_PIDFILE}")
    sleep 2
}

restart_graphdb()
{
    stop_graphdb
    start_graphdb
}

start_repository()
{
    start_graphdb
}

stop_repository()
{
    stop_graphdb
}

restart_repository()
{
    stop_repository
    start_repository
}

execute_with_provider()
{
    cd ${1}/target
    echo "Retrieve..."
    echo "*** RETRIEVE ***" >> ../../${OUTPUT}
    ${JAVA} -jar -Xms${2} -Xmx${2} -Dlogback.configurationFile=${LOGFILE} ${1}.jar -w ${WARMUPS} -r ${ROUNDS} -o ../../${DATA_DIR}/${2}/factor${3}/${1}_retrieve.data -f ${3} retrieve >> ../../${OUTPUT}
    # restart_repository

    echo "Retrieve all..."
    echo "*** RETRIEVE ALL ***" >> ../../${OUTPUT}
    ${JAVA} -jar -Xms${2} -Xmx${2} -Dlogback.configurationFile=${LOGFILE} ${1}.jar -w ${WARMUPS} -r ${ROUNDS} -o ../../${DATA_DIR}/${2}/factor${3}/${1}_retrieve-all.data -f ${3} retrieve-all >> ../../${OUTPUT}
    # restart_repository

    echo "Read-only Retrieve..."
    echo "*** READ-ONLY RETRIEVE ***" >> ../../${OUTPUT}
    ${JAVA} -jar -Xms${2} -Xmx${2} -Dlogback.configurationFile=${LOGFILE} ${1}.jar -w ${WARMUPS} -r ${ROUNDS} -o ../../${DATA_DIR}/${2}/factor${3}/${1}-read-only_retrieve.data -f ${3} read-only-retrieve >> ../../${OUTPUT}
    # restart_repository

    echo "Read-only Retrieve all..."
    echo "*** READ-ONLY RETRIEVE ALL ***" >> ../../${OUTPUT}
    ${JAVA} -jar -Xms${2} -Xmx${2} -Dlogback.configurationFile=${LOGFILE} ${1}.jar -w ${WARMUPS} -r ${ROUNDS} -o ../../${DATA_DIR}/${2}/factor${3}/${1}-read-only_retrieve-all.data -f ${3} read-only-retrieve-all >> ../../${OUTPUT}
    # restart_repository
    cd ../..
}

execute_round()
{
    # JOPA Benchmark
    echo "Running JOPA..."
    echo "---------------------------------------" >> ${OUTPUT}
    echo "|               JOPA                  |" >> ${OUTPUT}
    echo "---------------------------------------" >> ${OUTPUT}
    execute_with_provider "jopa-benchmark" ${1} ${2}
}

execute_benchmark()
{
    # start_repository

    mkdir -p ${DATA_DIR}/${1}/factor${2}/

    ####
    #
    # Execute the whole benchmark several times, so that we have output from multiple JVM executions
    #
    ####
    for i in $(seq 1 ${EXECUTIONS})
    do
        echo "Running JVM round ${i}..."
        execute_round ${1} ${2}
    done

    # stop_repository
}

> ${OUTPUT}
echo "Running benchmark..."

for mem in "${MEMORY[@]}"
do
    for factor in "${DATA_FACTOR[@]}"
    do
        echo "Running benchmark with memory size ${mem} and data factor ${factor}..."
        execute_benchmark ${mem} ${factor}
    done
done

echo "Benchmark finished."
