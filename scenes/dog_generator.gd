tool
extends Node

var balls = [
BallData.new(29, Vector3(35, -44, 88), 0), #Right ankle      
BallData.new(14, Vector3(11, -190, -129), 1), #Left eyebrow 1   
BallData.new(21, Vector3(25, -187, -135), 2), #Left eyebrow 2   
BallData.new(21, Vector3(36, -172, -123), 3), #Left eyebrow 3   
BallData.new(16, Vector3(50, -189, -84), 4), #Left ear 1       
BallData.new(27, Vector3(34, -196, -98), 5), #Left ear 2       
BallData.new(30, Vector3(24, -188, -103), 6), #Left ear 3       
BallData.new(45, Vector3(43, -87, -40), 7), #Left elbow       
BallData.new(38, Vector3(18, -168, -142), 8), #Eye 1            
BallData.new(22, Vector3(45, -15, -57), 9), #Left finger 1    
BallData.new(24, Vector3(59, -11, -56), 10), #Left finger 2    
BallData.new(22, Vector3(65, -13, -43), 11), #Left finger 3    
BallData.new(39, Vector3(40, -19, 80), 12), #Left foot        
BallData.new(40, Vector3(47, -20, -39), 13), #Left hand        
BallData.new(20, Vector3(18, -163, -154), 14, Color.black, Color("897e66"), 3, 0, 0.0001), #Iris 1           
BallData.new(35, Vector3(12, -117, -155), 15), #Left jowl        
BallData.new(48, Vector3(40, -76, 61), 16), #Left knee        
BallData.new(25, Vector3(5, -127, -177), 17), #Left nostril     
BallData.new(61, Vector3(34, -125, -60), 18), #Left shoulder    
BallData.new(65, Vector3(24, -115, 70), 19), #Left hip         
BallData.new(22, Vector3(34, -12, 61), 20), #Left toe 1       
BallData.new(26, Vector3(48, -13, 60), 21), #Left toe 2       
BallData.new(22, Vector3(57, -13, 69), 22), #Left toe 3       
BallData.new(30, Vector3(41, -48, -34), 23), #Left wrist       
BallData.new(29, Vector3(-43, -42, 78), 24), #Left ankle       
BallData.new(14, Vector3(-14, -189, -128), 25), #Right eyebrow 1  
BallData.new(21, Vector3(-28, -185, -134), 26), #Right eyebrow 2  
BallData.new(21, Vector3(-39, -172, -123), 27), #Right eyebrow 3  
BallData.new(17, Vector3(-54, -184, -85), 28), #Right ear 1      
BallData.new(27, Vector3(-38, -196, -98), 29), #Right ear 2      
BallData.new(30, Vector3(-27, -189, -101), 30), #Right ear 3      
BallData.new(45, Vector3(-41, -83, -43), 31), #Right elbow      
BallData.new(38, Vector3(-20, -165, -143), 32), #Eye 2            
BallData.new(22, Vector3(-43, -13, -78), 33), #Right finger 1   
BallData.new(24, Vector3(-59, -11, -76), 34), #Right finger 2   
BallData.new(22, Vector3(-64, -12, -64), 35), #Right finger 3   
BallData.new(39, Vector3(-47, -19, 64), 36), #Right foot       
BallData.new(40, Vector3(-46, -18, -60), 37), #Right hand       
BallData.new(20, Vector3(-20, -160, -155), 38, Color.black, Color("897e66"), 3, 0, 0.0001), #Iris 2           
BallData.new(35, Vector3(-12, -118, -155), 39), #Right jowl       
BallData.new(49, Vector3(-43, -80, 61), 40), #Right knee       
BallData.new(25, Vector3(-6, -127, -177), 41), #Right nostril    
BallData.new(61, Vector3(-34, -122, -60), 42), #Right shoulder   
BallData.new(65, Vector3(-29, -119, 64), 43), #Right hip        
BallData.new(22, Vector3(-41, -11, 45), 44), #Right toe 1      
BallData.new(26, Vector3(-55, -12, 44), 45), #Right toe 2      
BallData.new(22, Vector3(-64, -12, 53), 46), #Right toe 3      
BallData.new(30, Vector3(-36, -43, -46), 47), #Right wrist      
BallData.new(102, Vector3(-3, -110, -2), 48), #Belly            
BallData.new(96, Vector3(0, -123, 58), 49), #Butt             
BallData.new(90, Vector3(0, -117, -53), 50), #Chest            
BallData.new(32, Vector3(-1, -105, -138), 51), #Jaw              
BallData.new(85, Vector3(-2, -155, -108), 52), #Head             
BallData.new(24, Vector3(1, -137, -105), 53), #Chin             
BallData.new(68, Vector3(-2, -140, -80), 54), #Neck             
BallData.new(24, Vector3(0, -120, -173), 55), #Nose bottom      
BallData.new(52, Vector3(-1, -132, -147), 56), #Snout            
BallData.new(25, Vector3(0, -147, 96), 57), #Tail 1           
BallData.new(21, Vector3(-1, -158, 121), 58), #Tail 2           
BallData.new(16, Vector3(-2, -174, 138), 59), #Tail 3           
BallData.new(15, Vector3(-1, -194, 142), 60), #Tail 4           
BallData.new(14, Vector3(-1, -210, 130), 61), #Tail 5           
BallData.new(14, Vector3(-1, -220, 110), 62), #Tail 6           
BallData.new(0, Vector3(7, -140, -121), 63), #Tongue 1         
BallData.new(0, Vector3(6, -122, -134), 64) #Tongue 2         
]

