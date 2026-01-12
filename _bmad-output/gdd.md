---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
inputDocuments: []
documentCounts:
  briefs: 0
  research: 0
  brainstorming: 0
  projectDocs: 0
workflowType: 'gdd'
lastStep: 0
project_name: 'PokeClickerLive'
user_name: 'Denis'
date: '2026-01-12'
game_type: 'idle-incremental'
game_name: 'PokeClicker'

---

# PokeClicker - Game Design Document

**Author:** Denis
**Game Type:** Idle/Incremental
**Target Platform(s):** Web (PC), Android (Mobile)

---

## Executive Summary

### Game Name

PokeClicker

### Core Concept

PokeClicker est un jeu Idle/Incremental cross-platform qui fusionne les mécaniques addictives de croissance exponentielle (type Cookie Clicker) avec l'univers de collection de Pokémon (Génération 4 - Diamant/Perle). Le jeu propose une esthétique Pixel Art fidèle à l'interface Nintendo DS de 2006 pour invoquer une forte nostalgie, tout en modernisant l'expérience avec une persistance cloud via Supabase.

Le gameplay s'articule autour de deux boucles interconnectées : une phase active de "Clic" pour capturer des Pokémon et générer du cash immédiat, et une phase passive de gestion où les Pokémon capturés deviennent des unités de production automatisées. L'objectif est double : optimiser le rendement économique (₽/sec) tout en complétant le Pokédex, transformant chaque capture en un investissement stratégique plutôt qu'un simple trophée.

L'expérience vise à offrir une satisfaction immédiate ("crunchy") et une progression infinie, permettant aux joueurs de commencer une session sur navigateur au bureau et de la poursuivre sans interruption sur mobile, capitalisant sur des sessions courtes mais fréquentes et un engagement à long terme.

### Game Type

**Type:** Idle/Incremental
**Framework:** This GDD uses the idle-incremental template with type-specific sections for idle, incremental, automation, progression

### Target Audience

**Âge:** 25-35 ans (Génération ayant grandi avec Pokémon Diamant/Perle sur DS).
**Profil:** Fans de Pokémon nostalgiques et amateurs de jeux incrémentaux.

### Unique Selling Points (USPs)

{{unique_selling_points}}

---

## Goals and Context

### Project Goals

1.  **Apprentissage & Portfolio:** Utiliser ce projet comme un cas d'étude complet pour maîtriser Flutter et créer une pièce maîtresse pour mon portfolio de développeur.
2.  **Premier Navire:** Mener un projet de jeu complet de la conception à une version jouable et polie (Vertical Slice), brisant la boucle des projets inachevés.
3.  **Motivation Technique:** Construire une architecture cross-platform propre et performante (Flutter + Supabase + PHP) sur un sujet passionnant (Pokémon) pour maintenir la motivation sur le long terme.

### Background and Rationale

Ce projet naît d'une volonté de combiner l'utile à l'agréable : apprendre une technologie moderne (Flutter) en travaillant sur un univers de cœur. Le marché manque de jeux incrémentaux qui respectent l'identité visuelle et sonore des jeux originaux dont ils s'inspirent. *PokeClicker* vise à combler ce vide en offrant une expérience qui ne ressemble pas à un "clone bon marché", mais à une extension naturelle de l'univers Pokémon sur un nouveau genre.

---

## Unique Selling Points (USPs)

1.  **Collection Significative:** Contrairement aux clickers classiques où les unités sont interchangeables ("Grand-mère n°50"), ici chaque unité de production est un Pokémon unique capturé. L'optimisation économique (DPS/Production) est indissociable du plaisir de collectionner (Pokédex).
2.  **Fidélité Esthétique (Gen 4):** Une direction artistique Pixel Art rigoureuse qui reproduit l'interface utilisateur (UI), les polices et les sons de la Nintendo DS (Diamant/Perle), créant une immersion nostalgique immédiate.
3.  **Seamless Cross-Platform:** Une expérience technique fluide où la transition entre le navigateur (PC/Travail) et le mobile (Android/Transport) est instantanée et invisible pour le joueur, grâce à une architecture cloud réactive.

