extends Node

@export var character_scene: PackedScene = preload("res://entities/player.tscn")

signal scores_updated(scores: Dictionary)

const MAX_LEVEL := 6
const SPAWN_POSITION := Vector2(1042, 80)
const FOOD_FOLDER := "res://food_data/"
const SCORE_LIMITS := {
	"spiciness": 100,
	"lactose": 100,
	"bad_breath": 100,
	"freshness": 100,
	"fullness": 100,
	"bully": 2
}

var food_list: Array[FoodData] = []
var last_spawned: CharacterBody2D = null
var game_over := false
var scores := {
	"spiciness": 0,
	"lactose": 0,
	"bad_breath": 0,
	"freshness": 0,
	"fullness": 0,
	"bully": 0
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
	
func spawn_new(level: int) -> CharacterBody2D:
	if game_over:
		return null
	var new_body = character_scene.instantiate()
	new_body.global_position = SPAWN_POSITION
	new_body.level = level

	var chosen_food: FoodData = food_list[randi() % food_list.size()]
	new_body.food_data = chosen_food

	get_tree().current_scene.add_child(new_body)
	last_spawned = new_body
	return new_body

func is_last_spawned(body: Node) -> bool:
	return body == last_spawned
	
func apply_bonus_for_body(body: Node) -> void:
	var food: FoodData = body.food_data
	if food == null:
		return
	#scores["spiciness"]  += food.spiciness
	#scores["lactose"]    += food.lactose
	#scores["bad_breath"] += food.bad_breath
	#scores["freshness"]  += food.freshness
	#scores["fullness"]   += food.fullness
	scores["bully"]       += food.bully
	print("scored bully, \nbully value:")
	print(scores["bully"])
	scores_updated.emit(scores)
	
func check_stop_conditions(new_level: int) -> bool:
	if new_level == MAX_LEVEL:
		return true
	for score_key in scores.keys():
		if scores[score_key] >= SCORE_LIMITS[score_key]:
			return true
	return false
