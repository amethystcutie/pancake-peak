class_name AnimatedButton
extends Button

@export var anim_player: AnimationPlayer
@export var hover_anim: StringName
@export var unhover_anim: StringName
@export var press_anim: StringName
@export var release_anim: StringName
var hovered := false

func _ready() -> void:
	mouse_entered.connect(func(): 
		hovered = true
		if anim_player and hover_anim:
			anim_player.play(hover_anim))
	mouse_exited.connect(func(): 
		hovered = false
		if anim_player and unhover_anim:
			anim_player.play(unhover_anim))
	button_down.connect(func():
		if anim_player and press_anim:
			anim_player.play(press_anim))
	button_up.connect(func():
		if anim_player and release_anim:
			anim_player.play(release_anim))
