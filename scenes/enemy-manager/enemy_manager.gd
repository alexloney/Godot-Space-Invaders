extends Node2D

signal enemy_landed()

@export var enemy: PackedScene
var x_space: int = 5
var y_space: int = 20
var rows: int = 2
var ship_1_rows: int = 2
var ship_2_rows: int = 2
var ship_3_rows: int = 4
var columns: int = 11
var ships_min_x: int = 0
var ships_max_x: int = 0
var speed: int = 60
var movement_direction: Global.Direction = Global.Direction.RIGHT
var next_y: int = 0
var vertical_movement_distance: int = 24 + 15

var ship_width: int = 28
var mothership_width: int = 42

var mothership: Node2D
var ships: Array[Array]

# Can I give a ship a start and range and tell it to progress?
# No - this starts to get out of sync

func create_ship(type: Global.EnemyShips, start_y: int, offset: int) -> Node2D:
	var new_enemy: Node2D = enemy.instantiate()
	add_child(new_enemy)
	
	new_enemy.spawn_enemy(type)
	var start_x = new_enemy.get_width() / 2 + offset * new_enemy.get_width() + offset * x_space
	new_enemy.position = Vector2(start_x, start_y)
	new_enemy.add_group("enemy")
	new_enemy.set_collision_layer_value(Global.CollisionLayer.ENEMY, true)
	return new_enemy

func spawn_ships() -> void:
	# Keep track of the y-position for each row
	var start_y = 0
	
	# Now loop through the first set of ships rows, create a new ship, and store it
	# in our array of ships
	for i in range(0, ship_1_rows):
		var ship_height: int = 0
		var row: Array = []
		for j in range(0, columns):
			var new_enemy: Node2D = create_ship(Global.EnemyShips.INVADER_1, start_y, j)
			ship_height = new_enemy.get_height()
			row.append(new_enemy)
		start_y += ship_height + y_space
		ships.append(row)
	
	# Do the same for ship type 2
	for i in range(0, ship_2_rows):
		var ship_height: int = 0
		var row: Array = []
		for j in range(0, columns):
			var new_enemy: Node2D = create_ship(Global.EnemyShips.INVADER_2, start_y, j)
			ship_height = new_enemy.get_height()
			row.append(new_enemy)
		start_y += ship_height + y_space
		ships.append(row)
	
	# And again for type 3 ship
	for i in range(0, ship_3_rows):
		var ship_height: int = 0
		var row: Array = []
		for j in range(0, columns):
			var new_enemy: Node2D = create_ship(Global.EnemyShips.INVADER_3, start_y, j)
			ship_height = new_enemy.get_height()
			row.append(new_enemy)
		start_y += ship_height + y_space
		ships.append(row)
	
	# TODO: Implement Mothership

func _physics_process(delta: float) -> void:
	# Check for collision by checking the ray cast on each invader. This seems
	# inefficient, is there maybe a way to disable the ray casters we don't care
	# about, or add a ray caster to the EnemeyManger as a whole?
	var trigger_down: bool = false
	for i in range(len(ships)):
		for j in range(len(ships[i])):
			if ships[i][j]:
				if movement_direction == Global.Direction.LEFT and ships[i][j].ray_cast_2d_left.is_colliding():
					var collider = ships[i][j].ray_cast_2d_left.get_collider()
					if collider and collider.is_in_group("walls"):
						movement_direction = Global.Direction.DOWN_THEN_RIGHT
						trigger_down = true
				if movement_direction == Global.Direction.RIGHT and ships[i][j].ray_cast_2d_right.is_colliding():
					var collider = ships[i][j].ray_cast_2d_right.get_collider()
					if collider and collider.is_in_group("walls"):
						movement_direction = Global.Direction.DOWN_THEN_LEFT
						trigger_down = true
				if (movement_direction == Global.Direction.DOWN_THEN_RIGHT or movement_direction == Global.Direction.DOWN_THEN_LEFT) and ships[i][j].ray_cast_2d_down.is_colliding():
					var collider = ships[i][j].ray_cast_2d_down.get_collider()
					if collider and collider.is_in_group("ground"):
						emit_signal("enemy_landed")

	# If our enemy detected a wall, we will set the next Y position for us to move to
	if trigger_down:
		next_y = position.y + vertical_movement_distance
	
	# Apply the movement, this is either side-to-side or downward if we are at a wall
	match movement_direction:
		Global.Direction.RIGHT:
			position.x += speed * delta
		Global.Direction.LEFT:
			position.x -= speed * delta
		Global.Direction.DOWN_THEN_RIGHT:
			position.y += speed * delta
			if position.y >= next_y:
				movement_direction = Global.Direction.RIGHT
		Global.Direction.DOWN_THEN_LEFT:
			position.y += speed * delta
			if position.y >= next_y:
				movement_direction = Global.Direction.LEFT
