extends CharacterBody2D

@export var speed : float = 200.0
var jump_vel : float = -250.0
var direction : int = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_vel

	var input_direction = Input.get_axis("left", "right")
	
	if input_direction > 0:
		direction = 1
	elif input_direction < 0:
		direction = -1
		
	if input_direction:
		velocity.x = input_direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide()
