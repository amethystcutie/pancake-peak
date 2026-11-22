class_name RuntimeVisibility
extends Node

@export var visibility := true

func _ready() -> void:
	get_parent().visible = visibility
	queue_free()
