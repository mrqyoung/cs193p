//
//  FaceView.swift
//  cs193p
//
//  Created by Mr.Q.Young on 16/7/17.
//  Copyright © 2016年 Yorn. All rights reserved.
//

import UIKit


protocol FaceViewDataSource: class {
    func getHappiness(sender: FaceView) -> Double?
}

//@IBDesignable
class FaceView: UIView {

    weak var faceViewDataSource: FaceViewDataSource?
    
    @IBInspectable
    var lineWidth: CGFloat = 3.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.orangeColor() { didSet { setNeedsDisplay() } }
    var scale: CGFloat = 0.8 { didSet { setNeedsDisplay()} }
    
    var faceCenter: CGPoint {
        return convertPoint(center, fromCoordinateSpace: superview!)
    }
    
    var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    private enum Eye { case Left, Right }
    
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath {
        let eyeRadius = self.faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = self.faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = self.faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        var eyeCenter = self.faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye {
        case .Left: eyeCenter.x -= eyeHorizontalSeparation / 2
        case .Right: eyeCenter.x += eyeHorizontalSeparation / 2
        }
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius,
            startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        path.lineWidth = self.lineWidth * 0.8
        return path
    }
    
    private func bezierPathForSmile(fractionOfMaxSmile: Double) -> UIBezierPath {
        let mouthWidth = self.faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = self.faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = self.faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = self.lineWidth
        return path
    }
    
    func zoom(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            self.scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    override func drawRect(rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius,
            startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: true)
        facePath.lineWidth = self.lineWidth
        self.color.set()
        facePath.stroke()
        
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        
        let smiliness: Double = faceViewDataSource?.getHappiness(self) ?? 0
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()
    }

}
