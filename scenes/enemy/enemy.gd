extends Node2D

@onready var ray_cast_2d_left: RayCast2D = $RayCast2DLeft
@onready var ray_cast_2d_right: RayCast2D = $RayCast2DRight

var ship_type: Global.EnemyShips = Global.EnemyShips.NONE
var ship_ref: Area2D
var movement: Global.Direction = Global.Direction.RIGHT
var speed: int = 100

var ship_width: int = 28
var mothership_width: int = 42

func hide_ships() -> void:
	$Invader1.hide()
	$Invader2.hide()
	$Invader3.hide()
	$Mothership.hide()

func spawn_enemy(ship: Global.EnemyShips) -> void:
	hide_ships()
	ship_type = ship
	
	match ship:
		Global.EnemyShips.INVADER_1:
			$Invader1.show()
			ship_ref = $Invader1
		Global.EnemyShips.INVADER_2:
			$Invader2.show()
			ship_ref = $Invader2
		Global.EnemyShips.INVADER_3:
			$Invader3.show()
			ship_ref = $Invader3
		Global.EnemyShips.MOTHERSHIP:
			$Mothership.show()
			ship_ref = $Mothership

func set_bounds(x: int, y: int, min_x: int, max_x: int) -> void:
	if ship_ref:
		ship_ref.position = Vector2(x, y)
		ship_ref.set_bounds_x(min_x, max_x)

func get_width() -> int:
	return ship_ref.get_width()

func get_height() -> int:
	return ship_ref.get_height()
