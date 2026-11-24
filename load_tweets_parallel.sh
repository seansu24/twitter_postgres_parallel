#!/bin/sh

files=$(find data/*)
NORMALIZED_DB='postgresql://postgres:pass@localhost:3146/postgres'

echo '================================================================================'
echo 'load pg_denormalized'
echo '================================================================================'
time parallel ./load_denormalized.sh ::: data/*

echo '================================================================================'
echo 'load pg_normalized'
echo '================================================================================'
time parallel python3 load_tweets.py --db "$NORMALIZED_DB" --inputs {} ::: $files

echo '================================================================================'
echo 'load pg_normalized_batch'
echo '================================================================================'
time parallel python3 -u load_tweets_batch.py --db=postgresql://postgres:pass@localhost:4146/postgres --inputs {} ::: $files
