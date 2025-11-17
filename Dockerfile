# --- Imagem Base ---
# Usamos a imagem Alpine leve com Java 21 (JRE)
FROM eclipse-temurin:21-jre-alpine

# --- Instala Dependências ---
# Adiciona o 'uuidgen' que seu script de start precisa
# Instala 'dos2unix' e 'bash' para garantir que o entrypoint.sh funcione
# Seu script usa 'bash', que não é padrão no Alpine, é importante instalá-lo!
RUN apk add --no-cache util-linux bash dos2unix

# --- Ambiente ---
# Define o diretório de trabalho principal
WORKDIR /l2zenzy

# Cria o diretório de log que seu script espera
RUN mkdir log

# --- Copia os Arquivos do Projeto ---
# Copia todo o seu projeto (pastas 'login', 'game', 'libs', etc) para o container
COPY . .

# --- Script de Entrypoint ---
# O arquivo entrypoint.sh já foi copiado acima pelo 'COPY . .'
# Agora aplicamos as correções de permissão e formato:

# 1. Converte as quebras de linha (CRLF -> LF) para evitar o erro "no such file"
RUN dos2unix entrypoint.sh

# 2. Dá permissão de execução ao script
RUN chmod +x entrypoint.sh

# --- Portas ---
# Expõe as portas do Login e Game Server
EXPOSE 7777
EXPOSE 2106

# --- Comando Final ---
# Define o nosso script como o comando principal do container
# Usamos o caminho relativo, pois estamos dentro do WORKDIR /l2zenzy
ENTRYPOINT ["./entrypoint.sh"]
