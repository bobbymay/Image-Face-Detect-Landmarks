import UIKit


struct Nose {
	
	static var points = [CGPoint.zero]
	
	/// Top center of the nose
	static var top: CGPoint {
		let space = points[8].x - points[0].x
		let x = points[0].x + space/2
		let y = [points[0].y, points[8].y].max()!
		return CGPoint(x: x, y: y)
	}
	
	/// Bottom center of the nose
	static var bottom: CGPoint { return points[4] }
	
	/// Center of the nose
	static var center: CGPoint {
		let width = points[7].x - points[1].x
		let x = points[1].x + width/2
		let height = bottom.y - top.y
		let y = top.y + height/2
		return CGPoint(x: x, y: y)
	}

	static var leftNostril: CGPoint { return points[3] }
 static var rightNostril: CGPoint { return points[5] }
	static var leftEdge: CGPoint { return points[2] }
	static var rightEdge: CGPoint { return points[6] }
	
}

