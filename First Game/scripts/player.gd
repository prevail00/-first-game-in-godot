extends CharacterBody2D


const SPEED = 110.0
const JUMP_VELOCITY = -250.0
var jump_count = 0
var max_jump_count = 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	#Play animation
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")

	# Handle double jump
	if jump_count > 0 and is_on_floor(): #Resets double jump on landing
		jump_count = 0
		print("Jump count reset")
	if Input.is_action_just_pressed("jump") and jump_count < max_jump_count:
		velocity.y = JUMP_VELOCITY
		jump_count += 1
		animation_player.play("jump")
		if jump_count == 1:
			animated_sprite.play("jump")
			print(jump_count)
		elif jump_count > 1:
			animated_sprite.play("double_jump")
			print(jump_count)
	

	
	#Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	#Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
