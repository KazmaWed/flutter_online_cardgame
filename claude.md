# Development Guidelines

This file contains important guidelines and context for working on this Flutter online card game project.

## Project Overview

This is a Flutter-based online card game that uses Firebase for backend services including:
- Firebase Authentication (anonymous users)
- Firebase Cloud Functions (game logic APIs)
- Firebase Realtime Database (game state synchronization)

## Documentation

### realtime_database_scheme.yaml
- Defines the Firebase Realtime Database structure
- Shows the schema for games, players, and game states
- **Do not edit unless absolutely necessary** - changes require backend updates

### api_reference.md
- Documents all Cloud Functions APIs
- Includes request/response formats, error codes, and usage examples
- **Do not edit unless absolutely necessary** - reflects actual backend implementation

## Code Style Guidelines

### Import Order
```dart
// 1. External/public packages (alphabetical)
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 2. Internal project files (alphabetical)
import 'package:flutter_online_cardgame/components/base_scaffold.dart';
import 'package:flutter_online_cardgame/model/game_info.dart';
```

### Error Handling
- Use the `GameScreenMixin.handleApiError()` for consistent error handling
- Always include try-catch blocks for async operations
- Log errors with descriptive context

### State Management
- Use StatefulWidget with proper lifecycle management
- Dispose controllers and focus nodes in dispose() method
- Use the `GameScreenMixin` for common game screen functionality

## Architecture

### Current Structure
- **Screens**: UI components organized by feature (matching, playing, etc.)
- **Components**: Reusable UI widgets
- **Model**: Data classes with JSON serialization
- **Repository**: API calls and data access layer
- **Util**: Helper functions and extensions

### Best Practices
- Follow Clean Architecture principles
- Separate UI, business logic, and data layers
- Use mixins for shared functionality (e.g., `GameScreenMixin`)
- Keep widgets focused and composable

## Common Patterns

### Game Screen Implementation
```dart
class _MyScreenState extends State<MyScreen> with GameScreenMixin {
  @override
  GameInfo get gameInfo => widget.gameInfo;
  
  @override
  GameState get gameState => widget.gameState;
  
  @override
  GameConfig? get gameConfig => _gameConfig;
  
  // Use mixin properties: uid, activePlayers, myInfo, gameMaster, isMaster
  // Use mixin methods: handleApiError(), exitGame()
}
```

### API Error Handling
```dart
try {
  await FirebaseRepository.someMethod(gameId: gameInfo.gameId);
} catch (e) {
  handleApiError('operation name', e);
}
```

## Refactoring Opportunities

Feel free to suggest improvements for:
- Code duplication reduction
- Better separation of concerns
- Performance optimizations
- UI/UX enhancements
- Architecture improvements

## Critical Development Rules

### Screen Navigation and Data Flow
- **NEVER** automatically execute navigation methods (like `_onPressed`, `Navigator.push`, etc.) without explicit user action
- **NEVER** add automatic form submission or data processing logic
- User interactions (button clicks, form submissions, screen transitions) must be **explicitly initiated by the user**
- Auto-execution is only acceptable for:
  - UI updates (setState calls for visual changes)
  - Input validation and formatting
  - Focus management
  - Non-destructive operations

### Examples of FORBIDDEN automatic behavior:
```dart
// ❌ NEVER DO THIS - automatic navigation/submission
if (isValidPin) {
  _onPressed(); // Auto-executes form submission
}

if (inputComplete) {
  Navigator.push(...); // Auto-navigates to next screen
}

// ✅ ACCEPTABLE - UI updates only
if (isValidPin) {
  setState(() => _buttonEnabled = true); // Visual feedback only
}
```

### Why This Rule Exists≒
- Avoids accidental API calls or data submissions
- Prevents navigation bugs and state management issues

**ALWAYS ask for explicit confirmation before implementing any automatic navigation or data processing logic.**

## Git Operations Rules

### CRITICAL: No Unauthorized Git Operations
- **NEVER** execute `git add`, `git commit`, or `git push` without explicit user instruction
- **ONLY** perform git operations when user explicitly says "commit", "push", or gives clear git instructions
- File creation and editing are allowed, but NO automatic git operations
- When work is complete, ASK "Would you like me to commit these changes?" - DO NOT commit automatically

### Examples:
```bash
# ❌ FORBIDDEN - automatic git operations after file changes
git add .
git commit -m "..."
git push origin main

# ✅ ALLOWED - only when explicitly instructed
User: "Commit these changes"
Assistant: git add . && git commit -m "..."
```

### Why This Rule Exists:
- Users must have full control over git history
- Prevents unwanted commits and pushes
- Allows users to review changes before committing

**ALWAYS wait for explicit git instructions. NEVER assume user wants automatic commits.**