### Competitive Positioning

*PokeClicker* se positionne non pas comme un concurrent des jeux officiels, mais comme le "compagnon de productivité" ultime pour les fans. Là où les jeux officiels demandent 100% d'attention, *PokeClicker* offre la satisfaction de l'univers Pokémon dans les interstices de la vie quotidienne, avec un niveau de finition (polish) rarement vu dans les fan-games web.

---

## Core Gameplay

### Game Pillars

1.  **Chaque Clic Compte:** L'action du joueur (Battle Click) doit toujours avoir une récompense tangible et immédiate (Cash ou Capture/Exp), éliminant tout sentiment de temps mort.
2.  **Collection Utile:** Chaque Pokémon capturé a une valeur économique. Aucun n'est inutile ; même les plus faibles (early game) contribuent au rendement global et peuvent devenir cruciaux grâce aux synergies de type.
3.  **Seamless Cross-Platform:** L'expérience technique prime. La transition entre PC et Mobile doit être invisible et sans friction, garantissant que le joueur peut optimiser son empire n'importe où.

**Pillar Prioritization:**
Seamless Cross-Platform > Collection Utile > Chaque Clic Compte
(La stabilité technique est le socle ; la collection est le cœur du design ; le clic est l'interaction de base).

### Core Gameplay Loop

Le jeu s'articule autour de trois boucles temporelles imbriquées :

1.  **Boucle Active (Seconde par Seconde):**
    *   **Action:** Le joueur clique/tape sur un Pokémon sauvage (Combat).
    *   **Feedback:** Animation de recul, flash, particule de dégâts/cash, son 8-bit.
    *   **Récompense:**
        *   Cash immédiat (Dégâts + % Revenu).
        *   Roll de Capture (RNG) : Si succès, +1 Pokémon dans l'inventaire ("PC").
    *   **Progression:** Apparition d'un nouveau Pokémon (cycle de spawn basé sur la zone débloquée). Chance rare d'apparition Shiny.

2.  **Méta-Boucle de Gestion (Minutes/Heures):**
    *   **Action:** Le joueur dépense le Cash accumulé.
    *   **Investissement:**
        *   Achat d'Objets d'Automatisation (Encens) pour capturer sans cliquer.
        *   Achat d'Infrastructures (Arènes, Centrales) pour débloquer des zones ou créer des synergies de type.
    *   **Feedback:** Augmentation du Revenu par Seconde (RPS) affiché.
    *   **Effet:** Les Pokémon stockés dans le PC génèrent du revenu passif (1 Étourmi = 1₽/s). Les synergies revalorisent les anciens Pokémon (ex: Centrale booste les types Électrik).

3.  **Boucle de Prestige "Nouvelle Aventure" (Jours/Semaines):**
    *   **Condition:** Progression ralentie ("Soft Wall") + 1 Million ₽ gagnés au total.
    *   **Action:** Reset via le "Professeur Sorbier" (Nouvelle Aventure).
    *   **Perte:** Cash, Pokémon communs, Infrastructures.
    *   **Conservation:** Shinies, Stats, Monnaie Premium.
    *   **Gain:** "Badges de Dresseur" (Monnaie de Prestige).
    *   **Effet:** Bonus multiplicatif massif aux revenus (+10%/Badge) et accès à la boutique "Battle Frontier" (Objets Rares).
    *   **Résultat:** Recommencer le jeu avec une vitesse démultipliée.

**Loop Diagram:**
[Clic/Capture] --> [Cash] --> [Investissement Infrastructure/PC] --> [Augmentation RPS] --> [Déblocage Zones] --> [Nouveaux Pokémon] --> [Retour Clic]
          ^                                                                                                   |
          |-----------------------------------(Prestige / Reset)----------------------------------------------|

**Loop Timing:** Boucle courte : < 1 sec. Boucle moyenne : 5-15 min. Boucle Prestige : 3-7 jours (initialement).

**Loop Variation:** L'introduction de nouvelles Zones et Synergies change constamment la "Méta" du joueur (quel type chasser ?), tandis que la chasse aux Shinies offre des pics d'excitation imprévisibles.

### Win/Loss Conditions

#### Victory Conditions

**Objectif Ultime:** Complétion à 100% du Pokédex National en version Shiny.
Cela nécessite de déclencher un Événement Spécial "Post-Endgame" (à définir).
C'est une victoire de complétionniste, marquant la maîtrise totale du système.

#### Failure Conditions

Il n'y a pas de "Game Over" traditionnel (c'est un Idle Game).
**Défaite:** Progression inefficace. Le joueur peut se retrouver bloqué face à un mur de coût exponentiel s'il n'optimise pas ses synergies ou s'il refuse de Prestige au bon moment ("Softlock" psychologique).

