# Story 1.2: Currency Balance UI

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a Player,
I want to see my current currency balance update in real-time with smooth animations and better formatting,
so that I have clear and satisfying feedback of my earnings and progress.

## Acceptance Criteria

1. [AC-1] **Currency Formatting**: Currency is displayed with the `₽` symbol and thousands separators (e.g., `₽ 1,250`).
2. [AC-2] **Smooth Animations**: Balance updates use a "roll" or "count up" animation to transition between values.
3. [AC-3] **Visual Juice**: The currency display performs a subtle scale/bounce animation when a significant amount is earned.
4. [AC-4] **Floating Feedback**: Small floating text (e.g., `+1`) appears near the click location and drifts upwards before fading.
5. [AC-5] **Reusability**: The currency display is encapsulated in a dedicated widget for use across different screens (Shop, Battle, etc.).

## Tasks / Subtasks

- [x] **Infrastructure & Formatting** (AC: 1, 5)
  - [x] Add `intl` package to `pubspec.yaml` for number formatting.
  - [x] Create `PokéCurrency` widget in `lib/src/features/clicker/presentation/widgets/`.
  - [x] Implement `NumberFormat.decimalPattern()` or similar for the `₽` display.
- [x] **Animated Counter** (AC: 2, 3)
  - [x] Implement an implicitly animated counter (e.g., using `TweenAnimationBuilder` or `animated_flip_counter`).
  - [x] Add a scale transition trigger when the currency value increases.
- [x] **Floating Click Text** (AC: 4)
  - [x] Implement a `FloatingText` system in `ClickerScreen`.
  - [x] Create a list of active floating animations and clean them up after completion.
  - [x] Trigger floating text on every successful click.
- [x] **Integration & Cleanup** (AC: 5)
  - [x] Replace the hardcoded Text in `ClickerScreen.appBar` with the new `PokéCurrency` widget.
  - [x] Ensure the UI remains responsive and maintains 60 FPS during animations.
  
### Review Follow-ups (AI)
- [x] [AI-Review][High] Fix resource leak in `ClickerScreen` (controller dispose) [clicker_screen.dart:23]
- [x] [AI-Review][Medium] Fix AC mismatch in number formatting (use comma separator) [poke_currency.dart:50]

## Dev Notes

- **State Management**: Continue using `ref.watch(clickerControllerProvider)` to get the currency value.
- **Architecture**: Move new widgets to `lib/src/features/clicker/presentation/widgets/`.
- **Performance**: Limit the number of concurrent floating texts to avoid over-taxing the widget tree.
- **Packages**: Consider `animated_flip_counter` or `flutter_animate` if manual animation becomes too verbose.
- **Reference**: `lib/src/features/clicker/presentation/clicker_screen.dart` lines 27-33 (current implementation).

### Project Structure Notes

- Alignment with `Feature-First` structure.
- New widgets folder: `lib/src/features/clicker/presentation/widgets/`.

### References

- [Source: _bmad-output/game-architecture.md#Architectural Decisions]
- [Source: _bmad-output/project-context.md#Performance Rules]

## Dev Agent Record

### Agent Model Used

Antigravity (GPT-4o equivalent)

### Debug Log References

- [Review] Identified resource leak in `ClickerScreen` (controller not disposed on list limit). FIXED.
- [Review] Identified AC mismatch in number formatting (fr vs en_US). FIXED.

### Completion Notes List

- Implemented `PokéCurrency` widget with `intl` formatting and proper implicit animation using `TweenAnimationBuilder`.
- Added scale transition effect on currency updates for visual feedback.
- Implemented `FloatingText` system in `ClickerScreen` using a `Stack` and `AnimationController`.
- Converted `ClickerScreen` to `ConsumerStatefulWidget` to handle animation state.
- Added comprehensive widget tests for `PokéCurrency`.
- Verified all Acceptance Criteria.

### File List

- Flutter/pubspec.yaml
- Flutter/lib/src/features/clicker/presentation/widgets/poke_currency.dart
- Flutter/lib/src/features/clicker/presentation/clicker_screen.dart
- Flutter/test/src/features/clicker/presentation/widgets/poke_currency_test.dart
