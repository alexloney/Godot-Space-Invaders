extends Node2D

func hide_life(color: Global.Colors) -> void:
	match color:
		Global.Colors.BLUE:
			$AnimationPlayer.play("hide_blue")
		Global.Colors.YELLOW:
			$AnimationPlayer.play("hide_yellow")
		Global.Colors.PINK:
			$AnimationPlayer.play("hide_pink")
