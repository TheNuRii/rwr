## teleport.gd – attach to XRController3D (LeftController)
## Trigger → raycast → offset-corrected teleport.
extends XRController3D

@onready var _ray:    RayCast3D      = $TeleportRay
@onready var _marker: MeshInstance3D = $TeleportMarker
@onready var _player: Node           = get_parent()   # XROrigin3D with player.gd

func _ready() -> void:
	_marker.visible = false
	button_pressed.connect(_on_button)

func _process(_delta: float) -> void:
	var hit := _ray.is_colliding()
	_marker.visible = hit
	if hit:
		_marker.global_position = _ray.get_collision_point()

func _on_button(btn: String) -> void:
	if btn == "trigger_click" or btn == "select":
		if _ray.is_colliding():
			_player.teleport_to(_ray.get_collision_point())
