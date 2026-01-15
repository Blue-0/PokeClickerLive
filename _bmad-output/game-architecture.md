---
title: 'Game Architecture'
project: 'PokeClickerLive'
date: '2026-01-12'
author: 'Denis'
version: '1.0'
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8, 9]
status: 'complete'
engine: 'Flutter'
platform: 'Mobile/Web'

# Source Documents
gdd: '/Users/denis/repo/PokeClickerLive/_bmad-output/gdd.md'
epics: '/Users/denis/repo/PokeClickerLive/_bmad-output/epics.md'
brief: ''
---

# Game Architecture

## Executive Summary

**PokeClickerLive** architecture is designed for **Flutter** targeting **Mobile (Android) & Web**.

**Key Architectural Decisions:**
*   **State Management:** Riverpod 3.0 (Notifier Providers) for `BuildContext`-free logic.
*   **Persistence:** Hive v4 for high-performance offline storage/auto-save.
*   **Asset Management:** Custom Cache with Lazy Loading for PokéAPI sprites.

**Project Structure:** Feature-First organization with 5 core systems (Combat, World, Collection, Shop, Settings).

**Implementation Patterns:** 6 patterns defined ensuring AI agent consistency, including a novel `TickEngine` for Idle RPG mechanics.

**Ready for:** Epic implementation phase

## Development Environment

### Prerequisites
*   Flutter SDK v4.0+ (Stable Channel)
*   Dart 3.6+
*   Melos (Optional, for monorepo management if scaling)
*   Build Runner (`dart run build_runner watch`)

### Setup Commands
```bash
# 1. Clone & Dependencies
git clone https://github.com/denis/PokeClickerLive.git
cd PokeClickerLive
flutter pub get

# 2. Code Generation (Freezed/Hive)
dart run build_runner build --delete-conflicting-outputs

# 3. Run Dev
flutter run -d chrome --web-renderer canvaskit
```

### First Steps
1.  Run `flutter create` command specified in Engine section.
2.  Set up the `app_bootstrap.dart` to init Hive and Audio.
3.  Create the first Feature Slice: `features/combat`.

## Document Status

This architecture document is being created through the BMGD Architecture Workflow.

**Steps Completed:** 1 of 9 (Initialize)

---

## Project Context

### Game Overview

**PokeClickerLive** - Un Idle/Incremental Game combinant la collection addictive de Pokémon (Gen 4) avec des mécaniques de progression RPG (Routes, Boss, Donjons).

### Technical Scope

**Platform:** Mobile (Android Portrait) & Web (Responsive).
**Genre:** Idle/Incremental RPG.
**Project Level:** Intermediate/Advanced (Gestion active + passive).

### Core Systems

| System | Complexity | GDD Reference |
| --- | --- | --- |
| **State Management** | High | Gère la progression offline, le calcul DPS temps réel, et l'inventaire. |
| **Asset Management** | Medium | Cache et affichage de 1000+ sprites Pokémon. |
| **Game Logic** | Medium | Logique de combat, capture, et déblocage de routes. |
| **Persistence** | Medium | Synchro Cloud (Supabase) + Local Storage. |

### Technical Requirements

*   **FPS:** 60 FPS Constants.
*   **Startup:** < 2 secondes (Cold Start).
*   **Offline:** Offline-first avec authentification online au démarrage.
*   **Memory:** Gestion stricte pour supporter les nombreux assets graphiques.

### Complexity Drivers

*   **Logic Isolation:** La boucle de jeu doit tourner indépendamment de l'UI (pour le mode Idle/Background).
*   **Data Integrity:** Prévention de la triche (Validation serveur possible) et cohérence des sauvegardes.

### Technical Risks

*   **Couplage API:** Dépendance forte à PokéAPI. Nécessite une abstraction.
*   **Memory Leaks:** Risque élevé avec la quantité de Sprites.
*   **Performance:** Rendu de nombreux éléments (particules, sprites) sans moteur de jeu dédié.

---

## Engine & Framework

### Selected Engine

**Flutter** v4.0 (Stable)

**Rationale:** Flutter offre une performance unique (via Impeller), un workflow de développement rapide pour l'UI complexe (Arbres de Widgets), et une portabilité native Web/Mobile. L'approche "Tout est Widget" convient parfaitement à un jeu d'interface comme un Clicker.

### Architecture Stack Selected

| Component | Solution | Notes |
| --- | --- | --- |
| **Rendering** | Native Widgets (`Stack`, `Positioned`) | Suffisant pour 90% du jeu. |
| **High-Perf Rendering** | `CustomPainter` | Pour les zones critiques (Combat, Particules) si nécessaire. |
| **State Management** | **Riverpod 3.0** | Choisi pour son indépendance du `BuildContext`, sa testabilité et sa sûreté au typage. |
| **Assets** | `cached_network_image` + Custom Cache | Gestionnaire dédié pour les sprites PokéAPI. |
| **Backend** | Supabase (Self-hosted) | Auth, DB, et Realtime. |

### Project Initialization

Le projet sera initialisé comme une application Flutter standard, structurée par Features (Clean Architecture).

```bash
flutter create poke_clicker_live --org com.denis --platforms android,web
```

## Architectural Decisions

### Decision Summary

| Category | Decision | Rationale |
| --- | --- | --- |
| **Structure** | **Feature-First** | Regroupe le code par fonctionnalité (Epic) pour faciliter la navigation et la modularité. |
| **Persistence** | **Hive** | NoSQL binaire ultra-rapide, idéal pour les écritures fréquentes d'un Idle Game. |
| **DI** | **Riverpod** | Unifie la gestion d'état et l'injection de dépendance. Évite la duplication avec GetIt. |

### Project Structure (Feature-First)

**Approche:** Les dossiers sont organisés par domaine métier ("Features") plutôt que par couche technique.
*   `lib/src/features/combat/`
    *   `domain/` (Models, Logic pure)
    *   `data/` (Repositories, DTOs)
    *   `presentation/` (Widgets, Controllers)

**Justification:** Cette structure permet de travailler sur une fonctionnalité (ex: Combat) sans sauter entre 3 dossiers racines différents. Elle isole aussi bien le code pour les tests.

### Data Persistence (Hive)

**Solution:** Hive (v4)
**Usage:**
*   Stockage du `SaveFile` (JSON géant de l'état du joueur).
*   Stockage du `Settings` (Volume, Langue).
*   Cache des données statiques (Pokédex info).

**Justification:** Hive est extrêmement performant (écriture binaire directe) et ne bloque pas le thread UI, ce qui est critique pour l'auto-save fréquent (toutes les 30s).

### Dependency Injection (Riverpod)

**Solution:** Riverpod `Provider` & `NotifierProvider`.
**Pattern:**
*   Les Services (API, Audio) sont exposés via des `Provider` simples (Singletons read-only).
*   Les Repositories sont exposés via `Provider`.
*   L'UI lit ces Providers via `ref.watch` ou `ref.read`.

**Justification:** Riverpod gère nativement le cycle de vie (auto-dispose si besoin) et le remplacement par des Mocks pour les tests, rendant `GetIt` redondant.

### Asset Management

**Loading Strategy:** Lazy Loading avec Cache.
*   Les images sont chargées à la demande via `cached_network_image`.
*   Un `PreloaderWidget` au lancement du jeu chargera les assets critiques (UI, Starters).

### Audio Architecture

**Solution:** Package `audioplayers` ou `flame_audio` (si besoin de pool).
*   **Music:** 1 Channel (Looping).
*   **SFX:** Multi-channel (Fire & Forget).
*   **Manager:** Un `AudioController` (Riverpod Provider) gère le volume et le mute global.
