# --- Imagem Base ---
# Usamos a imagem Alpine leve com Java 21 (JRE)
FROM eclipse-temurin:21-jre-alpine

# --- Instala Dependências ---
# Adiciona o 'uuidgen' que seu script de start precisa
RUN apk add --no-cache util-linux

# --- Ambiente ---
WORKDIR /l2zenzy

# Cria o diretório de log que seu script espera
RUN mkdir log

# --- Copia os Arquivos do Projeto ---
# Copia todo o seu projeto (pastas 'login', 'game', 'libs', etc) para o container
COPY . .

# --- Script de Entrypoint ---
# Copia o nosso script customizado de inicialização
COPY entrypoint.sh .

# Dá permissão de execução ao script
RUN chmod +x entrypoint.sh

# --- Portas ---
# Expõe as portas do Login e Game Server
EXPOSE 7777
EXPOSE 2106

# --- Comando Final ---
# Define o nosso script como o comando principal do container
ENTRYPOINT ["./l2zenzy/entrypoint.sh"]