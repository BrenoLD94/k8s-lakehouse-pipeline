FROM python:3-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_ROOT_USER_ACTION=ignore

WORKDIR /src/app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

# TROCAR PARA USUARIO NÂO ROOT EM PROD
# Copia o conteúdo da pasta 'app' (que tem main.py)
COPY --chmod=755 app/ .

# O CMD define o comando principal 
CMD ["python", "main.py"]