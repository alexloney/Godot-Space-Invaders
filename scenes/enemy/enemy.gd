extends Node2D

# signal enemy_destroyed(score: int)

@onready var ray_cast_2d_left: RayCast2D = $RayCast2DLeft
@onready var ray_cast_2d_right: RayCast2D = $RayCast2DRight
@onready var ray_cast_2d_down: RayCast2D = $RayCast2DDown

var ship_type: Global.EnemyShips = Global.EnemyShips.NONE
var ship_ref: Area2D
var movement: Global.Direction = Global.Direction.RIGHT
var speed: int = 100

var ship_width: int = 28
var mothership_width: int = 42

var mothership_score: int = 100
var invader_1_score: int = 30
var invader_2_score: int = 20
var invader_3_score: int = 10

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
	
	$ShotTimer.wait_time = randf_range(0.5, 1.5)
	$ShotTimer.start()

func set_bounds(x: int, y: int, min_x: int, max_x: int) -> void:
	if ship_ref:
		ship_ref.position = Vector2(x, y)
		ship_ref.set_bounds_x(min_x, max_x)

func get_width() -> int:
	return ship_ref.get_width()

func get_height() -> int:
	return ship_ref.get_height()

func clear_collision_layer():
	set_collision_layer_value(Global.CollisionLayer.PLAYER, false)
	set_collision_layer_value(Global.CollisionLayer.ENEMY, false)
	set_collision_layer_value(Global.CollisionLayer.BUNKER, false)
	set_collision_layer_value(Global.CollisionLayer.PLAYER_BULLET, false)
	set_collision_layer_value(Global.CollisionLayer.ENEMY_BULLET, false)

func set_collision_layer_value(layer: Global.CollisionLayer, value: bool) -> void:
	$Invader1.set_collision_layer_value(layer, value)
	$Invader2.set_collision_layer_value(layer, value)
	$Invader3.set_collision_layer_value(layer, value)
	$Mothership.set_collision_layer_value(layer, value)

func add_group(group: String) -> void:
	$Invader1.add_to_group(group)
	$Invader2.add_to_group(group)
	$Invader3.add_to_group(group)
	$Mothership.add_to_group(group)

func destroy_ship() -> void:
	
	# Below I'm using get_tree() and calling a method on the main node. I'd have
	# preferred to use emit_signal(), but the signal wasn't emitting?
	match ship_type:
		Global.EnemyShips.INVADER_1:
			# emit_signal("enemy_destroyed", Global.EnemyShipScores.INVADER_1)
			get_tree().root.get_node("Main").add_score(Global.EnemyShipScores.INVADER_1)
		Global.EnemyShips.INVADER_2:
			# emit_signal("enemy_destroyed", Global.EnemyShipScores.INVADER_2)
			get_tree().root.get_node("Main").add_score(Global.EnemyShipScores.INVADER_2)
		Global.EnemyShips.INVADER_3:
			# emit_signal("enemy_destroyed", Global.EnemyShipScores.INVADER_3)
			get_tree().root.get_node("Main").add_score(Global.EnemyShipScores.INVADER_3)
		Global.EnemyShips.MOTHERSHIP:
			# emit_signal("enemy_destroyed", Global.EnemyShipScores.MOTHERSHIP)
			get_tree().root.get_node("Main").add_score(Global.EnemyShipScores.MOTHERSHIP)
	
	# TODO: Animate free here
	queue_free()


func _on_shot_timer_timeout() -> void:
	var chance: int = randi() % 100
	
	# 5% chance to fire a bullet
	if chance < 5: 
		ship_ref.fire_bullet()
