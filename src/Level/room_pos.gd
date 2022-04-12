extends RigidBody2D

var size
var offset = Vector2.ZERO
func make_room(pos,sz):
	var size = sz
	var s = RectangleShape2D.new()
	s.custom_solver_bias = 0.75
	s.extents = size
	$CollisionShape2D.shape = s
