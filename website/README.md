# Ndmr Website

Site web statique pour [ndmr.app](https://ndmr.app)

## Structure

```
website/
├── index.html          # Page principale
├── css/
│   └── style.css       # Styles
├── js/
│   └── main.js         # Scripts
├── img/
│   └── favicon.svg     # Icône
├── infra/
│   └── main.tf         # Infrastructure Terraform
├── deploy.sh           # Script de déploiement
└── README.md
```

## Déploiement

### Prérequis

- AWS CLI configuré avec les credentials appropriés
- Terraform >= 1.0 (pour l'infrastructure)

### 1. Créer l'infrastructure (première fois)

```bash
cd infra

# Initialiser Terraform
terraform init

# Prévisualiser les changements
terraform plan

# Appliquer
terraform apply
```

Terraform va créer :
- Bucket S3 pour héberger le site
- Distribution CloudFront avec HTTPS
- Certificat ACM pour le domaine

**Important** : Après `terraform apply`, vous devrez :
1. Ajouter les enregistrements DNS de validation ACM dans votre registrar
2. Attendre la validation du certificat (~5 minutes)
3. Ajouter un CNAME `ndmr.app` → `<cloudfront_domain>.cloudfront.net`

### 2. Déployer le site

```bash
# Configuration
export BUCKET_NAME=ndmr.app
export DISTRIBUTION_ID=<votre-distribution-id>

# Déployer
./deploy.sh
```

Le script va :
- Synchroniser les fichiers vers S3
- Configurer les en-têtes de cache
- Invalider le cache CloudFront

### Développement local

Ouvrir `index.html` dans un navigateur ou utiliser un serveur local :

```bash
# Python
python3 -m http.server 8000

# Node.js
npx serve .
```

## Personnalisation

### Modifier le contenu

Éditer `index.html` pour :
- Mettre à jour la version
- Ajouter des captures d'écran
- Modifier les liens de téléchargement

### Modifier le style

Le fichier `css/style.css` utilise des variables CSS pour les couleurs :

```css
:root {
    --color-primary: #6366f1;
    --color-secondary: #10b981;
    /* ... */
}
```

Le thème sombre est automatique via `@media (prefers-color-scheme: dark)`.

## Coûts AWS estimés

| Service | Coût mensuel estimé |
|---------|---------------------|
| S3 | < $0.50 |
| CloudFront | < $1 (selon trafic) |
| Route 53 | $0.50/zone |
| **Total** | **~$2/mois** |
