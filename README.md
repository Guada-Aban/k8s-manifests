# k8s-manifests


Este proyecto implementa un sitio web estático servido con NGINX, desplegado sobre Kubernetes utilizando Minikube. 
Se incluye una imagen Docker personalizada que contiene el contenido del sitio web, con manifiestos Kubernetes organizados y listos para aplicar.

---

##  Estructura del repositorio

```
k8s-manifests/
├── deployments/
│ └── static-website-deployment.yaml
├── services/
│ └── static-website-service.yaml
├── volumes/
│ ├── static-website-pv.yaml
│ └── static-website-pvc.yaml
└── README.md
```

---

##  Requisitos

- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- Tener configurado el `minikube mount` hacia `/mnt/data`:

```bash
minikube start --driver=docker --mount --mount-string="C:\ruta\a\static-website:/mnt/data"
```

---

##  Cómo desplegar el sitio

### 1. Aplicar el PersistentVolume:

```bash
kubectl apply -f volumes/static-website-pv.yaml
```

### 2. Aplicar el PersistentVolumeClaim:

```bash
kubectl apply -f volumes/static-website-pvc.yaml

```

### 3. Aplicar el Deployment:
```bash
kubectl apply -f k8s-manifests/deployments/static-website-deployment.yaml

```

### 4. Aplicar el Service:
```bash
kubectl apply -f k8s-manifests/services/static-website-service.yaml

```

### 5. Acceder al sitio:
```bash
minikube service static-website-service

```
Esto abrirá el navegador directamente con la URL local donde está corriendo el sitio.

### Notas sobre la implementación
- El contenido del sitio web (HTML, CSS, imágenes) se encuentra en una carpeta local del host y se monta dentro del contenedor Nginx usando un volumen persistente con hostPath.
- Se utilizó minikube mount para que el directorio local pueda ser accesible desde el contenedor:
- Se descartó el uso de un Dockerfile con una imagen personalizada, ya que la consigna del trabajo práctico indicaba que el contenido debía montarse desde un volumen local.

 ### Autora
    Guadalupe Aban
    Trabajo para el AT de Cloud Computing – Abril 2025.





