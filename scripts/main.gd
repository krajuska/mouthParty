extends Control

const ROWS: int = 12
const COLUMNS: int = 18
const BLOCK_SIZE: int = 160
const START_POSITION: Vector2i = Vector2i(5, 1)

var grid: Array[Array] = []
var currentPosition

#@onready var gameArea: ColorRect = $GameArea
@onready var gridlines:Node2D = $GameArea/Gridlines
#@onready var background: TextureRect = $GameArea/Background

# food options
@onready var pepper: Sprite2D = $GameArea/Board/Pepper
@onready var banana: Sprite2D = $GameArea/Board/Banana
var food: Array[Sprite2D] = [pepper, banana, pepper, banana, banana, banana, pepper]
var allFood: Array[Sprite2D] = food.duplicate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initializeGrid()
	drawGrid()

	
func initializeGrid() -> void:
	for x in range(ROWS):
		var column: Array[Variant] = []
		for y in range(COLUMNS):
			column.append(null)
		grid.append(column)

func drawGrid() -> void:
	for x in range(ROWS + 1):
		var line: Line2D = Line2D.new()
		line.add_point(Vector2(x * BLOCK_SIZE, 0))
		line.add_point(Vector2(x * BLOCK_SIZE, COLUMNS * BLOCK_SIZE))
		line.width = 1
		line.default_color = Color.ORANGE
		gridlines.add_child(line)
		
	for y in range(COLUMNS + 1):
		var line: Line2D = Line2D.new()
		line.add_point(Vector2(0, y * BLOCK_SIZE))
		line.add_point(Vector2(ROWS * BLOCK_SIZE, y * BLOCK_SIZE))
		line.width = 1
		line.default_color = Color.GHOST_WHITE
		gridlines.add_child(line)
