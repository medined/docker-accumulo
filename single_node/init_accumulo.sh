su - hdfs -c '/usr/lib/hadoop/bin/hdfs dfs -mkdir /accumulo'
su - hdfs -c '/usr/lib/hadoop/bin/hdfs dfs -mkdir -p /user/accumulo'
su - hdfs -c '/usr/lib/hadoop/bin/hdfs dfs -chown accumulo:accumulo /accumulo'
su - hdfs -c '/usr/lib/hadoop/bin/hdfs dfs -chown accumulo:accumulo /user/accumulo'
su - accumulo -c '/usr/lib/accumulo/bin/accumulo init --instance-name accumulo --password secret'
#
# Now that accumulo has been initialized, we can add the supervisor configuration file.
cp -vu /docker/supervisord-accumulo.conf /etc/supervisor/conf.d/accumulo.conf
