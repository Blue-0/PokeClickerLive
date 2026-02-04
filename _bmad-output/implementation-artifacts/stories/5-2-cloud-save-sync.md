# Story 5.2: Cloud Save Sync

Status: review

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a player,
I want my progress to be automatically saved to the cloud,
so that I can continue my game on another device without losing my progress.

## Acceptance Criteria

1. **[AC-1] Periodic Auto-Sync**: The system must automatically trigger a cloud sync every 60 seconds of active gameplay or on significant events (e.g., catching a new Pokémon).
2. **[AC-2] Background Execution**: Cloud saving must happen asynchronously without blocking the UI or the main game loop.
3. **[AC-3] API Contract Compliance**: Implementation of a `POST` request to `/api/user/sync` with:
    - `last_sync`: Local timestamp of the last successful sync.
    - `local_data`: A JSON object merging all relevant game state (Currency, Team, Inventory, Upgrades, Map Progress).
4. **[AC-4] Authentication Guard**: Cloud sync must only run if a valid JWT token is stored. If no user is logged in, the game must continue to use local Hive storage only.
5. **[AC-5] Conflict Acknowledgment (Simple)**: The app must handle the server response. If the server returns `cloud_data`, the app should be ready to prioritize it (logic for "Load from Cloud" prompt).
6. **[AC-6] Error Handling**: Network failures must be handled gracefully using `Either<Failure, T>`, showing a subtle error indicator if sync fails repeatedly.

## Tasks / Subtasks

- [x] **Infrastructure: Networking & Auth (AC: 3, 4)**
    - [x] Create `AuthRepository` to handle login/register and JWT storage (Hive).
    - [x] Create `CloudSaveRepository` to implement the `/api/user/sync` call.
    - [x] Set up a base `Dio` or `Http` client with Interceptors for the JWT header.
- [x] **Application Logic: Sync Management (AC: 1, 2, 6)**
    - [x] Create `SyncController` (Riverpod Notifier) to coordinate the sync loop.
    - [x] Implement a "State Aggregator" that collects data from `ClickerController`, `InventoryController`, `WorldController`, etc.
    - [x] Implement the periodic trigger using a `Timer` or by listening to state changes.
- [x] **Data Persistence (AC: 5)**
    - [x] Update `app_bootstrap.dart` to initialize the sync loop if a user is logged in.
    - [x] Implement a basic conflict detection (Compare local vs server timestamps).
- [x] **UI Integration (AC: 6)**
    - [x] Add a simple "Cloud Sync" status icon in the settings or top bar.
    - [x] Add a basic Login/Register modal if no account is linked.

## Dev Notes

- **Architecture**: Create `lib/src/features/auth/` for account management and `lib/src/features/sync/` for the logic.
- **Data Models**: The `local_data` JSON should follow the structure expected by the PHP backend defined in `backend-php/src/Controllers/Api/SyncController.php`.
- **Patterns**: Use `fpdart` for error handling. Use `ref.listen` in the `SyncController` to trigger saves on specific state changes if preferred over a simple timer.
- **Hive**: Ensure the `auth` box is opened during bootstrap.

### Project Structure Notes

- New features: `auth`, `sync`.
- Integration points: All existing controllers that hold persistent state.

### References

- [Source: _bmad-output/api-contracts.md#POST /api/user/sync]
- [Source: _bmad-output/project-context.md#Backend Architecture]
- [Source: backend-php/src/Controllers/Api/SyncController.php]

## Dev Agent Record

### Agent Model Used

Antigravity (Gemini 2.0 Flash)

### Completion Notes List

- Implemented `AuthRepository` and `AuthController` for user authentication.
- Implemented `CloudSaveRepository` for communicating with the backend `/api/user/sync` endpoint.
- Setup `Dio` with interceptors for automatic JWT attachment.
- Implemented `SyncController` which aggregates state from multiple features and performs periodic sync (60s).
- Added `LoginDialog` and integrated cloud sync status/auth button into `ClickerScreen`.
- Verified build and code generation.

### File List

- `lib/src/features/auth/domain/user.dart`
- `lib/src/features/auth/domain/auth_state.dart`
- `lib/src/features/auth/data/auth_repository.dart`
- `lib/src/features/auth/application/auth_controller.dart`
- `lib/src/features/auth/presentation/login_dialog.dart`
- `lib/src/features/core/data/dio_provider.dart`
- `lib/src/features/sync/domain/sync_state.dart`
- `lib/src/features/sync/data/cloud_save_repository.dart`
- `lib/src/features/sync/application/sync_controller.dart`
- `lib/src/features/clicker/presentation/clicker_screen.dart` (modified)
- `lib/app_bootstrap.dart` (modified)
