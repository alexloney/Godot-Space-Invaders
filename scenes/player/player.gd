extends CharacterBody2D

@export var bullet : PackedScene

# Triggered when the player ship is destroyed, this allows the main game controller
# to detect this and remove a life.
signal player_died()

# Triggered when the player ship would respawn but has no colors left to respawn as,
# thus no lives left.
signal player_game_over()

var ship_width: int = 28
var ship_color: Global.Colors
var state: Global.ShipStates
var next_color: Global.Colors

# Keep the player ship within the game window
func apply_bounds():
	position.x = clamp(position.x, 0 + ship_width / 2, get_viewport().size.x - ship_width / 2)

# Set the color of the player ship. If the ship is in the process of animating a
# destruction, instead queue the next color up in the "next_color" variable
func set_ship_color(color: Global.Colors) -> void:
	if state == Global.ShipStates.ACTIVE or state == Global.ShipStates.REVIVING:
		ship_color = color
		display_ship()
	elif state == Global.ShipStates.DESTROYING:
		next_color = color

# Display the ship using the designated color by first hiding all colors, then
# showing the selected color
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

# Generate a new bullet and send it on it's way. By selecting the bullet type, it
# will automatically apply the required layers. Apply the same color to it as the
# ship.
func fire_bullet() -> void:
	var new_bullet : Node2D = bullet.instantiate()
	new_bullet.position = Vector2(position.x, position.y - 12)
	get_tree().root.get_node("Main").add_child(new_bullet)
	new_bullet.set_bullet_type(Global.BulletType.PLAYER)
	new_bullet.set_bullet_color(ship_color)

# The player ship has been destroyed, play the destroy animation and disable the
# physics on the ship so that it has a brief period of invulnerability.
func destroy_player() -> void:
	state = Global.ShipStates.DESTROYING
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("destroy")
	emit_signal("player_died")

# Respawn the ship as a new color
func respawn_as(color: Global.Colors) -> void:
	set_ship_color(color)

# Ship default color is blue
func _ready() -> void:
	set_ship_color(Global.Colors.BLUE)

# Keep the ship locked to the mouse curser as the cursor moves around. If the
# mouse is clicked, fire a bullet. But only while the ship is active, so no shooting
# in the middle of a respawn animation.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		position.x = event.position.x
		apply_bounds()
	
	if Input.is_action_just_pressed("click") and state == Global.ShipStates.ACTIVE:
		fire_bullet()

# Once the animation has completed, apply the next color to the ship. If the next
# color is not defined (e.g. NONE), then the ship can't respawn and trigger a
# game over
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
