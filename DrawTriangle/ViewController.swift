//
//  ViewController.swift
//  DrawTriangle
//
//  Created by Kiet Nguyen on 19/07/2022.
//

import UIKit

class ViewController: UIViewController {
    
    var points:[CGPoint] = [CGPoint](repeating: CGPoint(x: 0, y: 0), count: 360)
    var backup:[CGPoint] = [CGPoint](repeating: CGPoint(x: 0, y: 0), count: 360)
    var choices:[CGPoint] = [CGPoint](repeating: CGPoint(x: 0, y: 0), count: 3)
    
    var triangleView: TriangleView?
    
    var previousPoints: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        if let triangleView = triangleView {
            self.view.bringSubviewToFront(triangleView)
            let translation = sender.translation(in: self.view)
            triangleView.center = CGPoint(x: triangleView.center.x + translation.x, y: triangleView.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
    }

    @IBAction func drawAction(_ sender: Any) {
        self.drawTriangle()
    }
    
    
    func drawTriangle() {
        
        self.previousPoints = self.triangleView?.frame.origin
        
        self.triangleView?.removeFromSuperview()
        let randomInt = Double.random(in: 0..<359)
        let updatePoint = calcPolyV(rect: CGSize(width: 200, height: 300), sides: 360, angle: randomInt, radius: 64)
        
        points = updatePoint
        backup = updatePoint
        
        let choice = returnPoints()
        
        for i in 0..<choice.count {
            choices[i] = points[choice[i]]
        }
        
        let frame = CGRect(x: self.previousPoints?.x ?? 50, y: self.previousPoints?.y ?? 200, width: 200, height: 300)
        
        let triangle = TriangleView(frame: frame)
        triangle.points = choices
        triangle.backgroundColor = .clear
        self.triangleView = triangle
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.draggedView(_:)))
        triangleView?.isUserInteractionEnabled = true
        triangleView?.addGestureRecognizer(panGesture)
        
        self.view.addSubview(triangle)
    }
    
    
    func returnPoints() -> [Int] {
      var points = [Int]()
      for i in 0..<3 {
        let sRange = i*120
        let eRange = (i + 1)*120
        let k = Int.random(in: sRange ..< eRange)
        points.append(k)
      }
      return points
    }
    
    func calcPolyV(rect: CGSize, sides: Double, angle: Double, radius: Double) -> [CGPoint] {
      var angles = [CGPoint]()
      let center:CGPoint = CGPoint(x: rect.width / 2, y: rect.height / 2)
      for i in stride(from: angle, to: (360 + angle), by: 360/sides) {
        let radians = Double(i) * Double.pi / 180.0
        let x = Double(center.x) + radius * cos(radians)
        let y = Double(center.y) + radius * sin(radians)
        angles.append(CGPoint(x: x, y: y))
      }
      return angles
    }

}


class TriangleView : UIView {
    
    var points: [CGPoint] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.points[0].x, y: self.points[0].y))
        path.addLine(to: CGPoint(x: self.points[1].x, y: self.points[1].y))
        path.addLine(to: CGPoint(x: self.points[2].x, y: self.points[2].y))
        UIColor.blue.setStroke()
        path.close()
        path.stroke()
    }
}

