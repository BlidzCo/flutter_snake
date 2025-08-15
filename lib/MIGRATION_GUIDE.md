# Migration Guide: From Fixed Rewards to Flexible Reward System

This guide explains how to migrate from the old fixed reward system to the new flexible reward configuration system.

## What Changed

### Before (Old System)
- Individual parameters for each reward type: `snakeCashImgPath`, `snakeCoinImgPath`, `snakeSpinImgPath`
- Fixed `List<CASE_TYPE>` for food types
- Hardcoded reward types in the package

### After (New System)
- Single `Map<String, RewardConfig>` parameter for all custom rewards
- Flexible `List<String>` for food types
- Custom reward types defined in your main app

## Migration Steps

### 1. Update your imports
```dart
// Add this import
import 'package:flutter_snake/flutter_snake.dart'; // RewardConfig is now exported
```

### 2. Replace individual reward parameters with rewardConfigs map

**Before:**
```dart
SnakeGame(
  // ... other parameters
  foodList: [CASE_TYPE.cash, CASE_TYPE.coin, CASE_TYPE.spin],
  snakeCashImgPath: 'assets/my_cash.png',
  snakeCoinImgPath: 'assets/my_coin.png', 
  snakeSpinImgPath: 'assets/my_spin.png',
)
```

**After:**
```dart
SnakeGame(
  // ... other parameters
  foodList: ['cash', 'coin', 'spin'], // Now uses String identifiers
  rewardConfigs: {
    'cash': RewardConfig(
      id: 'cash',
      imagePath: 'assets/my_cash.png',
      increasesSpeed: true, // Optional: whether this reward increases snake speed
    ),
    'coin': RewardConfig(
      id: 'coin', 
      imagePath: 'assets/my_coin.png',
      increasesSpeed: true,
    ),
    'spin': RewardConfig(
      id: 'spin',
      imagePath: 'assets/my_spin.png',
      increasesSpeed: false,
    ),
  },
)
```

### 3. Adding New Custom Rewards

You can now easily add new reward types without modifying the package:

```dart
SnakeGame(
  // ... other parameters
  foodList: ['cash', 'coin', 'diamond', 'powerup', 'bonus'],
  rewardConfigs: {
    'cash': RewardConfig(id: 'cash', imagePath: 'assets/cash.png'),
    'coin': RewardConfig(id: 'coin', imagePath: 'assets/coin.png'), 
    'diamond': RewardConfig(id: 'diamond', imagePath: 'assets/diamond.png'),
    'powerup': RewardConfig(id: 'powerup', imagePath: 'assets/powerup.png'),
    'bonus': RewardConfig(id: 'bonus', imagePath: 'assets/bonus.png'),
    // Add as many as you want!
  },
)
```

## What Stays the Same

- `snakeFruitImgPath` (default reward image) - unchanged
- `snakeLavaImgPath` (lava hazard) - unchanged  
- All snake body parts and movement - unchanged
- Game events and core functionality - unchanged

## New: Multiple Default Rewards

You can now mark any number of rewards as "default" rewards using `RewardConfig.isDefaultReward`:

```dart
SnakeGame(
  // ... other parameters
  foodList: ['apple', 'banana', 'cash', 'coin'],
  rewardConfigs: {
    'apple': RewardConfig(
      id: 'apple', 
      imagePath: 'assets/apple.png',
      isDefaultReward: true,  // This will behave like default fruit
    ),
    'banana': RewardConfig(
      id: 'banana', 
      imagePath: 'assets/banana.png',
      isDefaultReward: true,  // This will also behave like default fruit
    ),
    'cash': RewardConfig(
      id: 'cash', 
      imagePath: 'assets/cash.png',
      // isDefaultReward: false (default) - behaves as custom reward
    ),
    'coin': RewardConfig(
      id: 'coin', 
      imagePath: 'assets/coin.png',
      // isDefaultReward: false (default) - behaves as custom reward
    ),
  },
)
```

