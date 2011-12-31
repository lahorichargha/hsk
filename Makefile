.PHONY: test clean clean-output

HDFS_ROOT=hdfs://localhost:9000
STANDALONE_FS_ROOT=file:///tmp

clean: clean-output
	lein clean

clean-output:
	-hadoop fs -rmr $(HDFS_ROOT)/hd-out/

test: clean
	lein jar
	-hadoop fs -rmr $(HDFS_ROOT)/hd-in/
	make clean-output
	hadoop fs -mkdir $(HDFS_ROOT)/hd-in/
	find sample/flat -not -type d -exec hadoop fs -copyFromLocal '{}' $(HDFS_ROOT)/hd-in/ ';'
	hadoop fs -ls $(HDFS_ROOT)/hd-in/
	hadoop jar hsk-1.0.0-SNAPSHOT.jar hsk.flat2seq $(HDFS_ROOT)/hd-in $(HDFS_ROOT)/hd-out/
	hadoop fs -ls $(HDFS_ROOT)/hd-out/
	make clean-output
	lein test	
