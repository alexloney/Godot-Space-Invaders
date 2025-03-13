extends CharacterBody2D

@export var bullet : PackedScene

var ship_width: int = 28
var ship_color: Global.Colors

func apply_bounds():
	position.x = clamp(position.x, 0 + ship_width / 2, get_viewport().size.x - ship_width / 2)
	pass

func set_ship_color(color: Global.Colors) -> void:
	ship_color = color
	display_ship()

func display_ship() -> void:
	$Ships/Blue.hide()
	$Ships/Yellow.hide()
	$Ships/Pink.hide()
	
	if ship_color == Global.Colors.BLUE:
		$Ships/Blue.show()
	elif ship_color == Global.Colors.YELLOW:
		$Ships/Yellow.show()
	elif ship_color == Global.Colors.PINK:
		$Ships/Pink.show()

func fire_bullet() -> void:
	var new_bullet : Node2D = bullet.instantiate()
	new_bullet.position = Vector2(position.x, position.y - 12)
	get_tree().root.add_child(new_bullet)
	new_bullet.set_bullet_type(Global.BulletType.PLAYER)
	new_bullet.set_bullet_color(ship_color)

func destroy_player() -> void:
	print("Destroy player!")
	pass

func _ready() -> void:
	set_ship_color(Global.Colors.BLUE)

func _physics_process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		position.x = event.position.x
		apply_bounds()
	
	if Input.is_action_just_pressed("click"):
		fire_bullet()