var lines = [
	# tongue
	LineData.new(63, 77, 100, 100), #
	LineData.new(77, 64, 100, 100), #
	LineData.new(63, 53, 100, 100), #
	#
	LineData.new(52, 54, 90, 95), #head/neck
	LineData.new(50, 54, 85, 95), #chest/neck
	LineData.new(50, 48, 95, 95), #chest/belly
	LineData.new(49, 48, 95, 95), #belly/butt
	LineData.new(49, 19, 95, 95), #butt/hip
	LineData.new(49, 43, 95, 95), #butt/hip
	LineData.new(50, 18, 95, 95), #chest/shoulder
	LineData.new(50, 42, 95, 95), #chest/shoulder
	LineData.new(1, 2, 100, 100), #brow
	LineData.new(3, 2, 100, 100), #brow
	LineData.new(25, 26, 100, 100), #brow
	LineData.new(27, 26, 100, 100), #brow
	LineData.new(10, 11, 95, 95), #BULLshit
	#toes & fingers
	LineData.new(9, 13, 100, 100), #
	LineData.new(10, 13, 90, 90), #
	LineData.new(11, 13, 100, 100), #
	LineData.new(33, 37, 100, 100), #
	LineData.new(34, 37, 90, 90), #
	LineData.new(35, 37, 100, 100), #
	LineData.new(44, 36, 100, 100), #
	LineData.new(45, 36, 90, 90), #
	LineData.new(46, 36, 100, 100), #
	LineData.new(20, 12, 100, 100), #
	LineData.new(21, 12, 90, 90), #
	LineData.new(22, 12, 100, 100), 
	#face
	LineData.new(56, 52, 100, 100), #snout, head
	LineData.new(51, 53, 85, 90), #jaw/chin
	LineData.new(56, 17, 100, 100), #
	LineData.new(56, 41, 100, 100), #
	LineData.new(39, 15, 95, 95), #
	LineData.new(56, 15, 100, 100), #
	LineData.new(56, 39, 100, 100), #
	LineData.new(56, 78, 100, 100), #
	LineData.new(56, 79, 100, 100), #
	LineData.new(53, 80, 90, 100), #
	LineData.new(53, 81, 90, 100), #
	LineData.new(80, 51, 100, 100), #
	LineData.new(81, 51, 100, 100), #
	LineData.new(51, 56, 0, 100), #
	LineData.new(15, 78, 70, 70), #
	LineData.new(39, 79, 70, 70), #
	LineData.new(78, 80, 95, 95), #
	LineData.new(79, 81, 95, 95), #
	LineData.new(78, 79, 95, 95), 
	#jowlz
	LineData.new(51, 78, 100, 100), #
	LineData.new(51, 79, 100, 100), 
	#ears
	LineData.new(6, 5, 100, 100), #
	LineData.new(5, 4, 100, 100), #
	LineData.new(30, 29, 100, 100), #
	LineData.new(29, 28, 100, 100), #
	LineData.new(4, 84, 100, 100), #
	LineData.new(28, 83, 100, 100), #
	LineData.new(52, 6, 100, 100), #
	LineData.new(52, 30, 100, 100), 
	#body
	LineData.new(57, 49, 100, 55, 2), #tail/butt
	LineData.new(57, 58, 100, 100, 2), #tail/butt
	LineData.new(58, 59, 100, 100, 2), #tail/butt
	LineData.new(59, 60, 100, 100, 2), #tail/butt
	LineData.new(60, 61, 100, 100, 2), #tail/butt
	LineData.new(61, 62, 100, 100, 2), #tail/butt
	LineData.new(7, 18, 95, 95), #LShoulder/Lelbow
	LineData.new(23, 7, 100, 80), #Lelbow/Lwrist
	LineData.new(23, 13, 80, 85), #Lwrist /Lhand
	LineData.new(42, 31, 95, 95), #RShoulder/Relbow
	LineData.new(47, 31, 100, 80), #Relbow/Rwrist
	LineData.new(47, 37, 80, 85), #Rwrist/Rhand
	LineData.new(19, 16, 95, 95), #Lthigh/Lknee
	LineData.new(16, 0, 95, 95), #Lknee/Lankle
	LineData.new(0, 12, 95, 85), #Lankle/Lfoot
	LineData.new(43, 40, 95, 95), #Rthigh/Rknee
	LineData.new(40, 24, 95, 95), #RKnee/Rankle
	LineData.new(24, 36, 95, 85), #Rankle/Rfoot
]

