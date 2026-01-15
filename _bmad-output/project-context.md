---
project_name: 'PokeClickerLive'
user_name: 'Denis'
date: '2026-01-12'
sections_completed:
  ['technology_stack', 'engine_rules', 'performance_rules', 'organization_rules', 'testing_rules', 'critical_rules']
status: 'complete'
rule_count: 22
optimized_for_llm: true
---

# Project Context for AI Agents

_This file contains critical rules and patterns that AI agents must follow when implementing game code in this project. Focus on unobvious details that agents might otherwise miss._

---

## Technology Stack & Versions

- **Engine:** Flutter v4.0.0 (Stable) containing Impeller (Rendering).
- **Language:** Dart 3.6+
- **Key Packages:**
    - `flutter_riverpod: ^3.0.0` (State Management & DI)
    - `freezed_annotation: ^3.0.0` (Immutable Data Classes)
    - `hive: ^4.0.0` (NoSQL Persistence)
    - `cached_network_image: ^3.3.0` (Image Caching)
    - `fpdart: ^1.1.0` (Functional Error Handling)

### Backend Architecture (Legacy PHP/Supabase)
The project includes a legacy PHP backend acting as a wrapper around Supabase and PokeAPI.
*   **Path:** `backend-php/`
*   **Framework:** Native PHP with REST structure.
*   **Database:** Supabase (Postgres) managed via `Supabase.php` wrapper.
*   **Authentication:** JWT-based, handled by `AuthController.php`.
*   **Key Models:** `User`, `UserPokemon`, `Pokemon` (Cached).
*   **Contracts:** See `_bmad-output/api-contracts.md`.

## Critical Implementation Rules

### Engine-Specific Rules (Flutter)

- **Widget Lifecycle:** Never perform business logic (calc, API calls) inside `build()`.
- **State Management:** Use `NotifierProvider` for all state logic.
    - ❌ NO `StatefulWidget` for complex business logic.
    - ✅ UI just calls `ref.read(provider.notifier).method()`.
- **Immutability:** All state classes MUST be `@freezed`.
- **Build Runner:** Run `dart run build_runner build` after modifying any `@freezed` or `@HiveType` class.
- **Assets:** Use `Assets.gen.dart` (if using flutter_gen) or strict const strings in `AppAssets`.

### Performance Rules

- **Frame Budget:** 16ms strict.
    - ❌ Avoid `Opacity`, `ClipRRect` inside lists. Use `AnimatedOpacity` or pre-clipped images if possible.
- **Image Caching:** ALWAYS use `CachedNetworkImage` for external URLs (PokéAPI).
    - Configure `memCacheHeight` to reduce RAM usage (don't decode full 4K images on a phone).
- **Idle Loop:** The `TickEngine` runs a `Timer.periodic`.
    - ❌ Do NOT update UI on every 1ms tick. Update state, let Riverpod handle refesh rate throttling if needed.
- **Const Widgets:** Use `const` everywhere possible to avoid rebuilds.

### Code Organization Rules

**Feature-First Structure (Strict):**
- Place code in `lib/src/features/<feature_name>/`
- **Layers:**
    - `domain/`: Pure Dart entities (No Flutter dependencies if possible).
    - `data/`: Repositories + DTOs + Hive Adapters.
    - `application/`: Notifier/Controllers (Logic).
    - `presentation/`: Widgets (Views).

**Naming:**
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Providers: `camelCaseProvider`
- Repos: `camelCaseRepository`

### Testing Rules

- **Unit Tests:** `test/src/features/<feature>/application/`
    - Check Logic using `stateNotifierTest` equivalents.
    - Mock Repositories using `mocktail`.
- **Widget Tests:** `test/src/features/<feature>/presentation/`
    - Test UI rendering states (Loading, Error, Data).
    - PumpWidget using a `ProviderScope` override.

### Critical Don't-Miss Rules

- **Error Handling:** NEVER throw exceptions in Domain/Data layers.
    - ✅ Return `Future<Either<Failure, T>>`.
- **Hive:** Always register Adapters in `app_bootstrap.dart` before opening boxes.
- **Context:** Avoid passing `BuildContext` to Controllers. Use Riverpod `Ref` instead.
- **Magic Numbers:** Extract ALL gameplay constants (Damage, Prices) to `AppConstants` or a Config Provider.

---

## Usage Guidelines

**For AI Agents:**
- Read this file before implementing any game code.
- Follow ALL rules exactly as documented.
- When in doubt, prefer the more restrictive option (e.g., `const` over non-const).
- Update this file if new patterns emerge during development.

**For Humans:**
- Keep this file lean and focused on agent needs.
- Update when technology stack changes (e.g., Hive v4 -> v5).
- Review periodically for outdated rules.

Last Updated: 2026-01-15
