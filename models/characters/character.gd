extends Node3D

#var animationPlayer: AnimationPlayer

enum Character {
	NANAHIRA,
	MESSENGER,
}

const VELOCITY_SCALE = 2.0

var last_velocity = Vector3.ZERO

@export var character: Character = Character.NANAHIRA

func _ready():
	var scene = null
	var respath = null
	
	$Armature/Skeleton3D/NanahiraPapercraft.visible = false
	
	match(character):
		Character.NANAHIRA:
			$Armature/Skeleton3D/NanahiraPapercraft.visible = true
		Character.MESSENGER:
			scene = preload("res://models/characters/messenger/messenger_papercraft.tscn")
			respath = "Armature/Skeleton3D/MessengerPapercraft"
		_:
			push_warning("Specified character not in enum, can't load!")
	
	if scene and respath:
		var instance = scene.instantiate()
		instance.get_node(respath).reparent($Armature/Skeleton3D, false)

func _process(delta):
	pass

func set_flight(flying: bool):
	if flying:
		$AnimationTree["parameters/playback"].travel("Fly")
	else:
		set_velocity(last_velocity)

func set_velocity(velocity: Vector3):
	last_velocity = velocity
	var v = Vector3(velocity.x, 0, velocity.z).length() * VELOCITY_SCALE
	if v > 0.01:
		var speed = clamp(0.75, 4, v)
		var blend = clamp(0.2, 1, v)
		$AnimationTree["parameters/playback"].travel("Walk")
		$AnimationTree.set("parameters/Walk/Blend2/blend_amount", blend);
		$AnimationTree["parameters/Walk/TimeScale/scale"] = speed
	else:
		$AnimationTree["parameters/playback"].travel("Idle")
		$AnimationTree["parameters/Walk/TimeScale/scale"] = 1.0
