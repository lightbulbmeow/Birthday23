extends ColorRect

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var resume_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResumeButton
@onready var quit_button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		unpause() if is_visible() else pause()

func _ready():
	resume_button.pressed.connect(unpause)
	quit_button.pressed.connect(get_tree().quit)

func unpause():
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func pause():
	visible = true
	get_tree().paused = true
	animator.play("Pause")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
