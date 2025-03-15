extends Node

# Some global constants to prevent using magic numbers all over the place
enum Colors {NONE, BLUE, GREEN, RED, YELLOW, PINK}
enum BulletType {PLAYER, ENEMY}
enum CollisionLayer {PLAYER=1, BUNKER, ENEMY, PLAYER_BULLET, ENEMY_BULLET}
enum ShipStates {ACTIVE, DESTROYING, REVIVING}
enum EnemyShips {NONE, INVADER_1, INVADER_2, INVADER_3, MOTHERSHIP}
enum EnemyShipScores {INVADER_1=10, INVADER_2=20, INVADER_3=40, MOTHERSHIP=100}
enum Direction {DOWN_THEN_RIGHT, DOWN_THEN_LEFT, LEFT, RIGHT}

var high_score: int = 0

# Set the current score, update high score if new score is larger
func set_score(score: int) -> void:
	if score > high_score:
		high_score = score

# Return the current high score
func get_high_score() -> int:
	return high_score
