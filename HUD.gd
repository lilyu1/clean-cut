extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_clean_score(clean_score):
	$scoreClean.text = str(clean_score)
	
func update_cut_score(cut_score):
	$scoreCut.text = str(cut_score)
