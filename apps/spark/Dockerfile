# apps/spark/Dockerfile

# Usamos a imagem oficial do Docker
FROM spark:3.5.6-scala2.12-java17-ubuntu

# Define o diretório de trabalho padrão
WORKDIR /opt/spark/work-dir

# Copia TODOS os JARs da pasta de dependências local para a pasta de JARs do Spark na imagem.
COPY --chown=spark:spark ./apps/spark/dependencies/*.jar /opt/spark/jars/

# troca para o usuario não-root
USER spark
