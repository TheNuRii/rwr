## main.gd – attach to root Node3D
## Handles WebXR session lifecycle only. All locomotion is in child scripts.
extends Node3D

var _webxr: WebXRInterface

func _ready() -> void:
	$CanvasLayer.visible = false
	$CanvasLayer/Button.pressed.connect(_on_enter_vr)

	_webxr = XRServer.find_interface("WebXR") as WebXRInterface
	if not _webxr:
		return

	_webxr.session_supported.connect(_on_session_supported)
	_webxr.session_started.connect(_on_session_started)
	_webxr.session_ended.connect(_on_session_ended)
	_webxr.session_failed.connect(_on_session_failed)

	_webxr.is_session_supported("immersive-vr")


func _on_session_supported(mode: String, supported: bool) -> void:
	if mode == "immersive-vr":
		if supported:
			$CanvasLayer.visible = true
		else:
			OS.alert("Your browser doesn't support VR")


func _on_enter_vr() -> void:
	_webxr.session_mode                    = "immersive-vr"
	_webxr.requested_reference_space_types = "bounded-floor, local-floor, local"
	_webxr.required_features               = "local-floor"
	_webxr.optional_features               = "bounded-floor"

	if not _webxr.initialize():
		OS.alert("Failed to initialize WebXR")


func _on_session_started() -> void:
	$CanvasLayer.visible = false
	get_viewport().use_xr = true
	print("Reference space type: " + _webxr.reference_space_type)


func _on_session_ended() -> void:
	$CanvasLayer.visible = true
	get_viewport().use_xr = false


func _on_session_failed(message: String) -> void:
	OS.alert("WebXR failed: " + message)
