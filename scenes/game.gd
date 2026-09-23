extends Node2D

@onready var score_label: RichTextLabel = $RichTextLabel

var previous_scores := {
	"bully": 0
}

func _ready() -> void:
	SpawnManager.scores_updated.connect(_on_scores_updated)

func _on_scores_updated(new_scores: Dictionary) -> void:
	var lines: Array[String] = []
	for key in new_scores.keys():
		var delta: int = new_scores[key] - previous_scores.get(key, 0)
		if delta != 0:
			var sign_str := "+" if delta > 0 else ""
			lines.append("%s: %s%d (now %d)" % [key.capitalize(), sign_str, delta, new_scores[key]])
	if lines.size() > 0:
		score_label.text = "\n".join(lines)
	previous_scores = new_scores.duplicate()
