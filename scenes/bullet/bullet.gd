extends Area2D

var bullet_type: Global.BulletType
var speed: int = 100
var velocity: Vector2 = Vector2(0, 0)
var bullet_color: Global.Colors
var bullet_colors: Dictionary[Global.Colors, Sprite2D] = {}

@onready var ray_cast_2d: RayCast2D = $RayCast2D

func set_bullet_color(color: Global.Colors) -> void:
	bullet_color = color
	
	for key in bullet_colors.keys():
		bullet_colors.get(key).hide()
	bullet_colors.get(bullet_color).show()

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
	

func set_bullet_type(type: Global.BulletType) -> void:
	bullet_type = type
	
	# clear_collision()
	
	if bullet_type == Global.BulletType.PLAYER:
		velocity = Vector2(0, -1)
		#set_collision_layer_value(Global.CollisionLayer.PLAYER_BULLET, true)
		#
		#set_collision_mask_value(Global.CollisionLayer.BUNKER, true)
		#set_collision_mask_value(Global.CollisionLayer.ENEMY, true)
		#set_collision_mask_value(Global.CollisionLayer.ENEMY_BULLET, true)
		
		$RayCast2D.target_position.y = -7
		
		#$RayCast2D.set_collision_mask_value(Global.CollisionLayer.BUNKER, true)
		#$RayCast2D.set_collision_mask_value(Global.CollisionLayer.ENEMY, true)
		#$RayCast2D.set_collision_mask_value(Global.CollisionLayer.ENEMY_BULLET, true)
		
		add_to_group("player_bullet")
		
	elif bullet_type == Global.BulletType.ENEMY:
		velocity = Vector2(0, 1)
		#set_collision_layer_value(Global.CollisionLayer.ENEMY_BULLET, true)
		#
		#set_collision_mask_value(Global.CollisionLayer.BUNKER, true)
		#set_collision_mask_value(Global.CollisionLayer.PLAYER, true)
		#set_collision_mask_value(Global.CollisionLayer.PLAYER_BULLET, true)
		
		$RayCast2D.target_position.y = 7
		#$RayCast2D.set_collision_mask_value(Global.CollisionLayer.BUNKER, true)
		#$RayCast2D.set_collision_mask_value(Global.CollisionLayer.PLAYER, true)
		#$RayCast2D.set_collision_mask_value(Global.CollisionLayer.PLAYER_BULLET, true)
	
		add_to_group("enemy_bullet")
	
	velocity = velocity.normalized()

func _ready() -> void:
	
	bullet_colors[Global.Colors.BLUE] = $Color/Blue
	bullet_colors[Global.Colors.YELLOW] = $Color/Yellow
	bullet_colors[Global.Colors.RED] = $Color/Red
	bullet_colors[Global.Colors.PINK] = $Color/Pink
	bullet_colors[Global.Colors.GREEN] = $Color/Green
	
	if position.y < -5 or position.y > get_viewport().size.y + 5:
		queue_free()

func destroy_bullet():
	for key in bullet_colors.keys():
		bullet_colors.get(key).hide()
	speed = 0
	$CollisionShape2D.set_deferred("disabled", true)
	$Explosion.show()
	$Explosion.play()

func _physics_process(delta: float) -> void:
	if ray_cast_2d.is_colliding():
		var collider = ray_cast_2d.get_collider()
		if ((bullet_type == Global.BulletType.PLAYER and collider.is_in_group("enemy_bullet"))
			or (bullet_type == Global.BulletType.ENEMY and collider.is_in_group("player_bullet"))):
			collider.destroy_bullet()
			destroy_bullet()
		elif bullet_type == Global.BulletType.ENEMY and collider.is_in_group("player"):
			collider.destroy_player()
			destroy_bullet()
			print("Player collision!")
	
	if bullet_type == Global.BulletType.PLAYER:
		position.y -= speed * delta
	elif bullet_type == Global.BulletType.ENEMY:
		position.y += speed * delta


func _on_explosion_animation_finished() -> void:
	queue_free()
