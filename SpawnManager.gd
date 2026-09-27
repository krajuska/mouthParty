extends Node

@export var character_scene: PackedScene = preload("res://entities/player.tscn")

signal scores_updated(scores: Dictionary)
signal can_eat(answer: bool)
signal space_bar_pressed(bool)

const MAX_LEVEL := 6
const SPAWN_POSITION := Vector2(1042, 80)
const FOOD_FOLDER := "res://food_data/"
const SCORE_LIMITS := {
	"bully": 3,
	"peace": 100
}

var food_list: Array[FoodData] = []
var game_over := false
var scores := {
	"bully": 0,
	"peace": 0
}

func _ready() -> void:
	_load_all_foods()
	
func _load_all_foods() -> void:
	var dir := DirAccess.open(FOOD_FOLDER)
	if dir == null:
		push_error("Could not open food data folder")
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			var res: Resource = load(FOOD_FOLDER + file_name)
			if res is FoodData:
				food_list.append(res)
		file_name = dir.get_next()
	dir.list_dir_end()
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("eat"):
		space_bar_pressed.emit(true)
	
func spawn_new() -> CharacterBody2D:
	if game_over:
		return null
		
	var new_body = character_scene.instantiate()
	new_body.global_position = SPAWN_POSITION

	var chosen_food: FoodData = food_list[randi() % food_list.size()]
	new_body.food_data = chosen_food

	get_tree().current_scene.add_child(new_body)
	return new_body
	
func score_points(body: Node) -> void:
	var food: FoodData = body.food_data
	if food == null:
		return
	scores["bully"]       += food.bully
	scores["bully"]       -= food.peace
	scores_updated.emit(scores)
	
	
func check_stop_conditions() -> bool:
	for score_key in scores.keys():
		if scores[score_key] >= SCORE_LIMITS[score_key]:
			return true
	can_eat.emit(true)
	return false