#### Failure Recovery

Le Prestige est l'outil de récupération ultime. Si la progression stagne, le reset débloque la situation par la force mathématique des multiplicateurs.

---

## Game Mechanics

### Primary Mechanics

1.  **Battle Click (Active):** Interaction principale. Le joueur clique sur le Pokémon sauvage (zone gauche).
    *   *Effet:* Inflige des dégâts, génère des ₽ immédiats, et lance un roll de capture automatique.
    *   *Progression:* Le DPC (Dégâts Par Clic) augmente avec les items (Super Rod) et les badges.

2.  **Gestion PC (Passive):** Gestion des revenus automatisés (zone centrale).
    *   *Action:* Consulter les Pokémon capturés qui génèrent des ₽/sec.
    *   *Mécanique de Fusion:* Le joueur peut fusionner 3 Pokémon identiques (ex: 3 Étourmis) pour obtenir 1 évolution (1 Étourvol), augmentant drastiquement la production par unité et libérant de la place.

3.  **Exploration & Progression (Unlock):**
    *   *Action:* Combattre un nombre défini de Pokémon (ex: 10) dans la zone actuelle (Route 201) pour débloquer la suivante (Route 202).
    *   *Choix:* Aux intersections (villes), le joueur choisit via une UI de carte vers quelle route adjacente se déplacer pour chasser des types spécifiques.

4.  **Investissement (Shop):** Achat d'upgrades (zone droite).
    *   *Items:* Bonus passifs (Sac, Canne à pêche) ou actifs (Pokéballs).
    *   *Infrastructures:* Bâtiments coûteux débloquant des synergies (ex: Mine de Charbourg).

### Mechanic Interactions

*   **Fusion & Collection:** La fusion "consomme" des Pokémon, créant une tension entre garder une large armée de base ou avoir quelques unités d'élite évoluées.
*   **Combat & Exploration:** Le clic actif est nécessaire pour "grind" les 10 kills requis pour changer de zone, forçant le joueur à sortir de son mode passif pour progresser géographiquement.

---

## Controls and Input

### Control Scheme (PC & Mobile)

L'interface est conçue autour d'un **Layout Réactif** qui s'adapte à la plateforme tout en conservant le style Pixel Art.

| Action | PC (Souris) | Mobile (Touch) |
| :--- | :--- | :--- |
| **Combat (Action)** | Clic Gauche sur la "Battle Zone" (Colonne Gauche) | Tapotement rapide sur la zone supérieure/centrale |
| **Navigation Menus** | Clic sur les onglets (Team, Pokédex, Stats) ou Scroll molette dans les listes | Tap sur les onglets (Bandeau inférieur), Swipe vertical pour les listes |
| **Achat (Shop)** | Clic sur les boutons d'achat (Colonne Droite) avec info-bulle au survol | Tap sur l'item pour détails, Tap "Acheter" pour confirmer |
| **Layout UI** | **3 Colonnes fixes :**<br>1. Battle Zone<br>2. Trainer Card/PC<br>3. Poké-Mart | **Navigation par Onglets + Persistent Header :**<br>La Battle Zone (Sprite + PV) reste toujours visible en haut (Header Persistant). Le joueur switch entre PC et Shop via une barre de navigation inférieure. |

### Input Feel

*   **PC:** Sensation de "Tableau de Bord" complet. Tout est visible d'un coup d'œil, donnant un sentiment de contrôle total.
*   **Mobile:** Sensation "Arcade" et rapide. Les boutons (notamment le Shop) sont adaptés en "Pleine Largeur" pour éviter les erreurs de frappe ("Fat Finger"), l'expérience restant fluide et accessible à une main.

