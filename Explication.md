# Explication des critères d'évaluation - Projet PokeClicker

Ce document explique en détail comment l'application Web (Backend PHP & Frontend Admin) et l'application mobile (Flutter) répondent aux différents critères d'évaluation demandés, en s'appuyant sur des exemples concrets directement tirés du code source du projet.

---

## 1. Développer une application web et son API en intégrant les bonnes pratiques de sécurité (Back)

### 1.1 Architecture MVC et opérations CRUD

> **Critère :** L'application Web est développée dans un langage de développement orienté Web. Le code est organisé selon un patron de conception de type MVC. L’application Web permet la manipulation des données (CRUD) de façon fonctionnelle.

**Explication :**
Le backend a été entièrement développé en **PHP natif**. Le code est rigoureusement structuré selon l'architecture **Modèle-Vue-Contrôleur (MVC)** dans le dossier `backend-php/src/` :
- **Modèles (`src/Models/`) :** Les classes héritent d'une classe `Model.php` abstraite qui gère la communication avec Supabase.
- **Vues (`src/Views/`) :** Les interfaces d'administration générées en PHP (ex: `admin_users.php`).
- **Contrôleurs (`src/Controllers/`) :** Orientés API (JSON) ou Vues classiques.

Toutes les opérations **CRUD** sont centralisées dans le modèle de base.
**Exemple concret (Model PHP - `backend-php/src/Models/Model.php`) :**
Le modèle générique définit les signatures réelles utilisées par les entités (`User`, `Pokemon`, `Inventory`) :
```php
abstract class Model {
    protected static string $table = '';
    
    // READ (Récupérer tout ou un ID)
    public static function all(string $select = '*'): array { ... }
    public static function find(int|string $id, string $select = '*'): ?array { ... }

    // CREATE (Avec retour d'erreur détaillé)
    public static function createWithError(array $data, bool $useServiceKey = false): array { ... }

    // UPDATE
    public static function update(int|string $id, array $data, bool $useServiceKey = false): ?array { ... }

    // DELETE
    public static function delete(int|string $id, bool $useServiceKey = false): bool { ... }
}
```

### 1.2 API REST fonctionnelle (Règles de l'art)

> **Critère :** Une API de type REST est développée dans le respect des règles de l’art (traitement de requêtes, gestion des erreurs, gestion des accès, etc.). Elle permet de manipuler toutes les entités avec succès.

**Explication :**
L'API respecte les verbes HTTP (`GET`, `POST`, `PUT`, `DELETE`) et renvoie des codes de statut appropriés. Le contrôleur de base gère l'uniformité des réponses JSON.

**Exemple concret (Validation et Réponse API - `backend-php/src/Controllers/Api/AuthController.php`) :**
Lors de l'inscription, l'API valide les entrées et remonte des erreurs 400 ou 500 structurées :
```php
public function register(): void {
    $input = $this->getJsonInput();

    // Validation stricte des données entrantes (Code HTTP 400)
    if (!$input || !isset($input['username']) || !isset($input['email']) || !isset($input['password'])) {
        $this->error('Username, email and password are required', 400);
        return;
    }

    // Création via le modèle avec gestion d'erreurs d'intégrité
    $result = User::registerWithError($input['username'], $input['email'], $input['password']);

    if (!$result['success']) {
        $this->error('Failed to create user: ' . $result['error'], 500);
        return;
    }

    // Réponse de succès (Code 200 par défaut via Controller::success)
    $this->success([
        'user' => User::toPublic($result['data']),
        'token' => $token
    ], 'Registration successful');
}
```

### 1.3 Gestion des droits/rôles et chiffrement des données

> **Critère :** La gestion de droits et de rôles utilisateurs est présentée. Elle permet de garantir l’intégrité des données. Un chiffrement est réalisé sur au moins une donnée sensible.

**Explication :**
- **Chiffrement :** Les mots de passe sont hachés via `password_hash()` avec `PASSWORD_DEFAULT` (Bcrypt).
- **Droits :** Le système de rôles (`admin`, `player`) est embarqué dans les tokens JWT générés à la connexion, permettant de restreindre l'accès à l'API ou au panel admin.

**Exemples concrets (Hachage - `backend-php/src/Models/User.php`) :**
```php
public static function registerWithError(string $username, string $email, string $password): array {
    // Chiffrement irréversible du mot de passe
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    return self::createWithError([
        'username' => $username,
        'email' => $email,
        'password_hash' => $hashedPassword,
        'pokedollars' => 0,
        // ...
    ], true);
}
```

---

## 2. Développer une interface web dynamique en intégrant les règles d’accessibilité (Front)

### 2.1 Accessibilité numérique (RGAA) et Responsive Design

> **Critère :** Toutes les interfaces sont développées dans le respect des règles d’accessibilité numérique (RGAA). Elles répondent aux objectifs fixés. Elles s’adaptent aux différentes résolutions d’écran (responsive design).

