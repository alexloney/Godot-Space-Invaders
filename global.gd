extends Node

enum Colors {NONE, BLUE, GREEN, RED, YELLOW, PINK}
enum BulletType {PLAYER, ENEMY}
enum CollisionLayer {PLAYER=1, BUNKER, ENEMY, PLAYER_BULLET, ENEMY_BULLET}
enum ShipStates {ACTIVE, DESTROYING, REVIVING}
enum EnemyShips {NONE, INVADER_1, INVADER_2, INVADER_3, MOTHERSHIP}
enum Direction {DOWN_THEN_RIGHT, DOWN_THEN_LEFT, LEFT, RIGHT}

var high_score: int = 0
# var game_over: bool = false

func set_score(score: int) -> void:
	if score > high_score:
		high_score = score

func get_high_score() -> int:
	return high_score
