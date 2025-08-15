import 'package:flutter_snake/src/models/reward_config.dart';
import 'package:flutter_snake/src/snake_enums/case_type.dart';
import 'package:flutter_snake/src/utils/snake_part.dart';

class BoardCase {
  SnakePart? partSnake;
  CASE_TYPE caseType;
  String? customRewardType;

  BoardCase({
    this.partSnake,
    this.caseType = CASE_TYPE.empty,
    this.customRewardType,
  });

  /// Returns true if this case contains any type of reward (core or custom)
  bool get hasReward => caseType == CASE_TYPE.fruit || customRewardType != null;

  /// Returns the reward identifier
  String get rewardId {
    if (customRewardType != null) return customRewardType!;
    switch (caseType) {
      case CASE_TYPE.fruit:
        return 'fruit'; // CASE_TYPE.fruit always returns 'fruit'
      case CASE_TYPE.lava:
        return 'lava';
      default:
        return 'empty';
    }
  }

  /// Check if this case contains a default reward based on RewardConfig
  bool isDefaultReward(Map<String, RewardConfig> rewardConfigs) {
    // CASE_TYPE.fruit is always considered default for backward compatibility
    if (caseType == CASE_TYPE.fruit) return true;

    // For custom rewards, check the RewardConfig
    if (customRewardType != null) {
      final config = rewardConfigs[customRewardType!];
      return config?.isDefaultReward ?? false;
    }

    return false;
  }
}
