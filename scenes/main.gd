extends Node

@export var bullet : PackedScene

var lives: int = 3
var score: int = 0

func game_over() -> void:
	$GameOverScreen.game_over()

func _ready() -> void:
	$EnemyManager.spawn_ships()

func _on_test_timer_timeout() -> void:
	
	var new_bullet : Node2D = bullet.instantiate()
	new_bullet.position = Vector2(100, 600)
	get_tree().root.add_child(new_bullet)
	new_bullet.set_bullet_type(Global.BulletType.ENEMY)
	new_bullet.set_bullet_color(Global.Colors.GREEN)
	
	
	
	#new_bullet = bullet.instantiate()
	#new_bullet.position = Vector2(100, 400)
	#get_tree().root.add_child(new_bullet)
	#new_bullet.set_bullet_type(Global.BulletType.PLAYER)
	#new_bullet.set_bullet_color(Global.Colors.BLUE)


func _on_player_player_died() -> void:
	# Reduce the number of lives the player has remaining
	lives -= 1
	
	# After the first life, we hide the Blue ship
	if lives == 2:
		$PlayerLives.hide_life(Global.Colors.BLUE)
		$Player.respawn_as(Global.Colors.YELLOW)
	
	# After the second life we hide the Yellow ship
	elif lives == 1:
		$PlayerLives.hide_life(Global.Colors.YELLOW)
		$Player.respawn_as(Global.Colors.PINK)
	
	# After the third life we hide the Pink ship and trigger game-over
	else:
		$PlayerLives.hide_life(Global.Colors.PINK)
		$Player.set_ship_color(Global.Colors.NONE)

func _on_player_player_game_over() -> void:
	game_over()

func add_score(points: int) -> void:
	score += points
	Global.set_score(score)
	$UI/ScoreLabel.text = "Score: " + str(score)

func _on_enemy_manager_enemy_landed() -> void:
	game_over()
