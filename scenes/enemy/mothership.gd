extends Area2D

var ship_width: int = 42
var ship_height: int = 12
var bound_min_x: int = 0
var bound_max_x: int = 0

func get_width() -> int:
	return ship_width

func get_height() -> int:
	return ship_height

func set_bounds_x(min_x: int, max_x: int) -> void:
	bound_min_x = min_x
	bound_max_x = max_x
