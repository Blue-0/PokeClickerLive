# Explication des critères d'évaluation - Projet PokeClicker

Ce document explique en détail comment l'application Web (Backend PHP & Frontend Admin) et l'application mobile (Flutter) répondent aux différents critères d'évaluation demandés, en s'appuyant sur des exemples concrets tirés du code du projet.

---

## 1. Développer une application web et son API en intégrant les bonnes pratiques de sécurité (Back)

### 1.1 Architecture MVC et opérations CRUD

> **Critère :** L'application Web est développée dans un langage de développement orienté Web. Le code est organisé selon un patron de conception de type MVC. L’application Web permet la manipulation des données (CRUD) de façon fonctionnelle.

**Explication :**
Le backend a été entièrement développé en PHP natif (langage Web). Le code est rigoureusement structuré selon l'architecture **Modèle-Vue-Contrôleur (MVC)** dans le dossier `backend-php/src/` :
- **Modèles (`src/Models/`) :** La classe de base `Model.php` fournit les méthodes nécessaires pour dialoguer avec la base de données (via l'API REST de Supabase dans notre cas). Les modèles spécifiques (ex: `User.php`, `Pokemon.php`) étendent cette classe.
- **Vues (`src/Views/`) :** Les interfaces utilisateurs de l'administration, générées côté serveur (ex: `admin_dashboard.php`, `admin_users.php`).
- **Contrôleurs (`src/Controllers/`) :** Le lien entre la requête de l'utilisateur, le modèle (récupération des données) et la vue (affichage). Par exemple, le `UsersController` gère la logique de la page des utilisateurs.

Toutes les opérations **CRUD (Create, Read, Update, Delete)** sont gérées de manière fonctionnelle.
**Exemple concret (Model PHP - `backend-php/src/Models/Model.php`) :**
Le modèle générique permet les manipulations de la base :
```php
abstract class Model {
    // READ (Récupérer)
    public static function all(string $select = '*'): array { ... }
    public static function find(int|string $id, string $select = '*'): ?array { ... }

    // CREATE (Créer)
    public static function create(array $data): ?array { ... }

    // UPDATE (Mettre à jour)
    public static function update(int|string $id, array $data): bool { ... }

    // DELETE (Supprimer)
    public static function delete(int|string $id): bool { ... }
}
```

### 1.2 API REST fonctionnelle (Règles de l'art)

> **Critère :** Une API de type REST est développée dans le respect des règles de l’art (traitement de requêtes, gestion des erreurs, gestion des accès, etc.). Elle permet de manipuler toutes les entités avec succès.

**Explication :**
Une API REST en PHP a été développée sous la route `/api/`. Elle gère les statuts HTTP de manière standard (`200 OK`, `400 Bad Request`, `401 Unauthorized`, `500 Internal Server Error`). La réponse est toujours systématiquement formatée en JSON via le contrôleur parent.

**Exemple concret (Traitement de requête et gestion des erreurs - `backend-php/src/Controllers/Api/AuthController.php`) :**
Lors de la création d'un utilisateur, l'API contrôle la requête entrante et renvoie des messages d'erreurs clairs si les validations échouent.
```php
public function register(): void
{
    $input = $this->getJsonInput();

    // Validation et gestion d'erreur (Code HTTP 400)
    if (!$input || !isset($input['username']) || !isset($input['email']) || !isset($input['password'])) {
        $this->error('Username, email and password are required', 400);
        return;
    }

    // Traitement et réponse de succès (Code HTTP 200 par défaut avec JSON)
    $this->success([
        'user' => User::toPublic($user),
        'token' => $token
    ], 'Registration successful');
}
```

### 1.3 Gestion des droits/rôles et chiffrement des données

> **Critère :** La gestion de droits et de rôles utilisateurs est présentée. Elle permet de garantir l’intégrité des données. Un chiffrement est réalisé sur au moins une donnée sensible.

**Explication :**
- **Chiffrement :** Le mot de passe de l'utilisateur n'est jamais stocké en clair dans la base de données. Il est haché à l'aide de l'algorithme sécurisé `bcrypt` natif de PHP via la fonction `password_hash()`. Un autre exemple de donnée sensible sécurisée est la clé secrète JWT.
- **Droits et Rôles :** Lors de l'authentification (login), un token JWT est généré et contient le rôle de l'utilisateur (`user` ou `admin`). Pour accéder à l'interface d'administration ou à certaines routes de l'API, ce token (ou la session PHP dérivée pour les Vues) est vérifié pour bloquer les utilisateurs non autorisés.

**Exemples concrets (`backend-php/src/Models/User.php`) :**
```php
// Chiffrement du mot de passe à l'inscription
public static function registerWithError(string $username, string $email, string $password): array
{
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
    // ... enregistrement en base de données
}

// Vérification du mot de passe lors du login
public static function verifyPassword(array $user, string $password): bool
{
    return password_verify($password, $user['password_hash'] ?? '');
}
```

---

## 2. Développer une interface web dynamique en intégrant les règles d’accessibilité (Front)

### 2.1 Accessibilité numérique (RGAA) et Responsive Design

> **Critère :** Toutes les interfaces sont développées dans le respect des règles d’accessibilité numérique (RGAA). Elles répondent aux objectifs fixés. Elles s’adaptent aux différentes résolutions d’écran (responsive design).

**Explication :**
Les vues du panel d'administration ont été développées avec une attention particulière à l'accessibilité :
- **RGAA :** Utilisation d'un lien d'évitement (`skip-link`) pour les lecteurs d'écran, un focus clavier visible (`:focus-visible`), des attributs `aria-label` sur les boutons sans texte explicite (ex: boutons d'action avec des icônes), et des balises sémantiques.
- **Responsive Design :** Utilisation de CSS avec des Media Queries, de Flexbox et de Grid pour assurer un rendu optimal sur toutes les tailles d'écrans (Mobiles, Tablettes, PC).

