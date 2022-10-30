extends Spatial

var axis_prefab = preload("res://scenes/editor/GizmoAxis.tscn")
var surftool = SurfaceTool.new()
const arrow_points = 5
const ivec = Vector3(0, 0, -1)
const nivec = Vector3(-1, -1, 0)
const ivec2 = Vector3(-1, 0, 0)
const ivec3 = Vector3(0, -1, 0)
const GIZMO_ARROW_OFFSET = 1.1 * 0.7
const GIZMO_ARROW_SIZE = 0.35
var arrow = [
	nivec * 0.0 + ivec * 0.0,
	nivec * 0.01 + ivec * 0.0,
	nivec * 0.01 + ivec * GIZMO_ARROW_OFFSET,
	nivec * 0.065 + ivec * GIZMO_ARROW_OFFSET,
	nivec * 0.0 + ivec * (GIZMO_ARROW_OFFSET + GIZMO_ARROW_SIZE)
]
const arrow_sides = 16
const tau = PI * 2
const arrow_sides_step = tau / arrow_sides
export var material_template: SpatialMaterial
export var colors = [Color.red, Color.blue, Color.green]

func show_gizmo():
	if !visible:
		for i in 3:
			surftool.begin(Mesh.PRIMITIVE_TRIANGLES)
			for k in arrow_sides:
				var ma = Basis(ivec, k * arrow_sides_step)
				var mb = Basis(ivec, (k+1) * arrow_sides_step)
				for j in arrow_points - 1:
					var points = [
						ma.xform(arrow[j]),
						mb.xform(arrow[j]),
						mb.xform(arrow[j + 1]),
						ma.xform(arrow[j + 1])
					]
					surftool.add_vertex(points[0])
					surftool.add_vertex(points[1])
					surftool.add_vertex(points[2])
					surftool.add_vertex(points[0])
					surftool.add_vertex(points[2])
					surftool.add_vertex(points[3])

			var axis_angle: Transform = Transform()
			var xyz = [axis_angle.basis.x, axis_angle.basis.y, axis_angle.basis.z]
			axis_angle = axis_angle.looking_at(xyz[i].normalized(), xyz[(i + 1) % 3].normalized())
			axis_angle = axis_angle.scaled(0.1 * Vector3.ONE)
			axis_angle.origin = Vector3.ZERO
			var m = axis_prefab.instance()
			add_child(m)
			m.mesh = surftool.commit()
			m.transform = axis_angle
			m.material_override = material_template.duplicate()
			m.material_override.albedo_color = colors[i]
	visible = true

func destroy_gizmo():
	for c in get_children():
		c.queue_free()
	visible = false
