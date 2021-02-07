tool
extends Node

var balls = [
	BallData.new(37, Vector3(0, 0, 0)), # butt
	BallData.new(39, Vector3(17, -4, 0)), # belly
	BallData.new(35, Vector3(33, -1, 0)), # chest
	BallData.new(25, Vector3(-4, -3, 12)), # Rhip
	BallData.new(25, Vector3(-4, -3, -12)), # Lhip
	BallData.new(19, Vector3(-3, -16, 12)), # Rknee
	BallData.new(19, Vector3(-3, -16, -12)), # Lknee
	BallData.new(11, Vector3(-6, -27, 12)), # Rankle
	BallData.new(11, Vector3(-6, -27, -12)), # Lankle
	BallData.new(15, Vector3(-4, -34, 12)), # Rfoot
	BallData.new(15, Vector3(-4, -34, -12)), # Lfoot
	BallData.new(7, Vector3(1, -35, 7)), # Rtoe1
	BallData.new(7, Vector3(0, -37, 11)), # Rtoe2
	BallData.new(7, Vector3(1, -35, 17)), # Rtoe3
	BallData.new(7, Vector3(1, -35, -7)), # Ltoe1
	BallData.new(7, Vector3(0, -37, -11)), # Ltoe2
	BallData.new(7, Vector3(1, -35, -17)), # Ltoe3
	BallData.new(23, Vector3(35, -1, 12)), # Rshoulder
	BallData.new(23, Vector3(35, -1, -12)), # Lshoulder
	BallData.new(17, Vector3(29, -13, 12)), # Relbow
	BallData.new(17, Vector3(29, -13, -12)), # Lelbow
	BallData.new(11, Vector3(31, -25, 12)), # Rwrist
	BallData.new(11, Vector3(31, -25, -12)), # Lwrist
	BallData.new(15, Vector3(35, -33, 12)), # Rhand
	BallData.new(15, Vector3(35, -33, -12)), # Lhand
	BallData.new(7, Vector3(36, -33, 7)), # Rfinger1
	BallData.new(7, Vector3(40, -35, 12)), # Rfinger2
	BallData.new(7, Vector3(36, -33, 17)), # Rfinger3
	BallData.new(7, Vector3(36, -33, -7)), # Lfinger1
	BallData.new(7, Vector3(40, -35, -12)), # Lfinger2
	BallData.new(7, Vector3(36, -33, -17)), # Lfinger3
	BallData.new(32, Vector3(50, 12, 0)), # Head
	BallData.new(17, Vector3(48, 2, 10)), # Rcheek
	BallData.new(17, Vector3(48, 2, -10)), # Lcheek
	BallData.new(13, Vector3(62, -1, 5)), # Rjowl
	BallData.new(13, Vector3(62, -1, -5)), # Ljowl
	BallData.new(15, Vector3(65, 13, -7), Color.white, Color.black, 1), # Eye1
	BallData.new(15, Vector3(65, 13, 7), Color.white, Color.black, 1), # Eye2
	BallData.new(7, Vector3(67, 13, -8), Color.black, Color("3232ac"), 2), # Iris1
	BallData.new(7, Vector3(67, 13, 8), Color.black, Color("3232ac"), 2), # Iris2
	BallData.new(21, Vector3(63, 5, 0)), # Snout
	BallData.new(10, Vector3(57, -7, 0)), # Chin
	BallData.new(9, Vector3(-13, 7, 0)), # Tail1
	BallData.new(9, Vector3(-20, 10, 0)), # Tail2
	BallData.new(7, Vector3(-26, 16, 0)), # Tail3
	BallData.new(7, Vector3(-27, 23, 0)), # Tail4
	BallData.new(5, Vector3(-23, 29, 0)), # Tail5
	BallData.new(5, Vector3(-16, 32, 0)), # Tail6
	BallData.new(10, Vector3(73, 5, 3), Color.black), # Rnose
	BallData.new(10, Vector3(73, 5, -3), Color.black), # Lnose
	BallData.new(10, Vector3(71, 1, 0), Color.black), # NoseBottom
	BallData.new(7, Vector3(53, 15, 13)), # reyebrow1
	BallData.new(9, Vector3(55, 19, 11)), # reyebrow2
	BallData.new(5, Vector3(53, 21, 7)), # reyebrow3
	BallData.new(7, Vector3(53, 15, -13)), # leyebrow1
	BallData.new(9, Vector3(55, 19, -11)), # leyebrow2
	BallData.new(5, Vector3(53, 21, -7)), # leyebrow3
	BallData.new(11, Vector3(47, 21, 13)), # rear1
	BallData.new(7, Vector3(43, 17, 17)), # rear2
	BallData.new(11, Vector3(47, 21, -13)), # lear1
	BallData.new(7, Vector3(43, 17, -17)), # lear2
]

export var do_something = false setget generate_balls

var ball_scene = preload("res://Ball.tscn")

func generate_balls(_new_value):
	var root = get_tree().get_edited_scene_root()
	var parent = root.get_node("petholder/balls")
	for c in parent.get_children():
		parent.remove_child(c)
		c.queue_free()
	for ball in balls:
		var visual_ball = ball_scene.instance()
		visual_ball.ball_size = ball.size / 2
		visual_ball.transform.origin = ball.position / 1024
		visual_ball.color = ball.color
		visual_ball.outline = ball.outline
		visual_ball.outline_color = ball.outline_color
		parent.add_child(visual_ball)
		visual_ball.set_owner(root)