var ball_map = {}

export var do_something = false setget generate_pet
export var draw_balls = true

var ball_scene = preload("res://Ball.tscn")
var line_scene = preload("res://Line.tscn")

func generate_pet(_new_value):
	generate_balls()
	generate_lines()

func generate_balls():
	var root = get_tree().get_edited_scene_root()
	var parent = root.get_node("petholder/balls")
	for c in parent.get_children():
		parent.remove_child(c)
		c.queue_free()
	for ball in balls:
		var visual_ball = ball_scene.instance()
		visual_ball.ball_size = floor(ball.size / 2)
		var rotated_pos = ball.position
		rotated_pos.y *= -1.0
		visual_ball.transform.origin = rotated_pos / 1024
		if(ball.ball_no == 14 or ball.ball_no == 38):
			print(ball.position)
			print(visual_ball.transform.origin)
		visual_ball.color = ball.color
		visual_ball.outline = 1
		if ball.outline > -1:
			visual_ball.outline = ball.outline
		visual_ball.outline_color = ball.outline_color
		visual_ball.z_add = ball.z_add
		visual_ball.fuzz_amount = ball.fuzz
		parent.add_child(visual_ball)
		visual_ball.set_owner(root)
		ball_map[ball.ball_no] = visual_ball
		if !draw_balls:
			visual_ball.visible = false
		
func generate_lines():
	var root = get_tree().get_edited_scene_root()
	var parent = root.get_node("petholder/lines")
	for c in parent.get_children():
		parent.remove_child(c)
		c.queue_free()
	
	for line in lines:
		var start = ball_map.get(line.start)
		var end = ball_map.get(line.end)
		
		if start == null or end == null:
			print("Could not make a line between " + str(line.start) + " and " + str(line.end))
			continue
		
		var visual_line = line_scene.instance()
		var start_pos = start.global_transform.origin
		var target_pos = end.global_transform.origin
		var distance = (target_pos - start_pos).length()
		var middle_point = lerp(start.global_transform.origin, end.transform.origin, 0.5)
		visual_line.look_at_from_position(middle_point, target_pos, Vector3.UP)
		visual_line.rotation_degrees.x += 90
		visual_line.scale.y = distance
		visual_line.color = Color.white
		visual_line.fuzz_amount = line.fuzz
		var final_line_width = Vector2(start.ball_size * 2 + 1, end.ball_size * 2 + 1)
		final_line_width = final_line_width * (Vector2(line.s_thick, line.e_thick) / 100)
		visual_line.line_widths = final_line_width
		
		parent.add_child(visual_line)
		visual_line.set_owner(root)


func _on_showballs_toggled(button_pressed):
	for ball in get_tree().root.get_node("Spatial/petholder/balls").get_children():
		ball.visible = button_pressed

func _on_showlines_toggled(button_pressed):
	for line in get_tree().root.get_node("Spatial/petholder/lines").get_children():
		line.visible = button_pressed
