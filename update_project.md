# 📘 Documentation Technique - Projet PokeClicker

**Projet :** Jeu Idle/Clicker Pokémon (Sinnoh Region)
**Architecture :** Hybride Web (PHP MVC) + Mobile (Flutter)
**Base de Données :** PostgreSQL (Supabase)
**API Externe :** PokéAPI v2 (avec cache local)

***

## 1. 🏗️ Architecture Globale

Le projet respecte scrupuleusement les contraintes du sujet d'évaluation (Bloc 3) : séparation stricte entre le backend PHP (Web/API) et le client mobile Flutter.

```mermaid
graph TD
    UserWeb[Navigateur Web<br>(Admin Dashboard)] -->|HTML/CSS| PHP[Backend PHP<br>(MVC Natif)]
    UserMobile[App Flutter<br>(Android/iOS)] -->|JSON/JWT| PHP
    
    subgraph "Backend PHP"
        Router[Routeur MVC]
        Controller[Contrôleurs API & Web]
        Model[Modèles de Données]
        Service[Services Métier<br>(Auth, Game Logic)]
    end
    
    PHP --> Router
    Router --> Controller
    Controller --> Model
    Model -->|Cache JSON| PokeAPI[PokéAPI v2<br>(Données Réf.)]
    Model -->|REST/cURL| Supabase[(Supabase DB<br>PostgreSQL)]
```


### Structure des Dossiers

```text
/pokeclicker-project
│
├── backend-php/              # 🟢 PARTIE 1 : BACKEND & WEB
│   ├── public/               # Document Root (index.php, .htaccess)
│   ├── src/
│   │   ├── Config/           # Database.php, Constants
│   │   ├── Controllers/      # AdminController, Api/PokemonController
│   │   ├── Models/           # User.php, Pokemon.php (Hybrid Cache)
│   │   ├── Views/            # Templates HTML (Admin)
│   │   └── Utils/            # Router.php, JWT Helper
│   └── cache/                # Cache local JSON des données PokéAPI
│
├── mobile-flutter/           # 🔵 PARTIE 2 : APP MOBILE
│   ├── lib/
│   │   ├── data/             # Repositories & API Services
│   │   ├── domain/           # Logique Métier Flutter
│   │   └── presentation/     # Screens & Widgets (Pixel Art)
│   └── assets/               # Images & Polices
│
└── README.md
```


***

## 2. 🗄️ Base de Données (PostgreSQL / Supabase)

Schéma relationnel optimisé pour un jeu Idle, compatible PostgreSQL.

### Tables Principales

* **`users`** : Comptes joueurs, solde (₽), stats globales, position GPS.
* **`user_pokemon`** : Inventaire (PC) reliant un `user_id` à un `pokemon_id` (ID PokéAPI).
* **`user_upgrades`** : Améliorations achetées (Multiplicateurs).
* **`transaction_logs`** : Audit trail de toutes les actions (Anti-triche).
* **`ref_upgrades`** \& **`ref_infrastructures`** : Données statiques du jeu (hors Pokémon).

> **Note :** La table `ref_pokemon` a été remplacée par une consommation directe de PokéAPI avec cache local pour alléger la BDD et avoir des images à jour.

***

## 3. 💻 Backend PHP (MVC Sans Framework)

Développement "From Scratch" pour respecter la contrainte pédagogique.

### Composants Clés Implémentés

1. **Routeur (`Router.php`)** : Dispatche les requêtes HTTP vers les bons contrôleurs (`/api/...` ou `/admin/...`).
2. **Connexion BDD (`Database.php`)** : Classe Singleton utilisant `cURL` pour communiquer avec l'API REST de Supabase (évite d'exposer le port 5432).
3. **Modèle Hybride (`Pokemon.php`)** :
    * Vérifie si le Pokémon est en cache local (`json`).
    * Sinon, appelle `https://pokeapi.co/api/v2/pokemon/{id}`.
    * Calcule dynamiquement le **Coût** et le **RPS** (Revenu par Seconde) basé sur les stats officielles (XP, Attaque).

### Exemple de Code (Modèle Pokémon)

```php
// Extrait de src/Models/Pokemon.php
public function get($id) {
    $data = $this->fetchFromApiOrCache($id); // Gestion Cache + API
    return [
        'id' => $data['id'],
        'name' => ucfirst($data['name']),
        'sprite' => $data['sprites']['front_default'],
        // Règles Métier PokeClicker
        'price' => $data['base_experience'] * 15,
        'production' => round($data['stats'][^0]['base_stat'] / 10, 2)
    ];
}
```


***

## 4. 📱 Application Mobile (Flutter)

Architecture prévue (Clean Architecture) pour consommer l'API PHP.

### Fonctionnalités Prévues

* **Authentification JWT** : Login/Register via l'API PHP.
* **Infinite Scroll** : Chargement des Pokémon par paquets de 20 (Pagination API).
* **Géolocalisation** : Envoi de la position GPS lors de la capture/achat.
* **Pixel Art UI** : Interface rétro style Nintendo DS.

***

## 5. ✅ Checklist de Conformité (Sujet d'Évaluation)

| Critère | État | Solution Technique |
| :-- | :--: | :-- |
| **Langage Web** | ✅ | PHP 8.x Natif (Pas de Framework) |
| **Architecture** | ✅ | MVC (Model-View-Controller) |
| **API REST** | ✅ | Endpoints JSON (`/api/pokemon`, `/api/auth`) |
| **Mobile** | 🔄 | Flutter (Architecture définie, à coder) |
| **Base de Données** | ✅ | Supabase (PostgreSQL) |
| **Sécurité** | ✅ | JWT Auth + Protection CSRF prévue |
| **Données Ext.** | ✅ | Intégration PokéAPI v2 (Respect Fair Use) |
| **CRUD Admin** | 🔄 | Contrôleurs Admin à finaliser |


***

## 🛠️ Prochaines Étapes

1. **Finaliser l'API PHP** : Créer les endpoints pour l'inscription (`register`) et le login (`login`) générant un JWT.
2. **Développer le Frontend Admin** : Créer les vues HTML/CSS pour gérer les utilisateurs et voir les logs.
3. **Démarrer Flutter** : Initialiser le projet mobile et connecter le premier écran (Login) à l'API PHP.