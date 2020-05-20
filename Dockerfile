FROM ubuntu:18.04

MAINTAINER KiwenLau <kiwenlau@gmail.com>, Giuseppe Di Lena <giuseppedilena92@gmail.com>

WORKDIR /root

# install openssh-server, openjdk and wget
RUN apt-get update && apt-get upgrade -y && \
   apt-get install -y --no-install-recommends software-properties-common net-tools iperf iputils-ping iperf3 netcat iproute2 telnet htop vim openssh-client openssh-server && \
   add-apt-repository -y ppa:openjdk-r/ppa \
   && apt-get update && apt-get install -y openjdk-8-jdk openjdk-8-jre && \
   update-alternatives --config java && update-alternatives --config javac

RUN apt-get update && apt-get install -y openssh-server openjdk-8-jdk wget

# install hadoop 2.7.2
RUN wget https://github.com/kiwenlau/compile-hadoop/releases/download/2.7.2/hadoop-2.7.2.tar.gz && \
    tar -xzvf hadoop-2.7.2.tar.gz && \
    mv hadoop-2.7.2 /usr/local/hadoop && \
    rm hadoop-2.7.2.tar.gz

# set environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 
ENV HADOOP_HOME=/usr/local/hadoop 
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin 

# ssh without key
#RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
#    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs

COPY config/* /tmp/

RUN mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh && \
    mv /tmp/pi.sh ~/pi.sh
    #mv /tmp/start-hadoop.sh ~/start-hadoop.sh &&
    #mv /tmp/ssh_config ~/.ssh/config && \


RUN chmod +x ~/run-wordcount.sh && \
    chmod +x ~/pi.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh
    #chmod +x ~/start-hadoop.sh &&

# format namenode
# RUN /usr/local/hadoop/bin/hdfs namenode -format

RUN mkdir -p /root/.ssh
COPY config/ssh/id_rsa /root/.ssh/id_rsa
RUN chmod 0600 /root/.ssh/id_rsa
COPY config/ssh/id_rsa.pub /root/.ssh/id_rsa.pub
COPY config/ssh/authorized_keys /root/.ssh/authorized_keys

CMD [ "sh", "-c", "service ssh start; bash"]

