# 1. Usa uma imagem oficial e leve do Python
FROM python:3.11-slim

# 2. Define a pasta de trabalho dentro do container
WORKDIR /app

# 3. Instala o git (necessário se usar dbt deps) e limpa o cache para a imagem ficar menor
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# 4. Instala o adaptador do dbt para o BigQuery
RUN pip install --no-cache-dir dbt-bigquery

# 5. Copia todos os arquivos do seu repositório para a pasta /app no container
COPY . .

# 6. Baixa os pacotes extras (se você usar packages.yml no projeto)
RUN dbt deps || true

# 7. O comando que o Cloud Run Job vai executar quando for acionado
# Passamos o --profiles-dir . para ele procurar as credenciais na mesma pasta
CMD ["dbt", "run", "--profiles-dir", "."]