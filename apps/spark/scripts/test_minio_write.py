from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("Test MinIO Write").getOrCreate()

data = [("Alice", 1), ("Bob", 2)]
df = spark.createDataFrame(data, ["name", "id"])

print("DataFrame criado. Tentando salvar em Parquet no MinIO...")

# Salva diretamente no MinIO em formato Parquet, sem Iceberg
df.write.mode("overwrite").format("parquet").save("s3a://lakehouse/raw/test_parquet")

print("Salvo com sucesso no MinIO!")

spark.stop()