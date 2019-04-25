import UIKit

class AASphereView: UIView {

    private var coordinates = [AAPoint]()
    private var tagViews = [UIView]()
    
    private var lastPan = CGPoint.zero
    private var translation = CGPoint.zero
    private var velocity = CGPoint.zero
    private var timer: CADisplayLink?
    private var isPaned = false
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        timer?.invalidate()
        timer = nil
        
    }
    
    func setup() {
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(panAction(pan:)))
        self.addGestureRecognizer(pan)
        
        translation = CGPoint.init(x: 1, y: 0)
        
        timer = CADisplayLink.init(target: self, selector: #selector(autoRotate))
        timer?.add(to: RunLoop.main, forMode: .common)
        
    }
    
    func setTagViews(abbs:AbbsObject?, array: [UIView]) {
        
        self.tagViews = array
        
        let angle = CGFloat.pi * (3 - sqrt(5))
        for i in 0..<array.count {
            
            let z: CGFloat = CGFloat(i) * 2.0 / CGFloat(array.count) - 1.0 + 1.0 / CGFloat(array.count)
            let radius = sqrt(1.0 - z * z)
            let angle_i = angle * CGFloat(i)
            let x = radius * cos(angle_i)
            let y = radius * sin(angle_i)
            let location = AAPoint.init(x: x, y: y, z: z)
            self.coordinates.append(location)
            
            let view = array[i]
            self.addSubview(view)
            view.center = CGPoint.init(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
            let duration = Double(arc4random() % 10 + 10) / 20.0   //0.5~1.0s
            UIView.animate(withDuration: duration) {
                self.setViewWith(abbs: nil, coordinate: location, at: i)
            }
            
        }
        
    }
    
    func setViewWith(abbs:AbbsObject?, coordinate : AAPoint, at index: Int) {
        
        let tagView = tagViews[index]
        tagView.center = changeCoordinate(abbs: nil, point: coordinate)
        tagView.layer.zPosition = coordinate.z + 1
        let scale = (coordinate.z + 2.0) / 3.0      //0.3~1
        tagView.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        tagView.alpha = scale
        tagView.isUserInteractionEnabled = coordinate.x > 0.0
        
    }
    
    func rotateWith(abbs:AbbsObject?, translation: CGPoint) {
        
        var translation = translation
        translation.x /= self.bounds.width / 2.0
        translation.y /= self.bounds.height / 2.0
        
        for item in coordinates.enumerated() {
            
            var location = item.element
            location.rotate(abbs: nil, translation: translation)
            coordinates[item.offset] = location
            setViewWith(abbs: nil, coordinate: location, at: item.offset)
            
        }
        
    }
    
    func changeCoordinate(abbs:AbbsObject?, point: AAPoint) -> CGPoint {
        
        let x = (point.x + 1.0) / 2.0 * self.bounds.width
        let y = (point.y + 1.0) / 2.0 * self.bounds.height
        return CGPoint.init(x: x, y: y)
        
    }
    
    @objc func autoRotate() {
        
        if isPaned {
            let distance = sqrt(pow(translation.x, 2) + pow(translation.y, 2))
            if distance > 1 {
                
                let scale: CGFloat = 0.9
                translation.x *= scale
                translation.y *= scale
                rotateWith(abbs: nil, translation: translation)
                
            } else {
                isPaned = false
            }
        }
        
        rotateWith(abbs: nil, translation: CGPoint.init(x: translation.x, y: translation.y))
        
    }
    
    @objc func panAction(pan: UIPanGestureRecognizer) {
        
        if pan.state == .began {
            
            lastPan = pan.translation(in: self)
            timer?.isPaused = true
            
        }
        
        else if pan.state == .changed {
            
            let current = pan.translation(in: self)
            translation = CGPoint.init(x: current.x - lastPan.x, y: current.y - lastPan.y)
            rotateWith(abbs: nil, translation: translation)
            lastPan = current
            
        }
        
        else if pan.state == .ended {
            
            isPaned = true
            timer?.isPaused = false
            
        }
        
    }
    
}