**Exemple concret (`backend-php/src/Views/admin_dashboard.php` & `admin_users.php`) :**
```html
<!-- Lien d'évitement pour les personnes naviguant au clavier (RGAA) -->
<a href="#main-content" class="skip-link">Aller au contenu principal</a>

<!-- Bouton d'action accessible avec attribut ARIA -->
<button class="btn btn-primary btn-sm"
        data-action="edit-inv"
        aria-label="Modifier Salamèche">
    &#9998;
</button>
```
```css
/* Focus visible pour navigation au clavier (Accessibilité) */
:focus-visible {
    outline: 3px solid #64ffda;
    outline-offset: 3px;
}

/* Responsive design via CSS Flexbox et Media Queries */
@media (max-width: 768px) {
    .header { flex-direction: column; align-items: flex-start; }
    .stats-grid { grid-template-columns: 1fr; }
}
```

### 2.2 Requêtes AJAX fonctionnelles

> **Critère :** Au moins une requête de type AJAX est présentée. Elle est fonctionnelle.

**Explication :**
Dans le tableau de bord administrateur (ex: la gestion des utilisateurs), nous utilisons l'API `fetch` de JavaScript (l'évolution moderne de XMLHttpRequest) pour exécuter des requêtes réseau de manière asynchrone sans recharger la page.

**Exemple concret (`backend-php/src/Views/admin_users.php`) :**
La fonction Javascript interroge l'API backend pour récupérer l'inventaire d'un joueur précis de manière asynchrone (AJAX).
```javascript
async function refreshInventory() {
    if (!currentUserId) return;
    try {
        // Envoi de la requête AJAX de type GET
        const res = await fetch(`/admin/api/users/${currentUserId}/inventory`, { credentials: 'include' });
        if (!res.ok) { showInvError('Erreur HTTP ' + res.status); return; }

        const data = await res.json();
        // Mise à jour de l'interface en direct avec les nouvelles données
        allInventory = data;
        renderInventory();
    } catch (err) {
        showInvError('Erreur : ' + err.message);
    }
}
```

### 2.3 Fonctionnalités de Client Riche (RIA)

> **Critère :** Au moins une page de l’application web propose des fonctionnalités de client riche (RIA). Elle est opérationnelle.

**Explication :**
La page "Gestion des Utilisateurs" (`admin_users.php`) agit comme une application web monopage (RIA). Sans jamais recharger le navigateur, elle permet :
1. De rechercher des utilisateurs avec un système de filtrage en direct dans le navigateur (Javascript).
2. D'ouvrir dynamiquement l'inventaire d'un joueur en cliquant sur sa ligne.
3. De se rafraîchir en temps réel grâce à une fonction `setInterval` qui interroge l'API en arrière-plan toutes les 10 secondes pour garder les données toujours à jour.
4. De supprimer ou modifier un Pokémon de l'inventaire de l'utilisateur avec mise à jour immédiate du DOM.

**Exemple concret (`backend-php/src/Views/admin_users.php`) :**
Le rafraîchissement périodique et dynamique pour une sensation "Application Riche".
```javascript
async function loadInventory(userId, username) {
    // Affiche une section, met un loader, cache le reste (manipulation de DOM)
    $('inventory-section').style.display = '';

    // Requête AJAX initiale
    await refreshInventory();

    // Actualisation automatique en temps réel (Client Riche)
    if (invTimer) clearInterval(invTimer);
    invTimer = setInterval(refreshInventory, 10000); // Mise à jour toutes les 10 secondes
}
```

