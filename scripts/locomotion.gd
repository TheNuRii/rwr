## locomotion.gd – attach to XROrigin3D (Player)
## Reads left joystick → planar movement via player.move().
extends Node

@export var move_speed: float = 2.5   # m/s
@export var deadzone:   float = 0.20

@onready var _player: Node = get_parent()   # XROrigin3D with player.gd

func _physics_process(delta: float) -> void:
	var ctrl: XRController3D = _player.left_controller
	var v: Vector2 = ctrl.get_vector2("thumbstick")

	if v.length() < deadzone:
		return

	var cam_basis: Basis = _player.head.global_transform.basis

	var fwd: Vector3 = -cam_basis.z
	fwd.y = 0.0
	fwd = fwd.normalized()

	var right: Vector3 = cam_basis.x
	right.y = 0.0
	right = right.normalized()

	var dir: Vector3 = fwd * (-v.y) + right * v.x
	if dir.length_squared() < 0.001:
		return

	_player.move(dir.normalized() * move_speed * delta)
