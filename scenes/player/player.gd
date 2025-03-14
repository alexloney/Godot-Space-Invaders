extends CharacterBody2D

@export var bullet : PackedScene

signal player_died()
signal player_game_over()

var ship_width: int = 28
var ship_color: Global.Colors
var state: Global.ShipStates
var next_color: Global.Colors

func apply_bounds():
	position.x = clamp(position.x, 0 + ship_width / 2, get_viewport().size.x - ship_width / 2)

func set_ship_color(color: Global.Colors) -> void:
	if state == Global.ShipStates.ACTIVE or state == Global.ShipStates.REVIVING:
		ship_color = color
		display_ship()
	elif state == Global.ShipStates.DESTROYING:
		next_color = color

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
	state = Global.ShipStates.DESTROYING
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("destroy")
	emit_signal("player_died")

func respawn_as(color: Global.Colors) -> void:
	set_ship_color(color)

func _ready() -> void:
	set_ship_color(Global.Colors.BLUE)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		position.x = event.position.x
		apply_bounds()
	
	if Input.is_action_just_pressed("click") and state == Global.ShipStates.ACTIVE:
		fire_bullet()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if state == Global.ShipStates.DESTROYING:
		if next_color != Global.Colors.NONE:
			state = Global.ShipStates.REVIVING
			set_ship_color(next_color)
			next_color = Global.Colors.NONE
			$AnimationPlayer.play("respawn")
		else:
			emit_signal("player_game_over")
	elif state == Global.ShipStates.REVIVING:
		state = Global.ShipStates.ACTIVE
		$CollisionShape2D.set_deferred("disabled", false)