**Default Reward Behavior (`isDefaultReward: true`):**
- ✅ Use `snakeFruitImgPath` for rendering (overrides `imagePath`)
- ✅ Emit `GAME_EVENT.fruit_eaten` when eaten
- ✅ Don't trigger `onCustomRewardEaten` callback
- ✅ Can have unlimited number of default rewards

**Custom Reward Behavior (`isDefaultReward: false` or not specified):**
- ✅ Use their own `imagePath` for rendering
- ✅ Emit `GAME_EVENT.custom_reward_eaten` when eaten
- ✅ Trigger `onCustomRewardEaten` callback with details

**No Fallback System:**
- If no rewards are marked as default, they all behave as custom rewards
- No automatic fallback to any specific reward type
- Clean and explicit behavior

## RewardConfig Properties

```dart
class RewardConfig {
  final String id;              // Unique identifier
  final String imagePath;       // Path to reward image asset
  final bool increasesSpeed;    // Whether eating this increases snake speed (default: false)
  final bool isDefaultReward;   // Whether this should behave as default reward (default: false)
}
```

## Benefits

1. **No more package modification**: Add new rewards from your main app
2. **Unlimited reward types**: No longer limited to predefined types
3. **Better organization**: All reward configs in one place
4. **Type safety**: Still maintains type safety with String IDs
5. **Backward compatible**: Core functionality remains the same

## Game Events

### Simplified Event System
The event system has been simplified to use only two reward-related events:

- `GAME_EVENT.fruit_eaten` - Only for the default fruit reward
- `GAME_EVENT.custom_reward_eaten` - For ALL custom reward types (including cash, coin, spin, and any new rewards)

### Breaking Change
The following events have been **removed** and are now handled by `custom_reward_eaten`:
- ~~`GAME_EVENT.cash_eaten`~~ → Now `custom_reward_eaten` 
- ~~`GAME_EVENT.coin_eaten`~~ → Now `custom_reward_eaten`
- ~~`GAME_EVENT.spin_eaten`~~ → Now `custom_reward_eaten`

### Getting Specific Reward Details
To identify which specific reward was eaten, use the `onCustomRewardEaten` callback:

```dart
SnakeGame(
  // ... other parameters
  controllerEvent: gameEventController,
  onCustomRewardEaten: (String rewardId, RewardConfig? config) {
    print('Reward eaten: $rewardId');
    
    // Handle ALL reward types (including legacy ones)
    switch (rewardId) {
      case 'cash':
        // Handle cash reward (legacy type)
        addCoins(100);
        break;
      case 'coin':
        // Handle coin reward (legacy type)
        addCoins(10);
        break;
      case 'spin':
        // Handle spin reward (legacy type)
        addSpins(1);
        break;
      case 'diamond':
        // Handle new custom reward
        addGems(5);
        break;
      case 'powerup':
        // Handle another custom reward
        activateShield();
        break;
    }
  },
)
```

### Event Flow for All Rewards (Except Fruit)
1. Player eats any custom reward (cash, coin, spin, diamond, etc.)
2. `GAME_EVENT.custom_reward_eaten` is emitted to `controllerEvent` stream  
3. `onCustomRewardEaten` callback is called with specific reward details

### Legacy Compatibility
- **Speed Increase**: Cash and coin rewards still increase speed by default (even without explicit config)
- **Event Handling**: You'll need to update code that listened for specific events:

**Before:**
```dart
gameEventController.stream.listen((event) {
  switch (event) {
    case GAME_EVENT.cash_eaten:
      handleCash();
      break;
    case GAME_EVENT.coin_eaten:
      handleCoin();
      break;
  }
});
```

**After:**
```dart
SnakeGame(
  controllerEvent: gameEventController,
  onCustomRewardEaten: (rewardId, config) {
    switch (rewardId) {
      case 'cash':
        handleCash();
        break;
      case 'coin':
        handleCoin();
        break;
    }
  },
)
```
