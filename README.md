# WebXR VR – Hands / Locomotion / Teleport (Godot 4.3)

## Node Tree

```
Node3D  [main.gd]
└─ XROrigin3D  [player.gd]
   ├─ Head  (XRCamera3D)
   ├─ LeftController  (XRController3D, tracker=left_hand)  [teleport.gd]
   │   ├─ LeftHand   (Node3D)  [hands.gd  is_right_hand=false]
   │   ├─ TeleportRay   (RayCast3D  target=(0,0,-10)  mask=1)
   │   └─ TeleportMarker  (MeshInstance3D  CylinderMesh r=0.15 h=0.02)
   ├─ RightController  (XRController3D, tracker=right_hand)
   │   └─ RightHand  (Node3D)  [hands.gd  is_right_hand=true]
   ├─ BodyRoot  (Node3D)
   ├─ Locomotion  (Node)  [locomotion.gd]
   └─ SnapTurn   (Node)  [snap_turn.gd]
StaticBody3D  (Floor)
   ├─ MeshInstance3D  PlaneMesh 20×20
   └─ CollisionShape3D  BoxShape 20×0.1×20
Node3D  (EnvironmentObjects)
   ├─ Column1  StaticBody3D  Cylinder h=3.0 r=0.2  @ (3, 1.5, -5)
   ├─ Column2  StaticBody3D  Cylinder h=2.0 r=0.15 @ (-4, 1.0, -3)
   └─ Box1     StaticBody3D  Box 1×1×1            @ (0, 0.5, -6)
DirectionalLight3D
WorldEnvironment
CanvasLayer → Button "Enter VR"
```

## Scripts

| File | Node | Role |
|------|------|------|
| `main.gd` | Node3D (root) | WebXR session lifecycle |
| `player.gd` | XROrigin3D | Central refs + move/teleport/snap API |
| `locomotion.gd` | Node child of XROrigin3D | Left joystick → planar movement |
| `snap_turn.gd` | Node child of XROrigin3D | Right joystick → 45° snap rotate |
| `teleport.gd` | LeftController | Trigger → raycast → offset teleport |
| `hands.gd` | LeftHand / RightHand | Load FBX, fix transform, mirror R |

## Hand Model Setup

1. Copy `assets/models/PlayerHand.fbx` and `assets/textures/*` into your Godot project.
2. On first open Godot will import the FBX automatically.
3. `hands.gd` instances the scene at runtime and applies:
   - `rotation_degrees = (-90, 0, 0)` — aligns fingers to -Z
   - `position.z = 0.05` — shifts wrist to node origin
   - `scale.x = -1` on RightHand (mirror)
4. Assign `assets/hand_material.tres` to the mesh inside the imported scene, **or** let `hands.gd` fallback to a BoxMesh placeholder if the file is missing.

### If the hand appears rotated / scaled wrong
- Tweak `instance.rotation_degrees` in `hands.gd` (try `Vector3(0, 180, 0)` for Y flip).
- If model was authored in cm: set `instance.scale = Vector3(0.01, 0.01, 0.01)`.

## Export to GitHub Pages

1. **Project → Export → Add → Web**
2. Export Path: `../docs/index.html`
3. **Threads: Disabled** (required – GitHub Pages has no COOP headers)
4. Audio Worklet: Off
5. Export Project…

```bash
git add -A
git commit -m "lab03: hands, locomotion, snap turn, teleport"
git push -u origin HEAD
```

Settings → Pages → Deploy from branch → `main` → `/docs`

## Controls

| Input | Action |
|-------|--------|
| Left joystick | Smooth planar movement |
| Right joystick X | Snap turn ±45° |
| Left trigger | Teleport to aimed point |
