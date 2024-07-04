extends Area2D
signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

@export var Bullet : PackedScene

var can_clean = true
var mob #stores raycast collision
var mob_in_cleanup_zone = false


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_clean:
		var velocity = Vector2.ZERO # The player's movement vector.
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
	
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.flip_h = velocity.x < 0
			if velocity.x != 0:
			#change x of cleanup zone. need condition else if not moving, vel = 0
				$cleanup_zone/CollisionShape2D.position.x = sign(velocity.x) * $cleanup_zone/CollisionShape2D.position.x 
				
		else:
			$AnimatedSprite2D.stop()
			
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size)
	
		if Input.is_action_just_pressed("shoot"):
			shoot()
		
	if Input.is_action_just_pressed("clean") and mob_in_cleanup_zone: #intial  clean
		if can_clean:
			can_clean = false #currently cleaning
			$clean_cooldown.start()
			print("clean start")
			
	if not can_clean: #ongoing cleaning
		$AnimatedSprite2D.play("clean")
		print("cleaning")
		

func _on_body_entered(body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func shoot():
	var b = Bullet.instantiate()
	var mouse = get_local_mouse_position().normalized()
	owner.add_child(b)
	$Muzzle.rotation = mouse.angle()
	b.transform = $Muzzle.global_transform
	

func _on_clean_cooldown_timeout():
	if mob == null: 
		print("nothing to clean")
		can_clean = true
	else:
		mob.queue_free()
		mob = null
		can_clean = true
		#increment score in main
		get_parent().update_clean_score()
		print("clean end")
	

func _on_cleanup_zone_body_entered(body):
	mob_in_cleanup_zone = true
	print('ah!')
	mob = body
