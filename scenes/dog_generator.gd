tool
extends Node

export var pixel_world_size = 0.001;

export var do_stuff = true setget do_it

var balls = []

var lines = []

var ball_map = {}

var legs_dog = [
	[0, 12, 16, 20, 21, 22, 24, 36, 44, 45, 46], # back legs
	[7, 9, 10, 11, 13, 31, 33, 34, 35, 37] # front legs 
]
var legs_cat = [ 
	[0, 1, 32, 33, 41, 42, 49, 50, 51, 52, 53, 54], # back
	[12, 13, 16, 17, 18, 22, 23, 34, 35, 63, 64] # front
]
var body_ext_dog = [ 49, 0, 12, 16, 20, 21, 22, 24, 36, 44, 45, 46, 43, 19, 40, 57, 58, 59, 60, 61, 62 ]
var body_ext_cat = [ 2, 3, 0, 1, 32, 33, 41, 42, 49, 50, 51, 52, 53, 54, 25, 26, 43, 44, 45, 46, 47, 48 ]
var face_ext_dog = [ 51, 53, 55, 56, 63, 64, 17, 41, 15, 39 ]
var face_ext_cat = [ 7, 30, 31, 37, 40, 57, 58, 59, 60, 61, 62, 29 ]
var head_ext_dog = [ 52, 1, 2, 3, 4, 5, 6, 8, 14, 15, 17, 25, 26, 27, 28, 29, 30, 32, 38, 39, 41, 51, 53, 55, 56, 63, 64 ]
var head_ext_cat = [ 24, 4, 5, 7, 8, 9, 10, 11, 14, 15, 29, 30, 31, 37, 40, 57, 58, 59, 60, 61, 62 ]
var foot_ext_dog = [ 
	[ 12, 20, 21, 22 ],
	[ 13, 9, 10, 11 ],
	[ 36, 44, 45, 46 ],
	[ 37, 33, 34, 35 ]
]
var foot_ext_cat = [
	[ 22, 16, 17, 18 ],
	[ 23, 19, 20, 21 ],
	[ 41, 49, 50, 51 ],
	[ 42, 52, 53, 54 ]
]
var ear_ext_dog = [ 5, 6, 29, 30 ]
var ear_ext_cat = [ 8, 9, 10, 11  ]
var eyes_dog = {14: 8, 38: 32} # iris = eye
var eyes_cat = { 27: 14, 28: 15}

export var draw_balls = true
export var draw_addballs = true

var ball_scene = preload("res://Ball.tscn")
var paintball_scene = preload("res://Paintball.tscn")
var line_scene = preload("res://Line.tscn")

func do_it(new_value):
	generate_pet("sheepdog.lnz")

