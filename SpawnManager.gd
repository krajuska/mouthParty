extends Node

@export var character_scene: PackedScene = preload("res://entities/player.tscn")

signal scores_updated(scores: Dictionary)
signal can_eat(bool)
signal space_bar_pressed(bool)

const MAX_LEVEL := 6
const SPAWN_POSITION := Vector2(1042, 80)
const FOOD_FOLDER := "res://food_data/"
const SCORE_LIMITS := {
	"trouble" = 3,
	"max_capacity" = MAX_LEVEL
}

var food_list: Array[FoodData] = []
var level_food_list: Array[String] = ["fries", "fries", #2 money guys
									  "banana", "banana", "banana", "banana", #4 trouble guys
									  "garlic", "garlic", "garlic", "garlic"] #4 regular guys
var pool: Array[String] = []
var current_food: CharacterBody2D = null
var game_over := false
var scores := {
	"trouble" = 0,
	"money" = 0,
	"popularity" = 0,
	"star" = 0,
	"kick" = 0,
	"taxi" = 0,
	"peek" = 0,
	"brings_friend" = 0,
	"full_house_bonus" = 0,
	"dancing_bonus" = 0,
	"people" = 0
}

func _ready() -> void:
	_load_all_foods()
	
func _load_all_foods() -> void:
	pool = level_food_list.duplicate()
	pool.shuffle()

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
				if pool.has(res.food_name):
					pool.pop_back()
					food_list.append(res)
		file_name = dir.get_next()
	dir.list_dir_end()
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("eat"):
		space_bar_pressed.emit(true)

func spawn_new() -> CharacterBody2D:
	can_eat.emit(false)
	if game_over:
		return null

	var new_body = character_scene.instantiate()
	new_body.global_position = SPAWN_POSITION

	var chosen_food: FoodData = food_list[randi() % food_list.size()]
	new_body.food_data = chosen_food

	get_tree().current_scene.add_child(new_body)
	current_food = new_body
	return new_body

func drop_current() -> void:
	if game_over:
		return
	if is_instance_valid(current_food):
		current_food.hard_drop()
			
func score_points(body: Node) -> void:
	var food: FoodData = body.food_data
	if food == null:
		return
		
	scores["trouble"]       	 += food.trouble
	scores["money"]        		 += food.money
	scores["popularity"]         += food.popularity
	scores["star"]       		 += 1 if food.star else 0
	scores["kick"]       		 += 1 if food.kick else 0
	scores["taxi"]       		 += 1 if food.taxi else 0
	scores["peek"]       		 += 1 if food.peek else 0
	scores["brings_friend"]      = food.brings_friend
	scores["full_house_bonus"]   += 1 if food.full_house_bonus else 0
	scores["dancing_bonus"]      += 1 if food.dancing_bonus else 0
	scores["people"]			 += food.brings_friend if food.brings_friend > 0 else +1
	scores_updated.emit(scores)
	
func check_stop_conditions() -> bool:
	if scores["trouble"] >= SCORE_LIMITS["trouble"] || scores["people"] >= SCORE_LIMITS["max_capacity"]:
		return true
	can_eat.emit(true)
	return false
