## hands.gd – attach to Node3D (LeftHand) OR Node3D (RightHand)
## Instances the provided PlayerHand.fbx, aligns fingers to -Z, wrist at pivot.
##
## Export `is_right_hand = true` on the RightHand node to mirror the mesh.
extends Node3D

@export var is_right_hand: bool = false

## Path to the imported FBX/GLB hand scene resource.
const HAND_SCENE := "res://assets/models/PlayerHand.fbx"

func _ready() -> void:
	var res: PackedScene = load(HAND_SCENE)
	if res == null:
		push_warning("hands.gd: cannot load " + HAND_SCENE)
		_use_placeholder()
		return

	var instance: Node3D = res.instantiate()
	add_child(instance)

	# ── Transform corrections ─────────────────────────────────────────────────
	# FBX from Blender: Y-up, fingers along +Y in rest pose → rotate -90° X
	# so fingers point toward -Z (Godot forward).
	# Wrist pivot: offset along local +Z to place wrist at node origin.
	instance.rotation_degrees = Vector3(-90.0, 0.0, 0.0)
	instance.position         = Vector3(0.0, 0.0, 0.05)   # ~wrist offset
	instance.scale            = Vector3.ONE                # FBX in metres → 1:1

	# Mirror right hand by flipping X axis.
	if is_right_hand:
		instance.scale.x = -1.0

	# Ensure correct scale from GLB/FBX import (if authored in cm, set to 0.01).
	# Adjust HAND_IMPORT_SCALE in the .import file or via importer if needed.


## Fallback box-mesh placeholder when model file is missing.
func _use_placeholder() -> void:
	var mi  := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(0.08, 0.025, 0.12)   # width × thickness × length
	mi.mesh  = box
	# Offset so the "wrist" end sits at node origin.
	mi.position = Vector3(0.0, 0.0, -0.06)
	if is_right_hand:
		mi.scale.x = -1.0
	add_child(mi)
