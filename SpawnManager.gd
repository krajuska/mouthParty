extends Node

@export var character_scene: PackedScene = preload("res://entities/player.tscn")
var last_spawned: CharacterBody2D = null

func spawn_new(at_position: Vector2) -> CharacterBody2D:
	var new_body = character_scene.instantiate()
	new_body.global_position = at_position
	get_tree().current_scene.add_child(new_body)
	last_spawned = new_body
	return new_body

func is_last_spawned(body: Node) -> bool:
	return body == last_spawned
