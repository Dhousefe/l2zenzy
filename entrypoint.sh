#!/bin/bash

# Define o comando Java
JAVA_CMD="java"

# --- Configuração das Variáveis ---
# Pega as variáveis de ambiente do Easypanel.
# Se a variável não for definida no Easypanel, usa o valor padrão (o que estava no seu script).
L2_EMAIL=${L2_EMAIL:-"brprojeto@l2jbrasil.com"}

PASSWORD=${PASSWORD:-"12345678"}

# Pega as opções de Java (memória, etc) do Easypanel
# Se não for definido, usa o padrão do seu script para o GameServer
LOGIN_JAVA_OPTS=${LOGIN_JAVA_OPTS:-""}
GAME_JAVA_OPTS=${GAME_JAVA_OPTS:-"-Xms1g -Xmx2g"}

# Gera a Key, exatamente como seu script fazia
KEY=$(uuidgen | tr -d '-')

echo "=== Iniciando LoginServer ==="
(
  cd login || exit
  # Usa as variáveis de Java (se houver)
  $JAVA_CMD $LOGIN_JAVA_OPTS -cp "../libs/*" ext.mods.loginserver.LoginServer > ../log/login.log 2>&1
) &
LOGIN_PID=$!

echo "=== Iniciando GameServer ==="
(
  cd game || exit
  # Usa as variáveis de Java e passa a KEY e o EMAIL como argumentos
  $JAVA_CMD $GAME_JAVA_OPTS -cp "../libs/*" ext.mods.gameserver.GameServer "$KEY" "$L2_EMAIL" > ../log/game.log 2>&1
) &
GAME_PID=$!

echo "LoginServer PID: $LOGIN_PID"
echo "GameServer PID: $GAME_PID"
echo "Key usada: $KEY"
echo "Email usado: $L2_EMAIL"

# --- Gerenciador de Processos ---

# Função para parar os servidores Java quando o Easypanel parar o container
shutdown() {
  echo "Desligando... enviando SIGTERM para $LOGIN_PID e $GAME_PID"
  kill -TERM "$LOGIN_PID" "$GAME_PID"
  # Espera os processos terminarem
  wait "$LOGIN_PID"
  wait "$GAME_PID"
  echo "Servidores parados."
  exit 0
}

# 'trap' captura o sinal de parada (SIGTERM) do Docker/Easypanel
trap shutdown SIGTERM SIGINT

# 'wait -n' é o processo principal do container.
# Ele fica esperando em primeiro plano. Se *qualquer* um dos PIDs (Login ou Game)
# falhar ou parar, o 'wait -n' termina, o script chama 'shutdown' para
# matar o outro processo, e o container desliga.
wait -n $LOGIN_PID $GAME_PID

# Se chegarmos aqui, é porque um dos servidores caiu.
echo "Um dos servidores (Login ou Game) parou inesperadamente. Desligando o container..."
shutdown