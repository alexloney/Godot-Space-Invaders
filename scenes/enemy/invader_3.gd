extends Area2D

@export var bullet: PackedScene

var ship_width: int = 28
var ship_height: int = 28
var bound_min_x: int = 0
var bound_max_x: int = 0
var ship_color: Global.Colors = Global.Colors.GREEN

func get_width() -> int:
	return ship_width
	
func get_height() -> int:
	return ship_height

func destroy_ship() -> void:
	get_parent().destroy_ship()

func fire_bullet() -> void:
	var new_bullet : Node2D = bullet.instantiate()
	get_tree().root.get_node("Main").add_child(new_bullet)
	new_bullet.position = global_position
	new_bullet.set_bullet_type(Global.BulletType.ENEMY)
	new_bullet.set_bullet_color(ship_color)
