class_name FoodData
extends Resource

@export var food_name: String = ""
@export var sprite_frames: SpriteFrames  # each food's own resource, with "idle"/"falling"/"splat" anims
@export var trouble: int = 0
@export var money: int = 0
@export var popularity: int = 0
@export var star: bool = false
@export var kick: bool = false
@export var taxi: bool = false
@export var peek: bool = false
@export var full_house_bonus: bool = false
@export var brings_friend: int = 0
@export var dancing_bonus: bool = false
