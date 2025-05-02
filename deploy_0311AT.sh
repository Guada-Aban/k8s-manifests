#!/bin/bash
# ============================================================================
# Script de despliegue automático de sitio web estático en Minikube (0311AT)
# Este script automatiza el entorno local en Kubernetes.
#Autora: Guadalupe Aban
# ============================================================================

#------------------CONFIGURACIÓN-------------------

#modo fail test
set -e
set -o pipefail

#variables

PROFILE="0311at"
NAMESPACE="default"
APP_NAME="static-website"
REPO_MANIFESTS="https://github.com/Guada-Aban/k8s-manifests.git"
REPO_WEB="https://github.com/Guada-Aban/static-website.git"
MOUNT_PATH_LOCAL="$HOME/static-website"
MOUNT_PATH_VM="/mnt/data"
MANIFESTS_DIR="$HOME/k8s-manifests"

#--------------------FUNCIONES--------------------
check_dependencies(){
   echo "Verificando dependencias"
   for cmd in git minikube kubectl curl; do
       if ! command -v $cmd >/dev/null 2>&1; then
         echo "Falta el comando: $cmd. Antes de continuar tenes que instalarlo" >&2
         exit 1
       fi
   done
   echo "Todas las dependencias estan instaladas :)"
}

clone_repos(){
   echo "Clonando repositorios"

#clonar los manifiestos si no existen

   if [ ! -d "$MANIFESTS_DIR" ]; then
	echo "Clonando k8s-manifests en $MANIFESTS_DIR"
	git clone "$REPO_MANIFESTS" "$MANIFESTS_DIR"
   else
        echo "Ya existe $MANIFESTS_DIR"
   fi

#clonar el sitio web si no existe

  if [ ! -d "$MOUNT_PATH_LOCAL" ]; then
       echo "Clonando static-website en $MOUNT_PATH_LOCAL"
       git clone "$REPO_WEB" "$MOUNT_PATH_LOCAL"
  else
       echo "Ya existe $MOUNT_PATH_LOCAL"
  fi
}

#iniciar minikube
start_minikube(){
  echo "Iniciando minikube"

#verificar si esta corriendo
  if minikube status | grep -q "Running"; then
     echo "Minikube ya está corriendo"
  else
     echo "Iniciando minikube..."
     minikube start -p "$PROFILE" --driver=docker
  fi
}

mount_directorio() {
  echo -e "\n[INFO] Montando directorio local en Minikube..."

  # Verificar si ya está montado
  if mount | grep -q "$MOUNT_PATH_VM"; then
    echo "[INFO] Ya está montado $MOUNT_PATH_VM"
  else
    echo "[INFO] Montando... (esto debe ejecutarse en una terminal separada)"
    echo "Ejecutá este comando en otra consola y dejala abierta:"
    echo "minikube mount \"$MOUNT_PATH_LOCAL:$MOUNT_PATH_VM\" -p $PROFILE"
    read -p "[PAUSA] Presioná ENTER cuando hayas montado el directorio..." # Espera manual
  fi
}

# Aplicar manifiestos YAML
aplicar_manifiestos() {
  echo -e "\n[INFO] Aplicando manifiestos Kubernetes..."
  kubectl apply -f "$MANIFESTS_DIR/volumes/static-website-pv.yaml"
  kubectl apply -f "$MANIFESTS_DIR/volumes/static-website-pvc.yaml"
  kubectl apply -f "$MANIFESTS_DIR/deployments/static-website-deployment.yaml"
  kubectl apply -f "$MANIFESTS_DIR/services/static-website-service.yaml"
  echo "[INFO] Manifiestos aplicados con éxito"
}

# Verificar que el pod esté corriendo y con PVC montado
verificar_despliegue() {
  echo -e "\n[INFO] Verificando despliegue del pod..."

  sleep 5  # espera breve para que se inicie el pod

  POD_NAME=$(kubectl get pods -l app=$APP_NAME -o jsonpath="{.items[0].metadata.name}")

  if [ -z "$POD_NAME" ]; then
    echo "[ERROR] No se encontró el pod del sitio"
    exit 1
  fi

  STATUS=$(kubectl get pod "$POD_NAME" -o jsonpath="{.status.phase}")
  echo "[INFO] Estado del pod: $STATUS"

  if [ "$STATUS" != "Running" ]; then
    echo "[ERROR] El pod no está en ejecución. Verificá los logs con:"
    echo "kubectl logs $POD_NAME"
    exit 1
  fi

  echo "[INFO] Pod '$POD_NAME' está en ejecución"
}

# Verificar que el sitio web responda correctamente
verificar_sitio_web() {
  echo -e "\n[INFO] Verificando que el sitio responda..."
  
  URL=$(minikube service "$APP_NAME-service" --url -p "$PROFILE")
  echo "[INFO] URL del servicio: $URL"

  # Espera breve por si el servicio tarda en estar disponible
  sleep 5
  RESPUESTA=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

  if [ "$RESPUESTA" = "200" ]; then
    echo "[INFO] Sitio funcionando correctamente ✅"
    echo "[INFO] Abrilo en tu navegador: $URL"
  else
    echo "[ERROR] El sitio no respondió correctamente (HTTP $RESPUESTA)"
    exit 1
  fi
}

#funcion main
main() {
  echo -e "-------------Despliegue Automático 0311AT------------"
  check_dependencies
  clone_repos
  start_minikube
  mount_directorio
  aplicar_manifiestos
  verificar_despliegue
  verificar_sitio_web
  echo -e "Despliegue completo"
}

#ejecutar
main
