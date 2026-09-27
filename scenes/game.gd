extends Node2D

@onready var score_label: RichTextLabel = $RichTextLabel
@onready var can_eat: bool = true

var previous_scores := {
	"bully": 0
}

func _ready() -> void:
	SpawnManager.scores_updated.connect(_on_scores_updated)
	SpawnManager.space_bar_pressed.connect(_on_spacebar_pressed)

func _on_scores_updated(new_scores: Dictionary) -> void:
	var lines: Array[String] = []
	for key in new_scores.keys():
		var delta: int = new_scores[key] - previous_scores.get(key, 0)
		var sign_str: String  
		if delta > 0:
			sign_str = "+"
		else:
			sign_str = ""
			
		lines.append("%s: %s%d // Total: %d)" % [key.capitalize(), sign_str, delta, new_scores[key]])
	
	if lines.size() > 0:
		score_label.text = "\n".join(lines)
	previous_scores = new_scores.duplicate()

func _on_spacebar_pressed(can_drop_next: bool) -> void:
	can_eat = can_drop_next
	if can_eat:
		can_eat = false
		SpawnManager.spawn_new()
	else:
		return
