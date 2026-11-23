extends Node2D



func move_to(pos: Vector2) -> void:
	%ScreenTransitionPlayer.play("fade_out")
	await %ScreenTransitionPlayer.animation_finished
	%GameCamera.global_position = pos
	%ScreenTransitionPlayer.play("fade_in")

func _ready() -> void:
	$Menu/NextButton.pressed.connect(func():
		GameManager.current_area += 1
		if GameManager.current_area > GameManager.Areas.size() - 1: GameManager.current_area = 0
		next_area()
	)
	$Menu/PrevButton.pressed.connect(func():
		GameManager.current_area -= 1
		if GameManager.current_area < 0: GameManager.current_area = GameManager.Areas.size() - 1
		next_area()
	)

func next_area() -> void:
	match GameManager.current_area:
			GameManager.Areas.SHOP: move_to($CameraPositions/Shop.global_position)
			GameManager.Areas.BAKING: move_to($CameraPositions/Baking.global_position)
			GameManager.Areas.STOVE: move_to($CameraPositions/Stove.global_position)
			GameManager.Areas.TABLE: move_to($CameraPositions/Table.global_position)
