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
			has_pancake = true)
	
	GameManager.switched_to.connect(func(area: GameManager.Areas):
		if area == GameManager.Areas.TABLE:
			active = true
			set_process(true)
		else:
			pancakes = 0
			$Pancakes.get_children().map(func(c): c.queue_free())
			active = false
			set_process(false)
	)

func _process(delta: float) -> void: 
	if !active: return
	
	pancakes = $Stack.get_overlapping_bodies().filter(func(b): return b is FallingPancake).size()
	
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
		$Pancakes.add_child(new_pancake)
		new_pancake.global_position = $Pan.global_position
		
		get_tree().create_timer(1).timeout.connect(func(): has_pancake = true)
		
