extends Node

@export var bullet : PackedScene

# Keep track of the player lives
var lives: int = 3

# Keep track of the current score obtained
var score: int = 0

# When the game has ended, show the Game Over screen and let it handle everything
func game_over() -> void:
	$GameOverScreen.game_over()

# Player has signaled that they've died. We will reduce the lives and continue, or
# if no lives remain we will end the game.
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

# Triggered when the player ship tries to respawn but has no more colors it can
# switch to, triggering a game over
func _on_player_player_game_over() -> void:
	game_over()

# Add the desired points to the score and update the display
# TODO: This requires other nodes locating and calling this function. I'd rather have
#       this as a signal, but the signal was not getting executed
func add_score(points: int) -> void:
	score += points
	Global.set_score(score)
	$UI/ScoreLabel.text = str(score)

# When an enemy ship is destroyed, add points to the score and increase the difficulty.
# If no enemy ships remain, then it's a game over with the player winning
# TODO: This requires other nodes locating and calling this function. I'd rather have
#       this as a signal, but the signal was not getting executed
func enemy_destroyed(points: int) -> void:
	add_score(points)
	$EnemyManager.increase_speed()
	
	if $EnemyManager.all_ships_destroyed():
		$WinScreen.you_win()

# When an enemy ship touches ground, this is triggered, causing a game over
func _on_enemy_manager_enemy_landed() -> void:
	game_over()
