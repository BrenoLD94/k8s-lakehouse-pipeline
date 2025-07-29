#!/bin/bash

# Garante que o script pare se algum comando falhar
set -e

# Define o diretório de destino
DEST_DIR="apps/spark/dependencies"

echo "Criando o diretório de dependências em $DEST_DIR..."
mkdir -p $DEST_DIR

echo "Baixando dependências para $DEST_DIR..."

# 1. Iceberg (para Spark 3.5.x)
wget -O $DEST_DIR/iceberg-spark-runtime-3.5_2.12-1.9.2.jar https://search.maven.org/remotecontent?filepath=org/apache/iceberg/iceberg-spark-runtime-3.5_2.12/1.9.2/iceberg-spark-runtime-3.5_2.12-1.9.2.jar

# 2. Kafka (para Spark 3.5.6)
wget -O $DEST_DIR/spark-sql-kafka-0-10_2.12-3.5.6.jar https://repo1.maven.org/maven2/org/apache/spark/spark-sql-kafka-0-10_2.12/3.5.6/spark-sql-kafka-0-10_2.12-3.5.6.jar

# 3. S3/MinIO (para Hadoop 3.3.4)
wget -O $DEST_DIR/hadoop-aws-3.3.4.jar https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.4/hadoop-aws-3.3.4.jar
wget -O $DEST_DIR/aws-java-sdk-bundle-1.12.262.jar https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.262/aws-java-sdk-bundle-1.12.262.jar

# 4. Hive Metastore Client (para Hive 4.0.1)
wget -O $DEST_DIR/hive-metastore-4.0.1.jar https://repo1.maven.org/maven2/org/apache/hive/hive-metastore/4.0.1/hive-metastore-4.0.1.jar

echo "-------------------------------------"
echo "Download de todas as dependências concluído com sucesso!"
echo "-------------------------------------"