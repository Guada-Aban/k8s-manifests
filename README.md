# k8s-manifests


Este proyecto implementa un sitio web estático servido con NGINX, desplegado sobre Kubernetes utilizando Minikube. 
Se incluye una imagen Docker personalizada que contiene el contenido del sitio web, con manifiestos Kubernetes organizados y listos para aplicar.

---

##  Estructura del repositorio

```
k8s-manifests/ ├── deployments/ │ └── static-website-deployment.yaml ├── services/ │ └── static-website-service.yaml ├── volumes/ │ ├── static-website-pv.yaml │ └── static-website-pvc.yaml └── README.md
```

---

##  Requisitos

- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- Docker (el que usa Minikube internamente)

---

##  Cómo reproducir el entorno

### 1. Clonar este repositorio

```bash
git clone https://github.com/Guada-Aban/k8s-manifests.git
cd k8s-manifests
```

### 2. Iniciar Minikube
```bash
minikube start --driver=docker
```

### 3. Crear la imagen Docker personalizada
```bash
minikube image build -t static-website:v1 .
```

### 4. Aplicar los manifiestos de Kubernetes
```bash
kubectl apply -f deployments/static-website-deployment.yaml
kubectl apply -f services/static-website-service.yaml
```

### 5. Acceder al sitio desde el navegador
```bash
minikube service static-website-service
```
Esto abrirá el navegador directamente con la URL local donde está corriendo el sitio.

### Notas sobre la implementación
- En la primera parte del proyecto se intentó montar el contenido estático desde un volumen (hostPath) mapeado desde C:\minikube-data, cumpliendo la consigna original.
- Sin embargo, debido a restricciones y comportamiento inconsistente del driver Docker en Windows con hostPath, se decidió usar una imagen Docker personalizada como alternativa.
- Esta imagen se genera localmente y contiene todo el contenido del sitio, logrando una solución más simple, portable y funcional.
- Los manifiestos originales de PersistentVolume y PVC también están incluidos en el repositorio como referencia.

 ### Autora
    Guadalupe Aban
    Trabajo para el AT de Cloud Computing – Abril 2025.





