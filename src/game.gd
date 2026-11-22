extends Node2D

enum Areas {
	SHOP, BAKING, STOVE, TABLE
}

@export var current_area := Areas.SHOP

func move_to(pos: Vector2) -> void:
	%ScreenTransitionPlayer.play("fade_out")
	await %ScreenTransitionPlayer.animation_finished
	%GameCamera.global_position = pos
	%ScreenTransitionPlayer.play("fade_in")

func _ready() -> void:
	$Menu/NextButton.pressed.connect(func():
		current_area += 1
		if current_area > Areas.size() - 1: current_area = 0
		next_area()
	)
	$Menu/PrevButton.pressed.connect(func():
		current_area -= 1
		if current_area < 0: current_area = Areas.size() - 1
		next_area()
	)

func next_area() -> void:
	match current_area:
			Areas.SHOP: move_to($CameraPositions/Shop.global_position)
			Areas.BAKING: move_to($CameraPositions/Baking.global_position)
			Areas.STOVE: move_to($CameraPositions/Stove.global_position)
			Areas.TABLE: move_to($CameraPositions/Table.global_position)
