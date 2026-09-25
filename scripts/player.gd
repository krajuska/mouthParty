extends CharacterBody2D

#@export var is_initial_spawn: bool = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var level: int = 0
var has_triggered := false # prevents spawning every physics frame while still touching

const SPEED = 300.0
const DOWN_VELOCITY = Vector2(0, 0.5)

var food_data: FoodData = null

func _ready() -> void:
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
	_update_visual_from_food()
	
func _on_animation_finished() -> void:
	print("finished animation: ", animated_sprite_2d.animation)

	if animated_sprite_2d.animation != "idle":
		animated_sprite_2d.play("idle")
		
func _update_visual_from_food() -> void:
	if food_data == null or food_data.sprite_frames == null:
		return
	animated_sprite_2d.sprite_frames = food_data.sprite_frames
	animated_sprite_2d.play("idle")
	
func _input(event):
	if position.x >= 0 && position.x <= 1920 && not is_on_floor():
		if Input.is_action_just_pressed("ui_left"):
			position.x -= 162
		if Input.is_action_just_pressed("ui_right"):
			position.x += 162

func _physics_process(delta):
	if not is_on_floor():
		velocity += DOWN_VELOCITY

		var sides := Input.get_axis("ui_left", "ui_right")
		var down := Input.get_axis("ui_down", "")
		if down:
			velocity.y = down * SPEED * -6
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
#
	if has_triggered:
		return

	# check body-to-body collisions FIRST
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider is CharacterBody2D and collider != self:
			_on_touch(collider)
			return

	# only treat as a floor touch if nothing else was hit
	if is_on_floor():
		_on_touch(self)
		return
	if not is_on_floor():
		velocity += DOWN_VELOCITY
		
	var sides := Input.get_axis("ui_left", "ui_right")
	var down := Input.get_axis("ui_down", "")
	if down:
		velocity.y = down * SPEED * -6
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if is_on_floor():
		_on_touch(self)
		return

	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider is CharacterBody2D and collider != self:
			_on_touch(collider)
			return
			
	move_and_slide()

func _on_touch(touched_body: Node) -> void:
	has_triggered = true

	if touched_body != null:
		SpawnManager.apply_bonus_for_body(self)

	animated_sprite_2d.play("splat")

	if SpawnManager.check_stop_conditions():
		SpawnManager.game_over = true
		print("game over")
		return

	SpawnManager.spawn_new()