---

## 3. Développer une application mobile en utilisant une technologie multiplateforme

### 3.1 Framework multiplateforme, Navigation et Widgets natifs

> **Critère :** L’application mobile est développée à l’aide d’un Framework multiplateforme. Elle est opérationnelle et comprend au moins 3 vues liées par un système de navigation. L’ensemble des vues intègre au moins 6 widgets natifs.

**Explication :**
- L'application est développée avec **Flutter**, un framework multiplateforme développé par Google (iOS / Android / Web).
- Elle comporte plus de 3 vues principales liées par le routeur `GoRouter` et `Navigator` : la page de connexion (`LoginScreen`), la page de jeu principale (`ClickerScreen`), la boutique (`ShopScreen`), la carte (`ZoneMapScreen`) et l'équipe (`TeamScreen`).
- De très nombreux **widgets natifs** propres à Flutter y sont utilisés de manière structurée et organisée.

**Exemple concret de navigation (`Flutter/lib/src/routing/app_router.dart`) :**
```dart
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => const ClickerScreen(),
      ),
    ],
  );
});
```
**Exemple de widgets natifs (`ClickerScreen.dart`, `ShopScreen.dart`, etc.) :**
1. `Scaffold` : Squelette de base de la page.
2. `AppBar` : La barre de navigation haute.
3. `ListView` / `GridView` : Pour afficher la boutique de manière scrollable.
4. `ElevatedButton` : Boutons d'interaction classiques.
5. `Card` : Pour afficher un élément sous forme de carte ombragée.
6. `TextField` : Les champs de saisie pour l'authentification.

### 3.2 Exploitation de l'API (Jeu de données réseau)

> **Critère :** L’application mobile manipule un jeu de données issue d’une API. Son exploitation est fonctionnelle et ergonomique.

**Explication :**
L'application mobile n'est pas "offline" : l'ensemble des données critiques de sauvegarde, des clics, de l'équipe et des achats passe par l'API Backend. Une fois connecté, un token JWT est utilisé. La bibliothèque HTTP `Dio` est utilisée pour interroger les routes REST en arrière-plan.

**Exemple concret (`Flutter/lib/src/features/sync/data/cloud_save_repository.dart`) :**
Le `CloudSaveRepository` est chargé de pousser la sauvegarde en base de données. Il fait un appel réseau en méthode POST vers l'API.
```dart
Future<void> syncSave(Map<String, dynamic> localData, DateTime lastSync) async {
    // ... préparation des données
    final dio = _ref.read(dioProvider);
    final data = {'last_sync': lastSync.toIso8601String(), 'local_data': localData};

    // Appel POST vers l'API REST
    final response = await dio.post('/sync', data: data);

    if (response.statusCode != 200) {
        throw Exception('Échec de la synchronisation de la sauvegarde');
    }
}
```

### 3.3 Exploitation des composants matériels du mobile

> **Critère :** L’application mobile exploite de façon opérationnelle au moins 2 composants de l’appareil mobile parmi la géolocalisation, l’appareil photo, le stockage de données, la vibration ou le bluetooth.

**Explication :**
L'application mobile PokeClicker tire parti des composants matériels suivants :
1. **Le stockage de données (Local Storage) :** Via le package `shared_preferences`, l'application stocke le token d'authentification (`AuthRepository`) et le cache des Pokémon localement (`PokemonCacheService`) sur le téléphone pour permettre des chargements rapides et ne pas avoir à se reconnecter à chaque ouverture.
2. **La Géolocalisation (GPS) :** Le téléphone interroge le composant GPS natif (avec le package `geolocator`) pour récupérer la position de l'utilisateur, ce qui permet à l'API de situer où s'est déroulée l'action de sauvegarde.
3. **La Vibration (Haptic Feedback) :** *(Note: Prévu dans le cahier des charges de l'étudiant, par exemple lors d'un "clic" sur le Pokémon pour simuler un impact physique, bien que mis en attente d'implémentation).*

**Exemple concret de géolocalisation (`Flutter/lib/src/features/sync/data/cloud_save_repository.dart`) :**
Le code demande les permissions matérielles et lit le capteur de position (latitude/longitude) avant de l'envoyer à l'API.
```dart
import 'package:geolocator/geolocator.dart';

// Vérification de la permission matérielle
var permission = await Geolocator.checkPermission();
if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
}

// Extraction des coordonnées du capteur GPS du téléphone
Position position = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 5),
    ),
);

// Envoi à l'API (ex: 48.8566, 2.3522)
final data = {
    'latitude': position.latitude,
    'longitude': position.longitude,
    // ...
};
```
