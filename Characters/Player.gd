extends CharacterBody2D

@export var speed : float = 500.0
var jump_vel : float = -350.0
var direction : int = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
enum {SMALL, NORMAL, BIG}
var size = NORMAL
var size_change_time = 0.75

	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_vel

	if Input.is_action_just_pressed("smaller") and size != SMALL:
		make_smaller()
	if Input.is_action_just_pressed("bigger") and size != BIG:
		make_bigger()

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

func make_bigger():
	var tween = get_tree().create_tween()
	if size == NORMAL:
		size = BIG
		tween.tween_property(self, "scale", Vector2(2,2), size_change_time)
	elif size == SMALL:
		size = NORMAL
		tween.tween_property(self, "scale", Vector2(1,1), size_change_time)

func make_smaller():
	var tween = get_tree().create_tween()
	if size == BIG:
		size = NORMAL
		tween.tween_property(self, "scale", Vector2(1,1), size_change_time)
	elif size == NORMAL:
		size = SMALL
		tween.tween_property(self, "scale", Vector2(0.5,0.5), size_change_time)
