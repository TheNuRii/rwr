## snap_turn.gd – attach to XROrigin3D (Player)
## Right joystick X → 45° instant snap rotation with debounce.
extends Node

@export var snap_angle:    float = 45.0
@export var threshold:     float = 0.70

var _ready_to_snap: bool = true

@onready var _player: Node = get_parent()

func _physics_process(_delta: float) -> void:
	var ctrl: XRController3D = _player.right_controller
	var v: Vector2 = ctrl.get_vector2("thumbstick")

	if abs(v.x) < threshold:
		_ready_to_snap = true   # stick returned to centre → unlock
		return

	if not _ready_to_snap:
		return

	_ready_to_snap = false
	# positive v.x = right → rotate right = negative Y angle
	_player.snap_rotate(-snap_angle * sign(v.x))
