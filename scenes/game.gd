extends Node2D

@onready var score_label: RichTextLabel = $RichTextLabel
@onready var can_eat: bool = true

var previous_scores := {
	"trouble": 0
}

func _ready() -> void:
	SpawnManager.scores_updated.connect(_on_scores_updated)
	SpawnManager.space_bar_pressed.connect(_on_spacebar_pressed)
	SpawnManager.can_eat.connect(_on_can_eat_changed)


func _on_scores_updated(new_scores: Dictionary) -> void:
	var lines: Array[String] = []
	for key in new_scores.keys():
		lines.append("%s: %d" % [key.capitalize(), new_scores[key]])
	
	if lines.size() > 0:
		score_label.text = "\n".join(lines)
	previous_scores = new_scores.duplicate()

func _on_spacebar_pressed(_pressed: bool) -> void:
	if can_eat:
		SpawnManager.spawn_new()
	else:
		SpawnManager.drop_current()


func _on_can_eat_changed(value: bool) -> void:
	can_eat = value
	
