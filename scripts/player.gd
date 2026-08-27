extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const DOWN_VELOCITY = Vector2(0, 0.5)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += DOWN_VELOCITY
		
		var sides := Input.get_axis("ui_left", "ui_right")
		var down := Input.get_axis("ui_down", "")
		#if sides:
			#velocity.x = sides * SPEED
		if down:
			velocity.y = down * SPEED * -6
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	
		move_and_slide()

func _input(event):
	if position.x >= 0 && position.x <= 1920 && not is_on_floor():
		if Input.is_action_just_pressed("ui_left"):
			position.x -= 162
		if Input.is_action_just_pressed("ui_right"):
			position.x += 162
