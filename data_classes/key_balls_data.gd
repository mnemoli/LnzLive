extends Node

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
var ear_ext_dog = { 4: [5, 6], 28: [29, 30] }
var ear_ext_cat = { 8: [9], 10: [11]  }
var eyes_dog = {14: 8, 38: 32} # iris = eye
var eyes_cat = { 27: 14, 28: 15}
var nose_dog = [17, 41, 55]
var nose_cat = [77, 78, 79]

var species
var max_base_ball_num

enum Species { CAT = 1, DOG = 2 }