**Explication :**
Le panel admin (`admin_users.php`) intègre des mécanismes d'accessibilité (Navigation clavier, lecteurs d'écran) et un design fluide.

**Exemple concret (HTML/CSS - `backend-php/src/Views/admin_users.php`) :**
```html
<!-- RGAA 1.1 : Lien d'évitement pour les lecteurs d'écran -->
<a href="#main-content" class="skip-link">Aller au contenu principal</a>

<!-- Accessibilité : aria-label pour les boutons iconographiques -->
<button class="btn btn-warning btn-sm"
        data-action="edit-user"
        aria-label="Modifier le profil de ${esc(u.username)}">
    &#9998; Profil
</button>
```
```css
/* RGAA 10.7 : Focus visible pour la navigation au clavier */
:focus-visible { outline: 3px solid #005fcc; outline-offset: 3px; }

/* Responsive : Adaptation des grilles et masquage des colonnes secondaires sur mobile */
@media (max-width: 768px) {
    .card-header { flex-direction: column; align-items: flex-start; }
    .col-email, .col-lifetime, .col-created { display: none; }
}
```

### 2.2 Requêtes AJAX fonctionnelles

> **Critère :** Au moins une requête de type AJAX est présentée. Elle est fonctionnelle.

**Explication :**
L'interface utilise `fetch` pour synchroniser les données sans rechargement.

**Exemple concret (JS - `backend-php/src/Views/admin_users.php`) :**
```javascript
 async function refreshUsers() {
            try {
                const res = await fetch('/admin/api/users', { credentials: 'include' });
                if (!res.ok) { showUsersError('Erreur HTTP ' + res.status); return; }
                const data = await res.json();
                if (data.error) { showUsersError(data.error); return; }
                allUsers = data.users ?? [];
                hideUsersError();
                renderUsers();
                $('users-last-update').textContent = 'Actualisé à ' + nowTime();
                pulseBadge('users-live-badge');
            } catch (err) {
                showUsersError('Erreur réseau : ' + err.message);
            }
        }   
```

### 2.3 Fonctionnalités de Client Riche (RIA)

> **Critère :** Au moins une page de l’application web propose des fonctionnalités de client riche (RIA). Elle est opérationnelle.

**Explication :**
Le panel d'administration (`admin_users.php`) est conçu comme une **Single Page Application (SPA)**. L'utilisateur peut piloter l'ensemble des données (utilisateurs, statistiques, inventaires) sans aucun rechargement de page, offrant une expérience fluide et réactive.

**Mise à jour des statistiques "à la volée" :** La modification des **Pokédollars** (monnaie du jeu) ou des clics totaux s'effectue via des modales asynchrones. Une fois validée par le serveur, la nouvelle valeur est réinjectée dans l'interface sans rafraîchir la page.

**Exemples concrets du comportement RIA (`admin_users.php`) :**
- **Manipulation asynchrone (CRUD indirect) :** L'administrateur peut modifier le niveau d'un Pokémon ou le solde de Pokédollars via une modale, avec mise à jour immédiate du DOM local après confirmation `fetch`.
- **Synchronisation "Live" :** Un système de polling (rafraîchissement automatique toutes les 10s) permet de surveiller l'évolution du solde des joueurs et de leurs captures en temps réel pendant qu'ils sont actifs sur l'application mobile.

**Exemple de code (Mise à jour asynchrone des stats - `admin_users.php`) :**
```javascript
// Sauvegarde des stats (Pokédollars, etc.) via API et rafraîchissement local
$('form-stats').addEventListener('submit', async function (e) {
    e.preventDefault();
    const payload = { pokedollars: parseInt($('f-pokedollars').value) || 0, /* ... */ };

    const res = await fetch(`/admin/api/users/${userId}/stats`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
    });

    if (res.ok) {
        closeStatsModal();
        await refreshUsers(); // UI RIA : Mise à jour de la liste sans rechargement
        showToast('Statistiques mises à jour ✓');
    }
});
```

---

## 3. Développer une application mobile en utilisant une technologie multiplateforme

### 3.1 Framework multiplateforme, Navigation et Widgets natifs

> **Critère :** L’application mobile est développée à l’aide d’un Framework multiplateforme. Elle est opérationnelle et comprend au moins 3 vues liées par un système de navigation. L’ensemble des vues intègre au moins 6 widgets natifs.

**Explication :**
Développée en **Flutter**, l'application utilise `GoRouter` pour l'articulation entre les vues et exploite les widgets Material de Google.

