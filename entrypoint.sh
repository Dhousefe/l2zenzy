#!/bin/bash

# Define o comando Java
JAVA_CMD="java"

# --- Configuração das Variáveis ---
L2_EMAIL=${L2_EMAIL:-"brprojeto@l2jbrasil.com"}
PASSWORD=${PASSWORD:-"12345678"}
LOGIN_JAVA_OPTS=${LOGIN_JAVA_OPTS:-""}
GAME_JAVA_OPTS=${GAME_JAVA_OPTS:-"-Xms1g -Xmx2g"}
KEY=$(uuidgen | tr -d '-')

echo "=== Iniciando LoginServer (MODO DEBUG) ==="
(
  cd login || exit
  # SEM REDIREÇÃO DE LOG - O erro Java vai aparecer no log do container
  $JAVA_CMD $LOGIN_JAVA_OPTS -cp "../libs/*" ext.mods.loginserver.LoginServer
) &
LOGIN_PID=$!

echo "=== Iniciando GameServer (MODO DEBUG) ==="
(
  cd game || exit
  # SEM REDIREÇÃO DE LOG - O erro Java vai aparecer no log do container
  $JAVA_CMD $GAME_JAVA_OPTS -cp "../libs/*" ext.mods.gameserver.GameServer "$KEY" "$L2_EMAIL"
) &
GAME_PID=$!

echo "LoginServer PID: $LOGIN_PID"
echo "GameServer PID: $GAME_PID"
echo "Key usada: $KEY"
echo "Email usado: $L2_EMAIL"

# --- Gerenciador de Processos ---
shutdown() {
  echo "Desligando... enviando SIGTERM para $LOGIN_PID e $GAME_PID"
  # Adicionamos '|| true' para ignorar o erro "No such process"
  kill -TERM "$LOGIN_PID" || true
  kill -TERM "$GAME_PID" || true
  wait "$LOGIN_PID"
  wait "$GAME_PID"
  echo "Servidores parados."
  exit 0
}

trap shutdown SIGTERM SIGINT

wait -n $LOGIN_PID $GAME_PID

echo "Um dos servidores (Login ou Game) parou inesperadamente. Desligando o container..."
shutdown