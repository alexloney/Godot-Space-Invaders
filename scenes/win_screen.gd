extends Control

# Trigger a game over with a win screen. The player won! Pull and display the
# high score on the screen.
func you_win() -> void:
	show()
	Engine.time_scale = 0
	$HighScoreLabel.text = "High Score: " + str(Global.get_high_score())

# When the play again button is pressed, restore time and reoload the scene
func _on_play_again_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
