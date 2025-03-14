extends Control

func game_over() -> void:
	show()
	Engine.time_scale = 0
	
	$HighScoreLabel.text = "High Score: " + str(Global.get_high_score())

func _on_play_again_button_pressed() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()
