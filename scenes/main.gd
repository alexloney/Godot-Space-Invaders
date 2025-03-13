extends Node

@export var bullet : PackedScene

func _on_test_timer_timeout() -> void:
	
	var new_bullet : Node2D = bullet.instantiate()
	new_bullet.position = Vector2(100, 10)
	get_tree().root.add_child(new_bullet)
	new_bullet.set_bullet_type(Global.BulletType.ENEMY)
	new_bullet.set_bullet_color(Global.Colors.GREEN)
	
	
	
	#new_bullet = bullet.instantiate()
	#new_bullet.position = Vector2(100, 400)
	#get_tree().root.add_child(new_bullet)
	#new_bullet.set_bullet_type(Global.BulletType.PLAYER)
	#new_bullet.set_bullet_color(Global.Colors.BLUE)
