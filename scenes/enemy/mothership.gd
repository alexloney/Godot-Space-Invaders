extends Area2D

@export var bullet: PackedScene

var ship_width: int = 42
var ship_height: int = 12
var bound_min_x: int = 0
var bound_max_x: int = 0
var ship_color: Global.Colors = Global.Colors.RED

func get_width() -> int:
	return ship_width

func get_height() -> int:
	return ship_height

func destroy_ship() -> void:
	get_parent().destroy_ship()

func fire_bullet() -> void:
	print("pew!")
