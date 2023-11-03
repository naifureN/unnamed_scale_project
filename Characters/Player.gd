extends CharacterBody2D

@export var speed : float = 500.0
var jump_vel : float = -350.0
var direction : int = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
enum {SMALL, NORMAL, BIG}
enum {SQUARE, RECT}
var size = NORMAL
var size_change_time = 0.65
var form = SQUARE

	
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
	
	if Input.is_action_just_pressed("change_form"):
		change_rectangle_square()
	if Input.is_action_just_pressed("rotate_right"):
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation_degrees", self.rotation_degrees + 90, size_change_time)
	if Input.is_action_just_pressed("rotate_left"):
		var tween = get_tree().create_tween()
		tween.tween_property(self, "rotation_degrees", self.rotation_degrees - 90, size_change_time)
	
	move_and_slide()
	
func change_rectangle_square():
	if form == SQUARE:
		form = RECT
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(self, "scale", Vector2(scale.x*3,scale.y), size_change_time)
	elif form == RECT:
		form = SQUARE
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property(self, "scale", Vector2(scale.x/3,scale.y), size_change_time)
		
func make_bigger():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
	if size == NORMAL:
		size = BIG
		tween.tween_property(self, "scale", Vector2(scale.x*3,scale.y*3), size_change_time)
	elif size == SMALL:
		size = NORMAL
		tween.tween_property(self, "scale", Vector2(scale.x*3,scale.y*3), size_change_time)

func make_smaller():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
	if size == BIG:
		size = NORMAL
		tween.tween_property(self, "scale", Vector2(scale.x/3,scale.y/3), size_change_time)
	elif size == NORMAL:
		size = SMALL
		tween.tween_property(self, "scale", Vector2(scale.x/3,scale.y/3), size_change_time)
