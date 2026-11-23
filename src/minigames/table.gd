extends Node2D
const PANCAKE = preload("uid://dv4m1nxipbl5y")

var pancakes := 0
var has_pancake := true

var difficulty := 2.0

var ticks: float
var active := false

func _ready() -> void:
	$FailZone.body_entered.connect(func(body: Node2D):
		if body is FallingPancake:
			body.apply_torque(30)
			if has_pancake:
				pancakes -= 1
			has_pancake = true)

func _process(delta: float) -> void: 
	active = GameManager.current_area == GameManager.Areas.TABLE
	if !active: return
	
	$Label.text = str(pancakes, " pancakes")
	$Pan/Pancake.visible = has_pancake
	if has_pancake:
		ticks += delta
		$Pan.position.x = lerp(10, 170, (sin(ticks * difficulty) + 1.0) / 2.0)
	
func _unhandled_input(event: InputEvent) -> void:
	if active and has_pancake and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		has_pancake = false
		difficulty = randf_range(0.8, 3.3)
		
		var new_pancake = PANCAKE.instantiate()
		add_child(new_pancake)
		new_pancake.global_position = $Pan.global_position
		
		get_tree().create_timer(1).timeout.connect(func():
			if !has_pancake:
				pancakes += 1
				has_pancake = true)
		