---

{{GAME_TYPE_SPECIFIC_SECTIONS}}

---

## Progression and Balance

### Player Progression

La progression est multidimensionnelle, offrant toujours un objectif à court terme au joueur :

1.  **Collection (Pokédex):** L'indicateur visuel principal (Barre de % par région). Le moteur de la motivation de découverte.
2.  **Puissance Économique (RPS):** Voir les revenus passer de 100/sec à 1e12/sec.
3.  **Géographique:** Débloquer les routes successives (Route 201 -> 202 -> Ville...) en remplissant les critères de chaque zone.
4.  **Puissance de Combat (Active Team):** Monter le niveau de ses 6 Pokémon actifs pour réussir les "DPS Checks".

#### Progression Pacing

*   **Pacing Hybride:** 95% du temps est passé en mode "Capture/Idle" (Progression calme). Les 5% restants sont des "Boss Battles" (Fins de Route / Arènes / Ligue) qui sont des pics d'intensité nécessitant une préparation active.

### Difficulty Curve

#### Challenge Scaling

*   **Courbe Exponentielle:** Les PV des Pokémon sauvages et leurs récompenses augmentent exponentiellement.
*   **The "DPS Wall" (Boss):** À la fin de chaque Route et pour les Arènes/Ligue, le joueur affronte un Boss (Pokémon unique ou Dresseur).
    *   *Mécanique:* Le Boss a beaucoup de PV et une barre de temps (Timer). Le joueur doit le vaincre avant la fin du temps imparti.
    *   *Formule Dégâts (Boss):* `Dégâts Totaux = (DPS Passif Équipe / X) + Dégâts Clic`. L'équipe active contribue aux dégâts, rendant le leveling indispensable.
    *   *Échec:* Si le timer atteint 0 est renvoyé à la route précédente (pas de Game Over, juste un repli pour grinder).

### Economy and Resources

#### Resources

