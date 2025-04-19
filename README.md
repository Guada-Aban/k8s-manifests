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


---

##  Paso a paso para reproducir el entorno

### 1. Clonar los repositorios necesarios

```bash
git clone https://github.com/Guada-Aban/k8s-manifests.git
git clone https://github.com/Guada-Aban/static-website.git
```

### 2. Iniciar minikube

```bash
minikube start --driver=docker
```

### 3. Montar el contenido en Minikube (en una consola separada)
Este paso debe hacerse en una terminal aparte y dejarse abierta durante todo el despliegue.
```bash
minikube mount "<ruta-local-static-website>:/mnt/data"
```
Donde <ruta-local-static-website> es la ruta en su PC donde haya clonado el repo
Por ejemplo:

```bash
minikube mount "C:\Users\profe\Documentos\static-website:/mnt/data"
```

### 4. Aplicar los manifiestos
Desde el directorio `k8s-manifests`:

```bash
kubectl apply -f volumes/static-website-pv.yaml
kubectl apply -f volumes/static-website-pvc.yaml
kubectl apply -f deployments/static-website-deployment.yaml
kubectl apply -f services/static-website-service.yaml
```

### 5. Acceder a la aplicacion

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





