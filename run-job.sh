#!/bin/bash
# Create HDFS input dir and upload file
hdfs dfs -mkdir -p /input
hdfs dfs -put -f /data/social_media_logs.txt /input/
hdfs dfs -put /data/user_profiles.txt /input/user_profiles.txt

hdfs dfs -test -d $OUTPUT_PATH
if [ $? -eq 0 ]; then
  echo "Output directory $OUTPUT_PATH exists. Removing..."
  hdfs dfs -rm -r $OUTPUT_PATH
fi
hdfs dfs -rm -r -f /output/cleansed
# Run streaming MapReduce job to parse and filter out malformed or incomplete records 
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -D mapreduce.job.name="CleanseSocialMediaLogs" \
  -D mapreduce.job.reduces=1 \
  -input /input/social_media_logs.txt \
  -output /output/cleansed \
  -mapper /mapper.py \
  -reducer /reducer.py \
  -file /mapper.py \
  -file /reducer.py

# Output result
#hdfs dfs -cat /output/cleansed/part-00000
rm -f cleansed_output.txt
hdfs dfs -get /output/cleansed/part-00000 ./cleansed_output.txt

#Run streaming MapReduce job to aggregate, for each user, the total count of each action type (posts, likes, comments, shares)
hdfs dfs -rm -r /output/user_action_counts

#hdfs dfs -put ./cleansed_output.txt /input/activity.log
echo "Putting cleansed_output.txt into HDFS..."
#hdfs dfs -mkdir -p /input
hdfs dfs -put -f ./cleansed_output.txt /input/activity.log

hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -input /input/activity.log \
  -output /output/user_action_counts \
  -mapper /mapper1.py \
  -reducer /reducer1.py \
  -file /mapper1.py \
  -file /reducer1.py

 # Run streaming MapReduce job to sort in descending order by the number of posts
 hdfs dfs -rm -r /output/sorted_by_posts

#Run the sorting job
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
  -input /output/user_action_counts \
  -output /output/sorted_by_posts \
  -mapper /mapper2.py \
  -reducer /reducer2.py \
  -file /mapper2.py \
  -file /reducer2.py

#Fetch from HDFS and store in local file
rm -f final_action_aggregation_sorting.txt
hdfs dfs -cat /output/sorted_by_posts/part-* > final_action_aggregation_and_sorting.txt

#Run the job to identify trending content
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
 -input /output/cleaned_logs \
 -output /output/trending_content \
 -mapper "/mapper_trendingcontent.py" \
 -combiner "/combiner_trendingcontent.py" \
 -reducer "/reducer_trendingcontent.py" \
 -file /mapper_trendingcontent.py \
 -file /combiner_trendingcontent.py \
 -file /reducer_trendingcontent.py

hdfs dfs -cat /output/sorted_by_posts/part-* > /input/aggregated_user_data.txt
hdfs dfs -put /input/aggregated_user_data.txt /input/

hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
 -input /input/aggregated_user_data.txt,/input/user_profiles.txt \
 -output /output/user_profile_join \
 -mapper "/mapper_useractivityprofiledatajoin.py" \
 -reducer "reducer_useractivityprofiledatajoin.py" \
 -file /mapper_useractivityprofiledatajoin.py \
 -file /reducer_useractivityprofiledatajoin.py