func init_ball_data(species: int):
	if species == 2:
		balls = [
			BallData.new(29, Vector3(35, -44, 88), 0), #Right ankle      
			BallData.new(14, Vector3(11, -190, -129), 1), #Left eyebrow 1   
			BallData.new(21, Vector3(25, -187, -135), 2), #Left eyebrow 2   
			BallData.new(21, Vector3(36, -172, -123), 3), #Left eyebrow 3   
			BallData.new(16, Vector3(50, -189, -84), 4), #Left ear 1       
			BallData.new(27, Vector3(34, -196, -98), 5), #Left ear 2       
			BallData.new(30, Vector3(24, -188, -103), 6), #Left ear 3       
			BallData.new(45, Vector3(43, -87, -40), 7), #Left elbow       
			BallData.new(38, Vector3(18, -168, -142), 8, Color.white, Color.black, 1, 0, 0.00005), #Eye 1            
			BallData.new(22, Vector3(45, -15, -57), 9), #Left finger 1    
			BallData.new(24, Vector3(59, -11, -56), 10), #Left finger 2    
			BallData.new(22, Vector3(65, -13, -43), 11), #Left finger 3    
			BallData.new(39, Vector3(40, -19, 80), 12), #Left foot        
			BallData.new(40, Vector3(47, -20, -39), 13), #Left hand        
			BallData.new(20, Vector3(18, -163, -154), 14, Color.black, Color("897e66"), 3, 0, 0.0002), #Iris 1           
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
			BallData.new(38, Vector3(-20, -165, -143), 32, Color.white, Color.black, 1, 0, 0.00005), #Eye 2            
			BallData.new(22, Vector3(-43, -13, -78), 33), #Right finger 1   
			BallData.new(24, Vector3(-59, -11, -76), 34), #Right finger 2   
			BallData.new(22, Vector3(-64, -12, -64), 35), #Right finger 3   
			BallData.new(39, Vector3(-47, -19, 64), 36), #Right foot       
			BallData.new(40, Vector3(-46, -18, -60), 37), #Right hand       
			BallData.new(20, Vector3(-20, -160, -155), 38, Color.black, Color("897e66"), 3, 0, 0.0002), #Iris 2           
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
	else:
		balls = [
			BallData.new(31, Vector3(46, -57, 74), 0),            #eBall_ankleL,
			BallData.new(31, Vector3(-49, -56, 65), 1),            #eBall_ankleR,
			BallData.new(91, Vector3(0, -109, 0), 2),            #eBall_belly,
			BallData.new(102, Vector3(0, -112, 65), 3),            #eBall_butt,
			BallData.new(67, Vector3(26, -148, -142), 4),            #eBall_cheekL,
			BallData.new(67, Vector3(-26, -148, -142), 5),            #eBall_cheekR,
			BallData.new(77, Vector3(0, -101, -62), 6),            #eBall_chest,
			BallData.new(31, Vector3(0, -137, -177), 7),            #eBall_chin,
			BallData.new(65, Vector3(20, -184, -109), 8),            #eBall_earL1,
			BallData.new(1, Vector3(60, -232, -90), 9),            #eBall_earL2,
			BallData.new(66, Vector3(-20, -184, -109), 10),            #eBall_earR1,
			BallData.new(1, Vector3(-60, -232, -90), 11),            #eBall_earR2,
			BallData.new(40, Vector3(30, -80, -20), 12),            #eBall_elbowL,
			BallData.new(40, Vector3(-45, -71, -27), 13),            #eBall_elbowR,
			BallData.new(38, Vector3(18, -177, -159), 14, Color.white, Color.black, 1, 0, 0.00005),            #eBall_eyeL,
			BallData.new(38, Vector3(-19, -177, -159), 15, Color.white, Color.black, 1, 0, 0.00005),            #eBall_eyeR,
			BallData.new(22, Vector3(22, -10, -69), 16),            #eBall_fingerL1,
			BallData.new(22, Vector3(30, -10, -74), 17),            #eBall_fingerL2,
			BallData.new(22, Vector3(37, -10, -68), 18),            #eBall_fingerL3,
			BallData.new(22, Vector3(-22, -10, -89), 19),            #eBall_fingerR1,
			BallData.new(22, Vector3(-29, -10, -95), 20),            #eBall_fingerR2,
			BallData.new(22, Vector3(-37, -10, -90), 21),            #eBall_fingerR3,
			BallData.new(31, Vector3(30, -14, -55), 22),            #eBall_handL,
			BallData.new(31, Vector3(-29, -14, -76), 23),            #eBall_handR,
			BallData.new(105, Vector3(0, -165, -125), 24),            #eBall_head,
			BallData.new(81, Vector3(32, -110, 69), 25),            #eBall_hipL,
			BallData.new(81, Vector3(-33, -110, 69), 26),            #eBall_hipR,
			BallData.new(16, Vector3(18, -177, -171), 27),            #eBall_irisL,
			BallData.new(16, Vector3(-19, -177, -171), 28),            #eBall_irisR,
			BallData.new(21, Vector3(0, -140, -151), 29),            #eBall_jaw,
			BallData.new(35, Vector3(14, -154, -182), 30),            #eBall_jowlL,
			BallData.new(35, Vector3(-15, -154, -182), 31),            #eBall_jowlR,
			BallData.new(53, Vector3(43, -86, 34), 32),            #eBall_kneeL,
			BallData.new(53, Vector3(-44, -91, 30), 33),            #eBall_kneeR,
			BallData.new(31, Vector3(50, -14, 57), 34),            #eBall_knuckleL,
			BallData.new(31, Vector3(-54, -14, 41), 35),            #eBall_knuckleR,
			BallData.new(45, Vector3(0, -131, -91), 36),            #eBall_neck,
			BallData.new(27, Vector3(0, -162, -187), 37),            #eBall_nose,
			BallData.new(51, Vector3(27, -98, -67), 38),            #eBall_shoulderL,
			BallData.new(51, Vector3(-28, -98, -66), 39),            #eBall_shoulderR,
			BallData.new(42, Vector3(0, -161, -168), 40),            #eBall_snout,
			BallData.new(34, Vector3(50, -16, 69), 41),            #eBall_soleL,
			BallData.new(34, Vector3(-54, -17, 53), 42),            #eBall_soleR,
			BallData.new(30, Vector3(0, -140, 105), 43),            #eBall_tail1,
			BallData.new(30, Vector3(0, -164, 123), 44),            #eBall_tail2,
			BallData.new(29, Vector3(0, -193, 133), 45),            #eBall_tail3,
			BallData.new(27, Vector3(0, -222, 125), 46),            #eBall_tail4,
			BallData.new(26, Vector3(0, -244, 104), 47),            #eBall_tail5,
			BallData.new(22, Vector3(0, -256, 77), 48),            #eBall_tail6,
			BallData.new(22, Vector3(42, -10, 43), 49),            #eBall_toeL1,
			BallData.new(22, Vector3(50, -10, 38), 50),            #eBall_toeL2,
			BallData.new(22, Vector3(57, -10, 44), 51),            #eBall_toeL3,
			BallData.new(22, Vector3(-47, -11, 28), 52),            #eBall_toeR1,
			BallData.new(22, Vector3(-54, -11, 22), 53),            #eBall_toeR2,
			BallData.new(22, Vector3(-62, -11, 27), 54),            #eBall_toeR3,
			BallData.new(0, Vector3(0, -147, -158), 55),            #eBall_tongue1,
			BallData.new(0, Vector3(0, -146, -168), 56),            #eBall_tongue2,
			BallData.new(10, Vector3(61, -167, -179), 57),            #eBall_whiskerL1,
			BallData.new(10, Vector3(66, -145, -183), 58),            #eBall_whiskerL2,
			BallData.new(10, Vector3(54, -128, -175), 59),            #eBall_whiskerL3,
			BallData.new(10, Vector3(-63, -166, -179), 60),            #eBall_whiskerR1,
			BallData.new(10, Vector3(-69, -144, -183), 61),            #eBall_whiskerR2,
			BallData.new(10, Vector3(-54, -128, -175), 62),            #eBall_whiskerR3,
			BallData.new(34, Vector3(30, -16, -43), 63),            #eBall_wristL,
			BallData.new(34, Vector3(-29, -16, -64), 64),            #eBall_wristR,
			BallData.new(41, Vector3(0, -20, -308), 65),            #eBall_zorient,
			BallData.new(70, Vector3(0, -34, -263), 66)            #eBall_ztrans,
		]

func generate_pet(file_name):
	var lnz_info = LnzParser.new(file_name)
	init_ball_data(lnz_info.species)
	var collated_data = collate_base_ball_data()
	collated_data = {balls = collated_data, addballs = lnz_info.addballs, paintballs = lnz_info.paintballs}
	collated_data = apply_extensions(collated_data, lnz_info)
	collated_data = munge_balls(collated_data, lnz_info)
	collated_data = apply_projections(collated_data, lnz_info)
	collated_data = apply_sizes(collated_data, lnz_info)
	collated_data.omissions = lnz_info.omissions
	generate_balls(collated_data, lnz_info.species, lnz_info.texture_list)
	generate_lines(lnz_info.lines)

func collate_base_ball_data():
	var ball_data_map = {}
	for ball in balls:
		ball_data_map[ball.ball_no] = ball
	return ball_data_map
	
func apply_extensions(all_ball_dict: Dictionary, lnz: LnzParser):
	var base_ball_dict = all_ball_dict.balls
	var addball_dict = all_ball_dict.addballs
	var addballs_by_base = {}
	for ab in addball_dict.values():
		var ar = addballs_by_base.get(ab.base, [])
		ar.append(ab)
		addballs_by_base[ab.base] = ar
		
	var legs
	var body_ext
	var face_ext
	var head_ext
	var foot_ext
	var ear_ext
	if lnz.species == 2:
		legs = self.legs_dog
		body_ext = self.body_ext_dog
		face_ext = self.face_ext_dog
		head_ext = self.head_ext_dog
		foot_ext = self.foot_ext_dog
		ear_ext = self.ear_ext_dog
	else:
		legs = self.legs_cat
		body_ext = self.body_ext_cat
		face_ext = self.face_ext_cat
		head_ext = self.head_ext_cat
		foot_ext = self.foot_ext_cat
		ear_ext = self.ear_ext_cat
		
	# legs
	for ball_no in legs[0]:
		var ball = base_ball_dict[ball_no]
		var addballs = addballs_by_base.get(ball_no, [])
		ball.position.y += lnz.leg_extensions.x
		for n in addballs:
			n.position.y += lnz.leg_extensions.x
	for ball_no in legs[1]:
		var ball = base_ball_dict[ball_no]
		var addballs = addballs_by_base.get(ball_no, [])
		ball.position.y += lnz.leg_extensions.y
		for n in addballs:
			n.position.y += lnz.leg_extensions.y
		
	# body
	var special_ball = body_ext[0]
	for ball_no in body_ext:
		if ball_no == special_ball:
			continue
		var ball = base_ball_dict[ball_no]
		ball.position.z += lnz.body_extension * 2
	base_ball_dict[special_ball].position.z += lnz.body_extension
	
	# face
	for ball_no in face_ext:
		var ball = base_ball_dict[ball_no]
		ball.position.z -= lnz.face_extension
	
	# head enlargement
	var head_ball_key = head_ext[0]
	var head_pos = base_ball_dict[head_ball_key].position
	for ball_no in head_ext:
		var ball = base_ball_dict[ball_no]
		var addballs = addballs_by_base.get(ball_no, [])
		if ball_no != head_ball_key:
			var mod_v = ball.position - head_pos
			mod_v = mod_v * (lnz.head_enlargement.x / 100.0)
			mod_v += head_pos
			ball.position = Vector3(floor(mod_v.x), floor(mod_v.y), floor(mod_v.z))
			for n in addballs:
				mod_v = n.position
				mod_v = mod_v * (lnz.head_enlargement.x / 100.0)
				n.position = Vector3(floor(mod_v.x), floor(mod_v.y), floor(mod_v.z))
				addball_dict[n.ball_no] = n
		ball.size = floor(ball.size * (lnz.head_enlargement.x / 100.0))
		ball.size += lnz.head_enlargement.y
		for n in addballs:
			n.size = floor(n.size * (lnz.head_enlargement.x / 100.0))
			n.size += lnz.head_enlargement.y
			addball_dict[n.ball_no] = n
		
		
	# feet
	for foot_group in foot_ext:
		var foot_pos = base_ball_dict[foot_group[0]].position
		for ball_no in foot_group:
			var ball = base_ball_dict[ball_no]
			if ball_no != foot_group[0]:
				var mod_v = ball.position - foot_pos
				mod_v = mod_v * (lnz.foot_enlargement.x / 100.0)
				mod_v += foot_pos
				ball.position = Vector3(floor(ball.position.x), floor(ball.position.y), floor(ball.position.z))
			ball.size = floor(ball.size * (lnz.foot_enlargement.x / 100.0))
			ball.size += lnz.foot_enlargement.y
			
	# ears
	for ball_no in ear_ext:
		var ball = base_ball_dict[ball_no]
		ball.position *= (lnz.ear_extension / 100.0)
		for addball in addballs_by_base.get(ball_no, []):
			addball.position *= (lnz.ear_extension / 100.0)
	
	return {balls = base_ball_dict, addballs = addball_dict, paintballs = all_ball_dict.paintballs}
	
func munge_balls(all_ball_dict: Dictionary, lnz: LnzParser):
	var base_ball_dict = all_ball_dict.balls
	var lnz_balls = lnz.balls
	for k in base_ball_dict:
		var v: BallData = lnz_balls.get(k)
		var b: BallData = base_ball_dict.get(k)
		if b == null or v == null:
			continue
		b.size += v.size
		b.color = v.color
		b.outline_color = v.outline_color
		b.outline = v.outline
		b.fuzz = v.fuzz
		b.position += v.position
		b.texture_id = v.texture_id
		b.color_index = v.color_index
		base_ball_dict[k] = b
	
	return {balls = base_ball_dict, addballs = all_ball_dict.addballs, paintballs = all_ball_dict.paintballs}

func apply_projections(all_ball_dict: Dictionary, lnz: LnzParser):
	var base_ball_dict = all_ball_dict.balls
	var addball_dict = all_ball_dict.addballs
	for k in base_ball_dict:
		var ball = base_ball_dict[k]
		var project_list = lnz.project_ball.get(ball.ball_no, [])
		for p in project_list:
			var base_ball = base_ball_dict[p.base]
			var current_vector = ball.position - base_ball.position
			var scaled_vector = current_vector * (p.amount / 100.0)
			ball.position = base_ball.position + scaled_vector
			base_ball_dict[k] = ball
	for k in addball_dict:
		var ball = addball_dict[k]
		var add_base_ball = base_ball_dict[ball.base]
		var project_list = lnz.project_ball.get(ball.ball_no, [])
		for p in project_list:
			# all the addballs should be projected from a base ball
			# otherwise it's kind of meaningless
			var base_ball = base_ball_dict[p.base]
			var actual_position = ball.position + add_base_ball.position
			var current_vector = actual_position - base_ball.position
			var scaled_vector = current_vector * (p.amount / 100.0)
			actual_position = base_ball.position + scaled_vector
			ball.position = actual_position - add_base_ball.position
			addball_dict[k] = ball
			
	return {balls = base_ball_dict, addballs = all_ball_dict.addballs, paintballs = all_ball_dict.paintballs} 

func apply_sizes(all_ball_dict: Dictionary, lnz: LnzParser):
	for k in all_ball_dict.balls:
		var ball = all_ball_dict.balls[k]
		ball.size = floor(ball.size * (lnz.scales[1] / 255.0))
#		ball.fuzz = floor(ball.fuzz * (lnz.scales[1] / 255.0))
		ball.position = (ball.position * (lnz.scales[0] / 255.0))
		all_ball_dict.balls[k] = ball
		
	for k in all_ball_dict.addballs:
		var ball = all_ball_dict.addballs[k]
		ball.size = floor(ball.size * (lnz.scales[1] / 255.0))
#		ball.fuzz = floor(ball.fuzz * (lnz.scales[1] / 255.0))
		ball.position = (ball.position * (lnz.scales[0] / 255.0))
		all_ball_dict.addballs[k] = ball
		
	return {balls = all_ball_dict.balls, addballs = all_ball_dict.addballs, paintballs = all_ball_dict.paintballs}

func get_root():
	if Engine.is_editor_hint():
		return get_tree().get_edited_scene_root()
	else:
		return get_tree().root.get_node("Spatial")

func generate_balls(all_ball_data: Dictionary, species: int, texture_list: Array):
	var ball_data = all_ball_data.balls
	var addball_data = all_ball_data.addballs
	var paintball_data = all_ball_data.paintballs
	var omissions = all_ball_data.omissions
	var root = get_root()
	var parent = root.get_node("petholder/balls")
	var pb_parent = root.get_node("petholder/paintballs")
	var ab_parent = root.get_node("petholder/addballs")
	for c in parent.get_children():
		parent.remove_child(c)
		c.queue_free()
	for c in pb_parent.get_children():
		pb_parent.remove_child(c)
		c.queue_free()
	for c in ab_parent.get_children():
		ab_parent.remove_child(c)
		c.queue_free()
	
	var eyes: Dictionary
	if species == 2:
		eyes = eyes_dog
	else:
		eyes = eyes_cat
	for key in ball_data:
		var ball = ball_data[key]
		var visual_ball
		if(key in eyes.keys()): # treat irises like paintballs
			visual_ball = paintball_scene.instance()
			var base_ball = ball_data[eyes[key]]
			visual_ball.base_ball_size = base_ball.size / 2
			var bbp = base_ball.position
			bbp.y *= -1
			bbp *= pixel_world_size
			visual_ball.base_ball_position = bbp
			var rotated_pos = ball.position
			rotated_pos.y *= -1.0
			visual_ball.transform.origin = rotated_pos * pixel_world_size
		else:
			visual_ball = ball_scene.instance()
			var rotated_pos = ball.position
			rotated_pos.y *= -1.0
			visual_ball.transform.origin = rotated_pos * pixel_world_size
			visual_ball.ball_no = ball.ball_no
			if ball.texture_id > -1:
				var tex_info = texture_list[ball.texture_id]
				var texture_filename = tex_info.filename
				var transparent_color = tex_info.transparent_color
				var texture = load("res://resources/textures/"+texture_filename)
				visual_ball.texture = texture
				visual_ball.transparent_color = transparent_color
			else:
				visual_ball.transparent_color = ball.color
			visual_ball.color_index = ball.color_index
		visual_ball.ball_size = get_real_ball_size(ball.size)
		visual_ball.z_add = ball.z_add
		visual_ball.color = ball.color
		visual_ball.outline = ball.outline
		visual_ball.outline_color = ball.outline_color
		visual_ball.fuzz_amount = ball.fuzz / 2
		parent.add_child(visual_ball)
		visual_ball.set_owner(root)
		ball_map[ball.ball_no] = visual_ball
		visual_ball.visible = true
		if !draw_balls:
			visual_ball.visible = false
		if omissions.get(key, false):
			visual_ball.hide()
			
	for key in addball_data:
		var ball = addball_data[key]
		var visual_ball = ball_scene.instance()
		visual_ball.ball_size = get_real_ball_size(ball.size)
		var base_pos = ball_data[ball.base].position
		var rotated_pos = ball.position + base_pos
		rotated_pos.y *= -1.0
		visual_ball.transform.origin = rotated_pos * pixel_world_size
		visual_ball.color = ball.color
		visual_ball.outline = ball.outline
		visual_ball.outline_color = ball.outline_color
		visual_ball.z_add = ball.z_add
		visual_ball.fuzz_amount = ball.fuzz / 2
		visual_ball.ball_no = ball.ball_no
		visual_ball.base_ball_no = ball.base
		ab_parent.add_child(visual_ball)
		visual_ball.set_owner(root)
		ball_map[ball.ball_no] = visual_ball
		visual_ball.visible = true
		if !draw_addballs:
			visual_ball.visible = false
		if omissions.get(key, false):
			visual_ball.hide()
			
	for key in paintball_data:
		var merged_dict = {}
		for v in ball_data:
			merged_dict[v] = ball_data[v]
		for v in addball_data:
			merged_dict[v] = addball_data[v]
		var base_ball = merged_dict[key]
		var paintballs_for_base_ball: Array = paintball_data[key]
		paintballs_for_base_ball.invert()
		var count = 0
		for paintball in paintballs_for_base_ball:
			var base_position = base_ball.position
			if base_ball is AddBallData:
				var real_base_ball = merged_dict[base_ball.base]
				base_position += real_base_ball.position
			var final_position = base_ball.position + (paintball.normalised_position * base_ball.size / 2)
			final_position.y *= -1.0
			final_position *= pixel_world_size
			base_position.y *= -1.0
			base_position *= pixel_world_size
			var final_size = get_real_ball_size(base_ball.size * (paintball.size / 100.0))
			var visual_ball = paintball_scene.instance()
			visual_ball.base_ball_position = base_position
			visual_ball.transform.origin = final_position
			visual_ball.ball_size = final_size
			visual_ball.base_ball_size = base_ball.size / 2
			visual_ball.color = paintball.color
			visual_ball.outline_color = paintball.outline_color
			visual_ball.outline = paintball.outline
			visual_ball.fuzz_amount = paintball.fuzz / 2
			visual_ball.z_add = count * 0.0000001
			visual_ball.base_ball_no = paintball.base
			count += 1
			pb_parent.add_child(visual_ball)
			visual_ball.set_owner(root)
			if !draw_balls:
				visual_ball.visible = false
				
func get_real_ball_size(ball_size):
	var half_size = floor(ball_size / 2.0)
	return max(half_size - 2, 2)
				
func generate_lines(line_data: Array):
	var root = get_root()
	var parent = root.get_node("petholder/lines")
	for c in parent.get_children():
		parent.remove_child(c)
		c.queue_free()
	
	for line in line_data:
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
		if line.color == null:
			visual_line.color = start.color
		else:
			visual_line.color = line.color
		if line.r_color == null:
			visual_line.r_color = start.color
		else:
			visual_line.r_color = line.r_color
		if line.l_color == null:
			visual_line.l_color = start.color
		else:
			visual_line.l_color = line.l_color
		visual_line.fuzz_amount = line.fuzz
		var final_line_width = Vector2(start.ball_size * 2 + 1, end.ball_size * 2 + 1)
		final_line_width = final_line_width * (Vector2(line.s_thick, line.e_thick) / 100)
		visual_line.line_widths = final_line_width
		
		parent.add_child(visual_line)
		visual_line.set_owner(root)


func _on_showballs_toggled(button_pressed):
	get_tree().root.get_node("Spatial/petholder/balls").visible = button_pressed

func _on_showlines_toggled(button_pressed):
	get_tree().root.get_node("Spatial/petholder/lines").visible = button_pressed

func _on_CheckBox3_toggled(button_pressed):
	get_tree().root.get_node("Spatial/petholder/paintballs").visible = button_pressed

func _on_OptionButton_file_selected(file_name):
	generate_pet(file_name)
	
func _on_OptionButton_file_saved(file_name):
	generate_pet(file_name)
