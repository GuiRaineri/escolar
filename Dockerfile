# Etapa 1: Escolher a imagem base
# Usamos uma imagem 'slim' que é menor que a padrão, mas mais compatível que a 'alpine' para pacotes Python.
# A versão 3.11 é estável e compatível com o projeto (que pede 3.10+), evitando possíveis problemas de compilação da imagem 'alpine'.
FROM python:3.11-slim

# Etapa 2: Definir o diretório de trabalho dentro do contêiner
WORKDIR /app

# Etapa 3: Copiar o arquivo de dependências
# Copiamos primeiro para aproveitar o cache do Docker. Se este arquivo não mudar,
# a camada de instalação de dependências não será reconstruída, acelerando o build.
COPY requirements.txt .

# Etapa 4: Instalar as dependências
# Atualizamos o pip e usamos --no-cache-dir para manter a imagem final menor.
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Etapa 5: Copiar o restante do código da aplicação
COPY . .

# Etapa 6: Expor a porta que a aplicação usará
EXPOSE 8000

# Etapa 7: Comando para executar a aplicação
# Usamos --host 0.0.0.0 para que a aplicação seja acessível de fora do contêiner.
# O parâmetro --reload é ótimo para desenvolvimento, mas não deve ser usado em uma imagem final/produção.
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
