extends Node2D

@export var enemy: PackedScene

# A reference to the mothership object for interacting with
var mothership_ref: Node2D

# Speed at which the mothership should move
var speed: int = 100

# Direction in which the mothership is moving in
var direction: Global.Direction = Global.Direction.LEFT

# Spawn a new mothership, pick a random direction, and begin it moving in that direction
func spawn_mothership() -> void:
	if not mothership_ref:
		mothership_ref = enemy.instantiate()
		mothership_ref.spawn_enemy(Global.EnemyShips.MOTHERSHIP)
		
		mothership_ref.add_group("enemy")
		mothership_ref.set_collision_layer_value(Global.CollisionLayer.ENEMY, true)
		
		var dir: int = randi() % 2
		if dir == 0:
			mothership_ref.position = Vector2(-50, 0)
			direction = Global.Direction.RIGHT
		else:
			mothership_ref.position = Vector2(get_viewport().size.x + 50, 0)
			direction = Global.Direction.LEFT
		
		add_child(mothership_ref)

# Move the mothership in the direction it is heading. If it exits the scene, 
# free the mothership. A new one will eventually be spawned.
func _physics_process(delta: float) -> void:
	if mothership_ref:
		match direction:
			Global.Direction.LEFT:
				mothership_ref.position.x -= speed * delta
				if mothership_ref.position.x < -50:
					mothership_ref.queue_free()
					mothership_ref = null
			Global.Direction.RIGHT:
				mothership_ref.position.x += speed * delta
				if mothership_ref.position.x > get_viewport().size.x + 50:
					mothership_ref.queue_free()
					mothership_ref = null

# Every so often, there's a 20% chance of the mothership spawning
func _on_spawn_timer_timeout() -> void:
	var chance: int = randi() % 100
	
	if chance < 20:
		spawn_mothership()
