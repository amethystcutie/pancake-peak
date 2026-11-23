extends Node

enum Areas {
	SHOP, BAKING, STOVE, TABLE
}

@export var current_area := Areas.SHOP

signal switched_to(area: Areas)

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