**Exemple concret de navigation (`Flutter/lib/src/routing/app_router.dart`) :**
```dart
final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNotifierProvider);
  return GoRouter(
    initialLocation: '/',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final isLoggedIn = authNotifier.isAuthenticated;
      if (!isLoggedIn) return state.matchedLocation == '/login' ? null : '/login';
      return state.matchedLocation == '/login' ? '/' : null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/', builder: (context, state) => const ClickerScreen()),
      GoRoute(path: '/team', builder: (context, state) => const TeamScreen()),
    ],
  );
});
```
**Widgets natifs utilisés :** `Scaffold`, `AppBar`, `ListView`, `ElevatedButton`, `TextField`, `GridView`.

### 3.2 Exploitation de l'API (Jeu de données réseau)

> **Critère :** L’application mobile manipule un jeu de données issue d’une API. Son exploitation est fonctionnelle et ergonomique.

**Explication :**
En plus de notre propre API PHP pour la sauvegarde, le jeu extrait tout son contenu directement depuis une API REST publique, complète et documentée : la fameuse **PokeAPI**. 
Notre application va chercher, décortiquer et instancier dynamiquement les données asynchrones des Pokémon (noms, statistiques de combat, images des sprites). Le tout est structuré proprement grâce à `Dio` pour les appels HTTP et `fpdart` pour capturer solidement les erreurs (via un type de retour `Either`). 
Sur le plan de l'ergonomie, les images distantes fournies par l'API sont mises en cache (via `CachedNetworkImage`) pour ne pas retarder l'affichage ni épuiser la batterie lors des rencontres successives.

**Exemple concret (Exploitation de la PokeAPI - `Flutter/lib/src/features/pokemon/data/pokemon_repository.dart`) :**
```dart
  /// Fetch a specific Pokemon by ID from PokeAPI
  Future<Either<Failure, Pokemon>> getPokemon(int id) async {
    try {
      // Appel réseau GET ciblé
      final response = await _dio.get('https://pokeapi.co/api/v2/pokemon/$id');

      if (response.statusCode == 200) {
        final data = response.data;

        // Extraction calculée des données imbriquées de l'API JSON
        int hp = 50;
        int attack = 50;
        for (final stat in data['stats'] ?? []) {
          final statName = stat['stat']['name'];
          if (statName == 'hp') hp = stat['base_stat'] ?? 50;
          if (statName == 'attack') attack = stat['base_stat'] ?? 50;
        }

        // Mapping sur le modèle métier interne à l'application
        final pokemon = Pokemon(
          id: data['id'],
          name: _capitalize(data['name']),
          spriteUrl: data['sprites']['front_default'] ?? '',
          hp: hp,
          attack: attack,
        );

        return right(pokemon); // Renvoie les données exploitables de façon sécurisée
      } else {
        return left(const Failure.server('Failed to fetch Pokemon'));
      }
    } on DioException catch (e) {
      // [...] Gestion fine des erreurs réseaux potentielles

    // Apparition d'un pokémon aléatoire de la région Sinnoh pour l'encounter
    Future<Either<Failure, Pokemon>> getRandomSinnohPokemon() async {
    final random = Random();
    final id = sinnohStart + random.nextInt(sinnohEnd - sinnohStart + 1);
    return getPokemon(id);
  }
```

### 3.3 Exploitation des composants matériels du mobile

> **Critère :** L’application mobile exploite de façon opérationnelle au moins 2 composants de l’appareil mobile parmi la géolocalisation, l’appareil photo, le stockage de données, la vibration ou le bluetooth.

**Explication :**
1. **Stockage Local (Disque) :** L'application persiste localement des informations via `shared_preferences`.
2. **Géolocalisation (Capteur GPS) :** Le GPS est sollicité pour horodater et associer des coordonnées spatiales lors des actions de sauvegarde du joueur vers le cloud.
3. **Vibration (Retour Haptique) :** L'application exploite le moteur de vibration physique de l'appareil. Le *gamfeel* est capital dans un jeu de type "Clicker" : chaque interaction avec l'écran (frappe sur le Pokémon, clics sur les boutons) provoque de fines impulsions matérielles, rendant l'interface beaucoup plus impactante et immersive.

**Exemple n°1 (Géolocalisation - `Flutter/lib/src/features/sync/data/cloud_save_repository.dart`) :**
```dart
// Vérification des permissions matérielles
var permission = await Geolocator.checkPermission();
if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
    // Interrogation asynchrone du capteur de haute précision
    Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 5),
        ),
    );
    // Transmet les données de ce composant dans le JSON envoyé à nos serveurs
}
```

**Exemple n°2 (Vibration globale - `Flutter/lib/main.dart`) :**
```dart
      builder: (context, child) {
        // Enveloppe globale interceptant chaque pointeur matériel
        return Listener(
          onPointerDown: (_) async {
            // Lecture instantanée pour savoir si l'appareil a le composant
            if (await Vibration.hasVibrator() == true) {
              // Activation du composant avec le pilotage de sa durée / amplitude
              Vibration.vibrate(duration: 100, amplitude: 128);
            }
          },
          child: child ?? const SizedBox.shrink(),
        );
      },
```
