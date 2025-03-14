extends Node

enum Colors {NONE, BLUE, GREEN, RED, YELLOW, PINK}
enum BulletType {PLAYER, ENEMY}
enum CollisionLayer {PLAYER=1, BUNKER, ENEMY, PLAYER_BULLET, ENEMY_BULLET}
enum ShipStates {ACTIVE, DESTROYING, REVIVING}

var high_score: int = 0

func set_score(score: int) -> void:
	if score > high_score:
		high_score = score

func get_high_score() -> int:
	return high_score
