extends Polygon2D

@export var OutLine: Color = Color(40,40,0)
@export var Width: float = 2.0

func _draw():
	var poly = get_polygon()
	for i in range(1 , poly.size()):
		draw_line(poly[i-1] , poly[i], OutLine , Width)
	draw_line(poly[poly.size() - 1] , poly[0], OutLine , Width)
