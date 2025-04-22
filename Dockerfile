FROM ubuntu:22.04

# Install Hadoop + dependencies
ENV HADOOP_VERSION=3.3.6
#RUN apt-get update &&     apt-get install -y openjdk-11-jdk python3 python3-pip wget ssh rsync && ln -sf python3 /usr/bin/python &&  wget https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && tar -xzf hadoop-${HADOOP_VERSION}.tar.gz && mv hadoop-${HADOOP_VERSION} /opt/hadoop && rm hadoop-${HADOOP_VERSION}.tar.gz

RUN apt-get update && \
    apt-get install -y openjdk-11-jdk python3 python3-pip wget ssh rsync && \
    ln -sf python3 /usr/bin/python && \
    wget https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar -xzf hadoop-${HADOOP_VERSION}.tar.gz && \
    mv hadoop-${HADOOP_VERSION} /opt/hadoop && \
    rm hadoop-${HADOOP_VERSION}.tar.gz
ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

RUN echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> /opt/hadoop/etc/hadoop/hadoop-env.sh

COPY mapper.py /mapper.py
COPY reducer.py /reducer.py
COPY mapper1.py /mapper1.py
COPY reducer1.py /reducer1.py
COPY mapper2.py /mapper2.py
COPY reducer2.py /reducer2.py
COPY mapper_trendingcontent.py /mapper_trendingcontent.py
COPY reducer_trendingcontent.py /reducer_trendingcontent.py
COPY combiner_trendingcontent.py /combiner_trendingcontent.py
COPY reducer_useractivityprofiledatajoin.py /reducer_useractivityprofiledatajoin.py
COPY mapper_useractivityprofiledatajoin.py /mapper_useractivityprofiledatajoin.py
COPY start-hadoop.sh /start-hadoop.sh
COPY run-job.sh /run-job.sh

# Install dos2unix
RUN apt update && apt install -y dos2unix
RUN dos2unix mapper1.py reducer1.py
RUN dos2unix mapper2.py reducer2.py
RUN dos2unix mapper_trendingcontent.py reducer_trendingcontent.py combiner_trendingcontent.py
RUN dos2unix mapper_useractivityprofiledatajoin.py reducer_useractivityprofiledatajoin.py

RUN chmod +x /start-hadoop.sh
RUN chmod +x /run-job.sh
RUN chmod +x /mapper.py
RUN chmod +x /reducer.py
RUN chmod +x /mapper1.py
RUN chmod +x /reducer1.py
RUN chmod +x /mapper2.py
RUN chmod +x /reducer2.py
RUN chmod +x /mapper_trendingcontent.py
RUN chmod +x /combiner_trendingcontent.py
RUN chmod +x /reducer_trendingcontent.py
RUN chmod +x /mapper_useractivityprofiledatajoin.py
RUN chmod +x /reducer_useractivityprofiledatajoin.py



WORKDIR /
CMD ["bash"]
