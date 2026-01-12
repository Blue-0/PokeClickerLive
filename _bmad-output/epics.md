# PokeClicker - Development Epics

## Epic Overview

| # | Epic Name | Scope | Dependencies | Est. Stories |
|---|---|---|---|---|
| 1 | **The Core Loop (MVP)** | Base mechanics (Click, Earn, Upgrade) | None | 5 |
| 2 | **Data & Assets (Pokédex)** | PokéAPI integration & Data integrity | Epic 1 | 4 |
| 3 | **World & Progression (Map)** | Navigation, Route Logic, Unlock System | Epic 1, 2 | 6 |
| 4 | **Combat Systems (Battle)** | Team DPS, Boss Timers, Capture Rate | Epic 2, 3 | 7 |
| 5 | **Economy & Meta (Shop)** | Shops, Save Cloud, Prestige | Epic 1, 4 | 5 |
| 6 | **Polish & UI (Juice)** | Final Art, Sound, Responsive, Mobile UX | Epic 1-5 | 8 |

---

## Epic 1: The Core Loop (MVP)

### Goal
Créer une boucle de jeu fonctionnelle minimale (MVP) où le joueur peut cliquer, gagner des ressources et acheter une amélioration.

### Scope
**Includes:**
*   Interface de base (placeholder).
*   Mécanique de Clic (Dégats sur une "hitbox").
*   Gain de monnaie (Money).
*   Achat d'un objet simple (Upgrade de Clic).

**Excludes:**
*   Sprites Pokémon réels (Carrés rouges pour l'instant).
*   Sauvegarde.
*   Carte du monde.

### Dependencies
None

### Deliverable
Une page web/mobile où cliquer rapporte de l'argent et permet d'acheter un bonus qui fait gagner plus d'argent.

### Stories
*   As a player, I can click on a target to deal damage and earn currency.
*   As a player, I can see my current currency balance update in real-time.
*   As a player, I can purchase a "Click Upgrade" to increase my damage per click.
*   As a developer, I have a basic Flutter project setup with a clean architecture.

---

## Epic 2: Data & Assets (Pokédex)

### Goal
Intégrer la richesse des données Pokémon (Gen 4) via PokéAPI pour remplacer les placeholders.

### Scope
**Includes:**
*   Service PokéAPI.
*   Modèle de données Pokémon (Nom, ID, Type, Stats).
*   Affichage des Sprites (Cache local).

**Excludes:**
*   Combat complexe (Juste affichage visuel).

### Dependencies
Epic 1

### Deliverable
Le "Carré Rouge" de l'MVP est remplacé par un vrai Tortipouss qui a un nom et une barre de vie correcte.

### Stories
*   As a developer, I can fetch Pokémon data (ID, Name, Sprite) from PokéAPI.
*   As a player, I see the correct sprite for the current Pokémon.
*   As a system, I cache sprites locally to avoid fetching them at every encounter.

---

## Epic 3: World & Progression (Map)

### Goal
Implémenter la structure géographique de Sinnoh et la logique de progression par zone.

### Scope
**Includes:**
*   Navigation (Boutons Route/Ville).
*   Logique de Spawn par Route (Table de Butin).
*   Condition de déblocage (Kill Count).

**Excludes:**
*   Système de Donjon (Mise/Betting).

### Dependencies
Epic 1, 2

### Deliverable
Le joueur peut voyager de la Route 201 à Sandgem Town après avoir vaincu 10 Pokémon.

### Stories
*   As a player, I can switch between unlocked zones via a menu/map.
*   As a player, I encounter different Pokémon depending on the active Route.
*   As a system, I unlock Route 202 only after the player defeats 10 Pokémon on Route 201.

---

## Epic 4: Combat Systems (Battle)

### Goal
Apporter la profondeur stratégique avec la gestion de l'équipe, le DPS passif et les Boss.

### Scope
**Includes:**
*   Équipe Active (6 Slots).
*   Calcul DPS (Passif + Actif).
*   Mécanique de Capture (RNG).
*   Boss Logic (Timer).

**Excludes:**
*   PVP.

### Dependencies
Epic 2, 3

### Deliverable
Un combat complet avec capture, gestion d'équipe et un Boss de fin de route tuable au timer.

### Stories
*   As a player, I can capture a defeated Pokémon and add it to my collection.
*   As a player, I can select 6 Pokémon to form my Active Team.
*   As a player, my Active Team deals passive damage per second to the enemy.
*   As a player, I must defeat a Boss within a time limit to clear a zone.

---

## Epic 5: Economy & Meta (Shop)

### Goal
Finaliser les boucles économiques, la persistance et le Prestige.

### Scope
**Includes:**
*   Boutiques (Poké Mart).
*   Dungeon Tokens (Gain).
*   Supabase Integration (Auth/Save).
*   Prestige (Stat Reset + Badge).

**Excludes:**
*   Microtransactions réelles.

### Dependencies
Epic 1, 4

### Deliverable
Un jeu complet où l'on peut sauvegarder, acheter des objets et recommencer (Prestige).

### Stories
*   As a player, I can buy Pokéballs and Potions in the Shop.
*   As a player, my progress is automatically saved to the cloud.
*   As a player, I can perform a Prestige Reset to gain Badges and multipliers.

---

## Epic 6: Polish & UI (Juice)

### Goal
Sublimer l'expérience utilisateur pour atteindre la qualité "Premium".

### Scope
**Includes:**
*   Mobile Layout (Persistent Header).
*   Pixel Art Final (UI, Fonts).
*   Audio (SFX, Music).
*   Animations (Feedback Clic, Capture).

**Excludes:**
*   Contenu DLC.

### Dependencies
Epic 1-5

### Deliverable
La version 1.0 du jeu ("Gold Master").

### Stories
*   As a mobile player, I see the Battle Header persistently while browsing tabs.
*   As a player, I hear 8-bit sound effects when interacting with the UI.
*   As a player, I see visual particles (Cash/Damage) when clicking.
