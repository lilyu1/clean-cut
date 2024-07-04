extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play("walk")
	set_deferred("contact_monitor",true)
	if linear_velocity != Vector2.ZERO: # Avoid errors when velocity is zero
		rotation = linear_velocity.angle()
	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body): #bullet entering body or when mobs hit each other
	print("hey!")
	#animated sprite plays dead
	$AnimatedSprite2D.play("dead")
	#position stays in prev position
	linear_velocity = Vector2.ZERO
	#disable collision shape
	#$CollisionShape2D.set_deferred("disabled", true)
	#disable collision 1 so it doesnt take out player 
	body.set_collision_mask_value(1, false)
	#bullets go past it
	body.set_collision_layer_value(2, false)
	#move collision shape to three to dead mob layer
	body.set_collision_layer_value(3,true)
	body.set_collision_mask_value(3, true)
	
