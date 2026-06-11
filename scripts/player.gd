## player.gd – attach to XROrigin3D (Player)
## Central hub: exposes refs and movement API consumed by child scripts.
extends XROrigin3D

# ── Public refs ───────────────────────────────────────────────────────────────
@onready var head:            XRCamera3D    = $Head
@onready var left_controller: XRController3D = $LeftController
@onready var right_controller: XRController3D = $RightController
@onready var body_root:       Node3D        = $BodyRoot

# ── Movement API ──────────────────────────────────────────────────────────────

## Move XROrigin3D by a planar delta (Y is ignored / enforced externally).
func move(delta_xz: Vector3) -> void:
	var d := delta_xz
	d.y = 0.0
	global_translate(d)


## Teleport: place origin so head lands at world_target.
func teleport_to(world_target: Vector3) -> void:
	var offset := Vector3(
		head.global_position.x - global_position.x,
		0.0,
		head.global_position.z - global_position.z
	)
	global_position = Vector3(
		world_target.x - offset.x,
		world_target.y,          # floor height from raycast hit
		world_target.z - offset.z
	)


## Snap-rotate origin around the head position by angle_deg on Y axis.
func snap_rotate(angle_deg: float) -> void:
	var cam_pos := head.global_transform.origin
	global_translate(-cam_pos)
	var rot := Transform3D(Basis(Vector3.UP, deg_to_rad(angle_deg)), Vector3.ZERO)
	global_transform = rot * global_transform
	global_translate(cam_pos)
