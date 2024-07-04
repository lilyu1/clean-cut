extends Area2D

var speed = 750

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	position += transform.x * speed * delta
	#moves in one direction, translating by x determined by muzzle vector

func _on_body_entered(body):
	print("yo")
	if body.is_in_group("mobs"):
		#body.queue_free() #removes mobs
		body._on_body_entered(body)
	queue_free() #removes bullet
