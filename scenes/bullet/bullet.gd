extends Area2D

var bullet_type: Global.BulletType
var speed: int = 300
var bullet_color: Global.Colors
var bullet_colors: Dictionary[Global.Colors, Sprite2D] = {}
var ray_cast_length: int = 7

@onready var ray_cast_2d: RayCast2D = $RayCast2D

# Assign a color to the bullet by first hiding all other colors then showing this color
func set_bullet_color(color: Global.Colors) -> void:
	bullet_color = color
	
	# Hide all bullets
	for key in bullet_colors.keys():
		bullet_colors[key].hide()
	
	# Show only the color we care about
	if bullet_color in bullet_colors:
		bullet_colors[bullet_color].show()

# Remove the collision from everything on this object to reset it to a blank state
# for setting collisions later
func clear_collision() -> void:
	set_collision_layer_value(Global.CollisionLayer.PLAYER, false)
	set_collision_layer_value(Global.CollisionLayer.BUNKER, false)
	set_collision_layer_value(Global.CollisionLayer.ENEMY, false)
	set_collision_layer_value(Global.CollisionLayer.PLAYER_BULLET, false)
	set_collision_layer_value(Global.CollisionLayer.ENEMY_BULLET, false)
	
	set_collision_mask_value(Global.CollisionLayer.PLAYER, false)
	set_collision_mask_value(Global.CollisionLayer.BUNKER, false)
	set_collision_mask_value(Global.CollisionLayer.ENEMY, false)
	set_collision_mask_value(Global.CollisionLayer.PLAYER_BULLET, false)
	set_collision_mask_value(Global.CollisionLayer.ENEMY_BULLET, false)
	
	$RayCast2D.set_collision_mask_value(Global.CollisionLayer.PLAYER, false)
	$RayCast2D.set_collision_mask_value(Global.CollisionLayer.BUNKER, false)
	$RayCast2D.set_collision_mask_value(Global.CollisionLayer.ENEMY, false)
	$RayCast2D.set_collision_mask_value(Global.CollisionLayer.PLAYER_BULLET, false)
	$RayCast2D.set_collision_mask_value(Global.CollisionLayer.ENEMY_BULLET, false)

# Given the bullet type, use it to set the direction and the collision layers
func set_bullet_type(type: Global.BulletType) -> void:
	# Save the bullet type for detection comparison later
	bullet_type = type
	
	# Clear all collision layers
	clear_collision()
	
	if bullet_type == Global.BulletType.PLAYER:
		
		# Set this bullet on the player bullet layer
		set_collision_layer_value(Global.CollisionLayer.PLAYER_BULLET, true)
		
		# Set ray cast length upward for a player bullet
		$RayCast2D.target_position.y = -ray_cast_length
		
		# Set the ray cast collision to detect bunkers, enemies, and enemy bullets
		$RayCast2D.set_collision_mask_value(Global.CollisionLayer.BUNKER, true)
		$RayCast2D.set_collision_mask_value(Global.CollisionLayer.ENEMY, true)
		$RayCast2D.set_collision_mask_value(Global.CollisionLayer.ENEMY_BULLET, true)
		
		# Add this to the player bullet group for later detection
		add_to_group("player_bullet")
		
	elif bullet_type == Global.BulletType.ENEMY:
		
		# Set this bullet on the enemy bullet layer
		set_collision_layer_value(Global.CollisionLayer.ENEMY_BULLET, true)
		
		# Set the ray cast length downward for an enemy bullet
		$RayCast2D.target_position.y = 7
		
		# Set the ray cast collision to detect bunker, player, and player bullets
		$RayCast2D.set_collision_mask_value(Global.CollisionLayer.BUNKER, true)
		$RayCast2D.set_collision_mask_value(Global.CollisionLayer.PLAYER, true)
		$RayCast2D.set_collision_mask_value(Global.CollisionLayer.PLAYER_BULLET, true)
	
		# Add this to the enemy bullet group for later detection
		add_to_group("enemy_bullet")

func _ready() -> void:
	
	# Store references to all of the bullet collers for later use when selecting
	# the bullet sprite
	bullet_colors[Global.Colors.BLUE] = $Color/Blue
	bullet_colors[Global.Colors.YELLOW] = $Color/Yellow
	bullet_colors[Global.Colors.RED] = $Color/Red
	bullet_colors[Global.Colors.PINK] = $Color/Pink
	bullet_colors[Global.Colors.GREEN] = $Color/Green

# Triggered on a bullet being destroyed, cause an explosion
func destroy_bullet():
	# Hide all of the sprites
	for key in bullet_colors.keys():
		bullet_colors.get(key).hide()
	
	# Stop the bullet from moving forward
	speed = 0
	
	# Disable the ray cast if the bullet is being destroyed, we don't want to trigger
	# destroy events multiple times.
	$RayCast2D.set_deferred("enabled", false)
	
	# Disable collisions with this bullet
	$CollisionShape2D.set_deferred("disabled", true)
	
	# And play the explosion effect
	$Explosion.show()
	$Explosion.play()

func _process(delta: float) -> void:
	# If the bullet goes outside of the viewport, automatically free it. We don't
	# want bullets to just float out there forever
	if position.y < -5 or position.y > get_viewport().size.y + 5:
		queue_free()

func _physics_process(delta: float) -> void:
	# Check to see if the ray cast has detected anything
	if ray_cast_2d.is_colliding():
		# Obtain the object that has been collided with
		var collider = ray_cast_2d.get_collider()
		
		if collider:
			# If it has collided with a bullet (either player -> enemy or enemy -> player)
			# call destroy on both bullets to destroy them
			if ((bullet_type == Global.BulletType.PLAYER and collider.is_in_group("enemy_bullet"))
				or (bullet_type == Global.BulletType.ENEMY and collider.is_in_group("player_bullet"))):
				collider.destroy_bullet()
				destroy_bullet()
			
			# If it has collided with the player, inform the player that the collision has
			# occured and destroy the bullet. Let the player handle what happens next for it.
			elif bullet_type == Global.BulletType.ENEMY and collider.is_in_group("player"):
				collider.destroy_player()
				destroy_bullet()
			
			# If it has collided with an enemy ship, destroy the enemy chip
			elif bullet_type == Global.BulletType.PLAYER and collider.is_in_group("enemy"):
				collider.destroy_ship()
				destroy_bullet()
			
			elif collider.is_in_group("bunker"): 
				collider.destroy_bunker()
				destroy_bullet()
	
	# Move the bullet either up or down, depending on who fired the bullet
	if bullet_type == Global.BulletType.PLAYER:
		position.y -= speed * delta
	elif bullet_type == Global.BulletType.ENEMY:
		position.y += speed * delta

# Once the explosion effect finishes playing, free the bullet from memory
func _on_explosion_animation_finished() -> void:
	queue_free()