1.  **PokéDollars (₽):** Monnaie standard (Inflationniste) pour tout ce qui est upgrades de base.
2.  **Dungeon Tokens (DT) / Quest Points:** (Potentiel futur pour l'entrée des donjons).
3.  **Diamants (Premium):** Monnaie rare obtenue principalement via le Prestige (et potentiellement achievements rares).
    *   *Usage:* Achat d'améliorations permanentes ultra-puissantes (Multiplicateurs Globaux, Auto-Clickers ultimes) qui persistent après le Reset.

#### Economy Flow

*   **Earn:** Capture Passive + Clic Actif -> **Spend:** Balles/Infra -> **Optimisation:** Monter le niveau de l'équipe pour passer les Boss -> **Earn Plus Vite:** Nouvelle zone débloquée avec rendements supérieurs.

---

## Level Design Framework

### Structure Type

**World Map Progression (Semi-Linéaire):**
Le jeu suit la carte géographique de Sinnoh. Bien que la progression globale soit linéaire (Ville 1 -> Route 1 -> Ville 2), le joueur peut (et doit) naviguer librement entre toutes les zones déjà débloquées via une carte interactive pour optimiser sa chasse.

### Level Types

1.  **Routes (Zones de Farm):** Niveaux de base pour le grind.
    *   *Contenu:* Pokémon sauvages communs/rares.
    *   *Objectif:* Tuer 10 Pokémon pour débloquer la zone suivante (si pas bloqué par une ville).

2.  **Villes (Hubs & Blockers):** Zones de repos et de challenge majeur.
    *   *Hub:* Accès aux boutiques spéciales, PNJ. Possibilité de pêcher (activités annexes).
    *   *Arène (Blocker):* Chaque ville majeure possède une Arène. C'est un "Gated Check". Il est impossible d'accéder aux routes suivantes tant que le Champion d'Arène n'est pas vaincu.
    *   *Structure Arène:* Une série de combats de dresseurs (Sbires) culminant avec le Champion (Boss Timer).

3.  **Donjons / Grottes (High Risk Zones):** Ex: Mont Couronné, Mine Charbourg.
    *   *Structure:* Succession d'étages avec un Boss à chaque palier.
    *   *Mécanique d'Entrée (Betting System):* L'accès ne coûte pas d'argent, mais nécessite de **Miser un Pokémon**.
        *   Le joueur "envoie" un Pokémon de son équipe en éclaireur.
        *   Plus le Pokémon est rare et haut niveau, plus le **Multiplicateur de Butin** du donjon est élevé.
        *   *Risque:* Si le donjon est échoué, le Pokémon misé est "épuisé" (Cooldown long) ou nécessite un coût pour être récupéré. C'est un pari "High Risk / High Reward".

### Level Progression

#### Unlock System

*   **Progression Standard:** "Kill Count" (Tuer 10 ennemis) sur une Route débloque la route adjacente.
*   **Progression Majeure (Badges):** Vaincre un Champion d'Arène débloque l'accès à la section suivante de la carte (nouvelles villes/routes).

#### Replayability

Le Backtracking (retour en arrière) est encouragé par le design :
*   **Pokédex:** Chasser les Shinies manquants ou les rares (1% spawn).
*   **Quêtes Journalières:** Missions procédurales (ex: "Vaincre 50 Keunotor") donnant de l'XP ou des monnaies.
*   **Conditions d'Évolution:** Certains Pokémon nécessitent de grinder des zones spécifiques (ex: Zone Eau faible pour Magicarpe).

### Level Design Principles

*   **Loot Table Unique:** Chaque Route/Zone possède une liste d'apparition stricte. Si le joueur veut un Machoc, il *doit* se rendre à la Mine ou sur la route spécifique où il apparaît. L'optimisation passe par le choix de la bonne zone de chasse.

---

## Art and Audio Direction

### Art Style

**Authentic Gen 4 Pixel Art:**
Le jeu vise une reproduction fidèle de l'esthétique de *Pokémon Diamant/Perle* (Nintendo DS, 2006). L'objectif est de déclencher une nostalgie immédiate.
*   **Source des Assets:** Utilisation dynamique de **PokéAPI** et **PokeSprite** pour récupérer les données et les sprites officiels (Static 2D Gen 4 Sprites) afin de garantir la fidélité, minimiser la taille de l'app, et faciliter la maintenance.

#### Visual References

*   **Interface (UI):** Style "Pokétch" (Bleu/Gris métallique, écrans LCD, typographie pixelisée). Voir maquette de référence.
*   **Sprites:** Sprites 2D statiques (ou animation 2-frames simple) sur fonds de combat classiques (Herbes, Grottes, Eau).

#### Color Palette

Palette officielle de la Nintendo DS : Couleurs vives mais légèrement désaturées et pixelisées, avec des contours noirs ou foncés marqués pour les sprites.

### Audio and Music

#### Music Style

**Retro MIDI / 8-Bit Covers:**
Reprises fidèles des thèmes originaux de la région de Sinnoh (Route 201, Twinleaf Town, Battle Theme).
*   *Ambiance:* La musique change dynamiquement selon la Route/Zone active pour renforcer l'immersion géographique.

#### Sound Design

**Original SFX Recreation:**
Reconstitution des bruitages iconiques de la Gen 4 :
*   *Combats:* Sons "Crunchy" 8-bit pour les impacts.
*   *Menus:* Le fameux "Bip" de validation Nintendo et le son de "Curseur".
*   *Pokémon:* Cris (Cries) originaux digitaux (pas les voix de l'anime).

### Aesthetic Goals

L'esthétique doit servir le pilier "Nostalgie". Le joueur doit avoir l'impression de retrouver sa vieille console, mais avec la fluidité et le confort d'une application moderne (60fps, responsive).

---

## Target Platform(s)

### Primary Platform

**Dual-Platform:** Web Browser (PC) et Mobile (Android).
L'expérience utilisateur doit être "Seamless" (continue) entre les deux, avec une parité parfaite des fonctionnalités de jeu.

### Platform Considerations

**Cross-Platform Cloud Save:** Utilisation de Supabase pour synchroniser l'état du jeu en temps réel. Le joueur doit pouvoir fermer son navigateur et ouvrir l'application Android immédiatement avec la même progression.

**PC (Web - PHP Backoffice):**
- Interface de jeu principale sur navigateur.
- **Admin Panel exclusif:** Un backoffice complet pour les administrateurs permettant de gérer les joueurs, éditer les données (invenaires, progression) et modérer le jeu.

**Mobile (Android - Flutter):**
- Application native (APK) pour le développement (pas de sortie store immédiate).
- Optimisation pour les contrôles tactiles (le "clic" frénétique).
- Gestion de l'état en arrière-plan (mode veille/idle).

### Control Scheme

- **PC:** Souris (Clic gauche pour l'action principale, navigation UI standard).
- **Mobile:** Tactile (Tap pour l'action, Swipe/Scroll pour la navigation).
L'interface doit être "Responsive" ou adaptative pour conserver l'esthétique Pixel Art DS sur les deux ratios d'écran.

---

## Target Audience

### Demographics

**Âge:** 25-35 ans (Génération ayant grandi avec Pokémon Diamant/Perle sur DS).
**Profil:** Fans de Pokémon nostalgiques et amateurs de jeux incrémentaux.

### Gaming Experience

**Casual:** Le jeu vise l'accessibilité avant tout.
Bien que les mécaniques "Idle" puissent devenir complexes (mathématiquement), l'approche doit rester simple et guidée par la collection. Les joueurs ne sont pas nécessairement des experts en optimisation "min-max" (hardcore), mais plutôt des collectionneurs qui apprécient voir leur empire grandir.

### Genre Familiarity

Modérée. Ils connaissent les bases de Pokémon (types, capture, évolution) et comprennent le concept de "cliquer pour gagner", mais ne cherchent pas une complexité de gestion excessive dès le début.

### Session Length

**Hybride:**
- **Mobile:** Sessions très courtes (2-5 minutes) dans les transports ou en pause.
- **PC:** Sessions potentiellement plus longues en "Second Screen" (jeu qui tourne sur un deuxième écran pendant le travail), avec des interactions ponctuelles.

### Player Motivations

1.  **Nostalgie:** Retrouver l'ambiance visuelle et sonore de la Gen 4.
2.  **Collection:** Compléter le Pokédex (le moteur principal de motivation).
3.  **Progression:** Satisfaction de voir les chiffres augmenter (Cash, Dégâts, Production).
4.  **Flexibilité:** Pouvoir jouer n'importe où sans friction.

---

## Development Epics

### Epic Overview

| # | Epic Name | Scope | Dependencies | Est. Stories |
|---|---|---|---|---|
| 1 | **The Core Loop (MVP)** | Base mechanics (Click, Earn, Upgrade) | None | 5 |
| 2 | **Data & Assets (Pokédex)** | PokéAPI integration & Data integrity | Epic 1 | 4 |
| 3 | **World & Progression (Map)** | Navigation, Route Logic, Unlock System | Epic 1, 2 | 6 |
| 4 | **Combat Systems (Battle)** | Team DPS, Boss Timers, Capture Rate | Epic 2, 3 | 7 |
| 5 | **Economy & Meta (Shop)** | Shops, Save Cloud, Prestige | Epic 1, 4 | 5 |
| 6 | **Polish & UI (Juice)** | Final Art, Sound, Responsive, Mobile UX | Epic 1-5 | 8 |

### Recommended Sequence

**Séquence Linéaire Standard :**
1.  **MVP (Core Loop):** Valider le fun du clic immédiat.
2.  **Data (PokéAPI):** Remplacer les carrés gris par des vrais Pokémon (motivation visuelle).
3.  **Progression (Map):** Donner un but à la collection.
4.  **Profondeur (Combat):** Rendre le jeu stratégique (Team building).
5.  **Rétention (Economy):** Sauvegarde et Prestige pour le long terme.
6.  **Polish:** Rendre le tout vendable/agréable.

### Vertical Slice

**The First Playable Milestone (Fin Epic 3):**
À la fin de l'Epic 3, le jeu tech-demo est jouable : On peut cliquer sur un vrai Tortipouss (Data), gagner de l'argent, et débloquer la route suivante (Progression). C'est le moment "Preuve de Concept" où l'on valide que le jeu est amusant avant d'ajouter la complexité des combats de Boss et de l'économie avancée.

---

## Technical Specifications

### Performance Requirements

**Target:** 60 FPS Constant & Instant Load.
*   **Frame Rate:** 60 FPS impératif sur toutes les plateformes. La fluidité du feedback visuel lors du clic est la priorité #1.
*   **Load Times:** < 2 secondes pour le "Cold Start" sur mobile. Le joueur doit pouvoir lancer l'app et capturer un Pokémon en moins de 5 secondes.

### Platform-Specific Details

#### PC (Web) Requirements
*   **Responsive:** L'interface doit s'adapter dynamiquement au redimensionnement de la fenêtre (ratio flexible).
*   **Input:** Support complet Clavier (Raccourcis pour les menus, Espace pour valider) + Souris.

#### Mobile (Android) Requirements
*   **Orientation:** **PORTRAIT Only**.
    *   *Justification:* Optimisé pour le jeu à une main (One-Thumb Play) dans les transports.
    *   *Conséquence UI:* L'interface 3 colonnes du PC sera "stackée" ou transformée en onglets, avec le système de "Persistent Battle Header" validé en Step 6.

### Asset Requirements

#### Data Architecture
*   **PokéAPI Strategy:** Utilisation hybride.
    *   *On-Demand:* Les sprites sont téléchargés à la volée depuis PokéAPI et mis en cache localement sur l'appareil pour réduire la taille initiale de l'APK.
    *   *Fallback:* Les assets critiques (UI, Starters, Route 1) sont embarqués nativement.

#### Networking
*   **Online-First:** Le jeu nécessite une connexion Internet au lancement pour s'authentifier via Supabase et récupérer la dernière sauvegarde cloud.
    *   *Synchro:* Sauvegarde automatique fréquente (Cloud Save) pour permettre le switch appareil sans perte de progression.

### Technical Constraints
*   **Supabase Dependency:** La disponibilité du jeu dépend de la santé du service Supabase (Auth + DB).
*   **Flutter:** Le moteur doit gérer efficacement le cache d'images (milliers de sprites) sans provoquer de fuites de mémoire (Memory Leaks).

---

## Success Metrics

### Technical Metrics

*   **Frame Stability:** 60 FPS constant sur 95% des sessions.
*   **Startup Efficiency:** Cold Start < 2 secondes.
*   **Stability:** Crash-free sessions > 99%.

#### Key Technical KPIs

| Metric | Target | Measurement Method |
| ------ | ------ | ------------------ |
| **FPS** | 60 | Flutter DevTools Performance Overlay / Firebase Performance |
| **Cold Start** | < 2s | Firebase Performance Monitoring |
| **Crash Rate** | < 1% | Firebase Crashlytics |

### Gameplay Metrics

*   **Retention D1:** > 40% (Indique que le Core Loop est fun).
*   **Retention D7:** > 15% (Indique que la progression long terme fonctionne).
*   **Funnel:** 50% des joueurs atteignent et battent le premier Champion (Roark).

#### Key Gameplay KPIs

| Metric | Target | Measurement Method |
| ------ | ------ | ------------------ |
| **Retention D1** | 40% | Supabase Analytics / Custom Events |
| **First Badge Rate** | 50% | Achievement Unlock Event Log |

### Qualitative Success Criteria

1.  **Portfolio Value:** Le code source doit être exemplaire (Clean Architecture, Tests, CI/CD) pour servir de preuve de compétence technique.
2.  **Nostalgie:** Les retours utilisateurs mentionnent explicitement le feeling "Authentique Gen 4".
3.  **Community:** Les joueurs partagent spontanément leurs captures de Shiny.

### Metric Review Cadence

*   **Weekly:** Revue des stats techniques (Crashlytics) et ajustement des performances.
*   **Milestone:** Revue des métriques de gameplay à la fin de chaque Épic majeur.

---

## Out of Scope

{{out_of_scope}}

---

## Assumptions and Dependencies

{{assumptions_and_dependencies}}
