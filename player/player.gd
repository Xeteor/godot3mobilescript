extends KinematicBody

const MOUSE_SENSITIVITY = 0.1

onready var camera = $head/Camera

# Movement
var velocity = Vector3.ZERO
var current_vel = Vector3.ZERO
var dir = Vector3.ZERO

const SPEED = 10
const SPRINT_SPEED = 15
const ACCEL = 15.0

# Jump
const GRAVITY = -40.0
const JUMP_SPEED = 15
var jump_counter = 0
const AIR_ACCEL = 9.0



func _ready():
	pass



func _process(delta):
	pass



func _physics_process(delta):
	
	# Get the input directions
	dir = Vector3.ZERO
	
	if Input.is_action_pressed("forward"):
		dir -= camera.global_transform.basis.z
	if Input.is_action_pressed("backward"):
		dir += camera.global_transform.basis.z
	if Input.is_action_pressed("right"):
		dir += camera.global_transform.basis.x
	if Input.is_action_pressed("left"):
		dir -= camera.global_transform.basis.x
	
	# Normalizing the input directions
	dir = dir.normalized()
	
	# Apply gravity
	velocity.y += GRAVITY * delta
	
	if is_on_floor():
		jump_counter = 0
	
	# Jump
	if Input.is_action_just_pressed("jump") and jump_counter < 2:
		jump_counter += 1
		velocity.y = JUMP_SPEED
	
	# Set speed and target velocity
	var speed = SPRINT_SPEED if Input.is_action_pressed("Shift") else SPEED
	var target_vel = dir * speed
	
	# Smooth out the player's movement
	var accel = ACCEL if is_on_floor() else AIR_ACCEL
	current_vel = current_vel.linear_interpolate(target_vel, accel * delta)
	
	velocity.x = current_vel.x
	velocity.z = current_vel.z
	
	velocity = move_and_slide(velocity, Vector3.UP, true, 4, deg2rad(45))



func _input(event):
	#Swap between PcControl/MobileControl
	MobileControl(event)



#For Mobile Controller
func MobileControl(event):
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventScreenDrag:
		# Rotates the view vertically
		$head.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		$head.rotation_degrees.x = clamp($head.rotation_degrees.x, -75, 75)
		
		# Rotates the view horizontally
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

#For Pc Controller
func PcControl(event):
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseMotion:
		# Rotates the view vertically
		$head.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		$head.rotation_degrees.x = clamp($head.rotation_degrees.x, -75, 75)
		
		# Rotates the view horizontally
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
