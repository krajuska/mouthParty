extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const DOWN_VELOCITY = Vector2(0, 0.5)

func _input(event):
	if position.x >= 0 && position.x <= 1920 && not is_on_floor():
		if Input.is_action_just_pressed("ui_left"):
			position.x -= 162
		if Input.is_action_just_pressed("ui_right"):
			position.x += 162

var has_triggered := false  # prevents spawning every physics frame while still touching

func _physics_process(delta):
	if not is_on_floor():
		velocity += DOWN_VELOCITY
		
		var sides := Input.get_axis("ui_left", "ui_right")
		var down := Input.get_axis("ui_down", "")
		if down:
			velocity.y = down * SPEED * -6
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Only the most recently spawned body should trigger new spawns
	if not SpawnManager.is_last_spawned(self) or has_triggered:
		return

	if is_on_floor():
		_on_touch(null)
		return

	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider is CharacterBody2D and collider != self:
			_on_touch(collider)
			return

func _on_touch(touched_body: Node) -> void:
	has_triggered = true

	if touched_body == null:
		print("Touched the floor")
		_apply_bonus("floor")
	else:
		print("Touched: ", touched_body.name)
		_apply_bonus_from(touched_body)

	SpawnManager.spawn_new(global_position)

func _apply_bonus_from(body: Node) -> void:
	# Identify WHICH kind of body it was — groups are the cleanest way
	if body.is_in_group("spicy_group"):
		_apply_bonus("spice")
	elif body.is_in_group("fresh_group"):
		_apply_bonus("fresh")
	elif body.is_in_group("neutral_group"):
		_apply_bonus("neutralize")
	elif body.is_in_group("full_group"):
		_apply_bonus("fullness")
	else:
		_apply_bonus("generic")

#types of bonus we'll have:
#spice: for peppers (+X spicyness)
#fresh: for peppermint (-X bad breath)
#neutralize: for dairy products (-X spicyness)
#fullness: banana, flex seeds (+X full)
func _apply_bonus(bonus_type: String) -> void:
	match bonus_type:
		"spice":
			pass # e.g. score += 100
		"fresh":
			pass # e.g. health -= 10
		"neutralize":
			pass
		"fullness":
			pass
