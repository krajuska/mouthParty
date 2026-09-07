extends Node

@export var character_scene: PackedScene = preload("res://entities/player.tscn")
const MAX_LEVEL := 6

const SPAWN_POSITION := Vector2(1042, 80)

const SCORE_LIMITS := {
	"spiciness": 100,
	"lactose": 100,
	"stinky": 100,
	"freshness": 100,
	"fullness": 100,
}

const GROUP_BONUSES := {
	"spicy_block":  {"spiciness": 10},
	"dairy_block":  {"lactose": 15, "spiciness": -5},
	"fresh_block":  {"freshness": 5, "stinky": -5},
	"neutral_block": {"spiciness": -10},
	"full_block": {"fullness": 10},
	"stinky_block": {"stinky": 20, "freshness": -10},
	"heavy_block":  {"fullness": 25},
}

var last_spawned: CharacterBody2D = null
var game_over := false
var scores := {
	"spiciness": 0,
	"lactose": 0,
	"stinky": 0,
	"freshness": 0,
	"fullness": 0,
}

func spawn_new(level: int) -> CharacterBody2D:
	if game_over:
		return null
	var new_body = character_scene.instantiate()
	new_body.global_position = SPAWN_POSITION
	new_body.level = level
	get_tree().current_scene.add_child(new_body)
	last_spawned = new_body
	return new_body

func is_last_spawned(body: Node) -> bool:
	return body == last_spawned
	
func apply_bonus_for_body(body: Node) -> void:
	for group_name in GROUP_BONUSES.keys():
		if body.is_in_group(group_name):
			var bonus: Dictionary = GROUP_BONUSES[group_name]
			for score_key in bonus.keys():
				scores[score_key] += bonus[score_key]

func check_stop_conditions(new_level: int) -> bool:
	if new_level == MAX_LEVEL:
		return true
	for score_key in scores.keys():
		if scores[score_key] >= SCORE_LIMITS[score_key]:
			return true
	return false
