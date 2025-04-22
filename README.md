docker compose build
docker-compose up -d
docker exec -it hadoop-node bash
./start_hadoop.sh
./run-job.sh
