import UIKit
import Vision


class ViewController: UIViewController {
	
	// Layer to hold Vision results.
	private lazy var pathLayer = CALayer()
	
	// Face overlay, all visual landmarks are relative to the face bounds. All points will be on this view
	private var face: UIView!
	
	// Holds image, which is set in the storyboard
	@IBOutlet weak var imageView: UIImageView!
	
	//	MARK: -
	
	override func viewDidLoad() {
		super.viewDidLoad()
		find(faceIn: imageView)
	}
	
	//	MARK: - Setup
	
	private func find(faceIn imageView: UIImageView) {
		
		guard let image = imageView.image else { return	 }
		
		setPathLayer(imageView)
		
		let cgOrientation = CGImagePropertyOrientation(image.imageOrientation)
		guard let cgImage = image.cgImage else { return }
		
		performVisionRequest(image: cgImage, orientation: cgOrientation)
	}
	
	
	private func setPathLayer(_ imageView: UIImageView) {
		
		// Transform image to fit screen.
		guard let cgImage = imageView.image!.cgImage else { return }
		
		let fullImageWidth = CGFloat(cgImage.width)
		let fullImageHeight = CGFloat(cgImage.height)
		
		let widthRatio = fullImageWidth / imageView.frame.width
		let heightRatio = fullImageHeight / imageView.frame.height
		
		// Scaled image down according to the stricter dimension.
		let scaleDownRatio = max(widthRatio, heightRatio)
		
		// Cache image dimensions to reference when drawing CALayer paths.
		let imageWidth = fullImageWidth / scaleDownRatio
		let imageHeight = fullImageHeight / scaleDownRatio
		
		// Prepare pathLayer to hold Vision results.
		let xLayer = (imageView.frame.width - imageWidth) / 2
		let yLayer = imageView.frame.minY + (imageView.frame.height - imageHeight) / 2
		
		pathLayer.bounds = CGRect(x: xLayer, y: yLayer, width: imageWidth, height: imageHeight)
		pathLayer.anchorPoint = CGPoint.zero
		pathLayer.position = CGPoint(x: xLayer, y: yLayer)
		self.view.layer.addSublayer(pathLayer)
	}
	
	
	func createFaceOverlay(frame: CGRect) {
		
		face = UIView(frame: frame)
		self.view.addSubview(face)
		
		// Flip and rotate to match CALayer
		face.transform = UIView.flipAndRotate()
		face.frame.origin.y = frame.origin.y - frame.size.height
	}
	
	// MARK: - Detection
	
	private func performVisionRequest(image: CGImage, orientation: CGImagePropertyOrientation) {
		
		let request = [VNDetectFaceLandmarksRequest(completionHandler: handleDetectedFaceLandmarks)]
		let requestHandler = VNImageRequestHandler(cgImage: image, orientation: orientation, options: [:])
		
		// Send the requests to the request handler.
		DispatchQueue.global(qos: .userInitiated).async {
			do {
				try requestHandler.perform(request)
			} catch { print("Could not find face") }
		}
	}
	
	
	private func handleDetectedFaceLandmarks(request: VNRequest?, error: Error?) {
		
		guard let results = request?.results as? [VNFaceObservation], let face = results.first, let landmarks = face.landmarks, let nose = landmarks.nose else { return }

		DispatchQueue.main.async {
			
			self.createFaceOverlay(frame: CGRect.convert(boundingBox: face.boundingBox, bounds: self.pathLayer.bounds))
			
			// Create point in the center of the nose
			let dot = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
			dot.backgroundColor = UIColor.yellow
			Nose.points = self.points(for: nose)
			dot.center = Nose.center
			self.face.addSubview(dot)
		}
		
	}
	
	// MARK: - Face Geometry
	
	private func points(for landmark:VNFaceLandmarkRegion2D) -> [CGPoint] {
		
		// Iterate through points, create views on those points
		for landmark in landmark.normalizedPoints {
			let point = VNImagePointForNormalizedPoint(landmark, Int(face.frame.size.width), Int(face.frame.size.height))
			
			let dot = UIView(frame: CGRect(x: point.x - 5, y: point.y - 5, width: 10, height: 10))
			dot.center = point
			dot.backgroundColor = UIColor.red
			
			face.addSubview(dot)
		}
		
		// Get points from face view because they are relative to its bounds
		var points = [CGPoint]()
		for sv in face.subviews {
			points.append(sv.center)
		}
		
		return points
	}

	
}

