enum GAME_EVENT {
  win,
  out_of_map,
  hit_his_tail,
  touch_lava,
  fruit_eaten,

  /// Generic event for all custom reward types (including cash, coin, spin, etc.)
  custom_reward_eaten,
}
