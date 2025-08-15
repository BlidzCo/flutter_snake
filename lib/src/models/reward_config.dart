/// Configuration for a custom reward type
class RewardConfig {
  /// Unique identifier for the reward type
  final String id;

  /// Path to the reward image asset
  final String imagePath;

  /// Whether this reward increases snake speed when eaten
  final bool increasesSpeed;

  /// Whether this reward should behave as a default reward
  /// Default rewards use snakeFruitImgPath and emit GAME_EVENT.fruit_eaten
  final bool isDefaultReward;

  const RewardConfig({
    required this.id,
    required this.imagePath,
    this.increasesSpeed = false,
    this.isDefaultReward = false,
  });
}
