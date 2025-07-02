# Etapa 1: Definir a imagem base
# Usamos uma imagem oficial do Python. A tag 'slim' indica uma versão mínima,
# o que resulta em uma imagem final menor e mais segura.
FROM python:3.10-slim

# Etapa 2: Definir o diretório de trabalho
# Define o diretório de trabalho dentro do contêiner para /app.
# Todos os comandos subsequentes (como COPY e RUN) serão executados a partir deste diretório.
WORKDIR /app

# Etapa 3: Copiar e instalar as dependências
# Copiamos o arquivo requirements.txt primeiro para aproveitar o cache de camadas do Docker.
# Se este arquivo não mudar entre os builds, o Docker reutilizará a camada de dependências instaladas,
# acelerando o processo de build.
COPY requirements.txt .

# Instala as dependências listadas no requirements.txt.
# A flag --no-cache-dir garante que o pip não armazene o cache de download, mantendo a imagem menor.
RUN pip install --no-cache-dir -r requirements.txt

# Etapa 4: Copiar o código da aplicação
# Copia todos os arquivos do diretório atual (onde o Dockerfile está) para o diretório de trabalho (/app) no contêiner.
COPY . .

# Etapa 5: Expor a porta da aplicação
# Informa ao Docker que o contêiner escutará na porta 8000 em tempo de execução.
EXPOSE 8000

# Etapa 6: Definir o comando para iniciar a aplicação
# Este é o comando que será executado quando o contêiner iniciar.
# Ele inicia o servidor Uvicorn, fazendo a aplicação acessível na rede na porta 8000.
# O host '0.0.0.0' é necessário para que a aplicação seja acessível de fora do contêiner.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]