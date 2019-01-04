import UIKit
import Vision


extension UIView {
	
	/// Flip and rotate view
	static func flipAndRotate() -> CGAffineTransform {
		let flip = CGAffineTransform(scaleX: -1, y: 1)
		let rotate = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
		return flip.concatenating(rotate)
	}
	
}

extension CGRect {
	
	/// Convert CGRect to fit bounds
	static func convert(boundingBox: CGRect, bounds: CGRect) -> CGRect {

		var rect = boundingBox
		
		// Reposition origin.
		rect.origin.x *= bounds.width
		rect.origin.x += bounds.origin.x
		rect.origin.y = (1 - rect.origin.y) * bounds.height + bounds.origin.y
		
		// Rescale normalized coordinates.
		rect.size.width *= bounds.width
		rect.size.height *= bounds.height
		
		return rect
	}
	
}

/// Convert UIImageOrientation to CGImageOrientation for use in Vision analysis.
extension CGImagePropertyOrientation {
	
	init(_ uiImageOrientation: UIImage.Orientation) {
		switch uiImageOrientation {
		case .up: self = .up
		case .down: self = .down
		case .left: self = .left
		case .right: self = .right
		case .upMirrored: self = .upMirrored
		case .downMirrored: self = .downMirrored
		case .leftMirrored: self = .leftMirrored
		case .rightMirrored: self = .rightMirrored
		}
	}
	
}
