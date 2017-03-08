  //
  //  FaceView.swift
  //  FaceView
  //
  //  Created by Farshad Faradji on 07/03/17.
  //  Copyright © 2017 FaFa. All rights reserved.
  //
  
  import UIKit
  
  class FaceView: UIView {
    
    var color: UIColor = UIColor.blue
    var linewidth: CGFloat = 5.0
    var scale: CGFloat = 0.90
    let mouthCurvature = 1.0
    var eyesOpen:Bool = true
    let eyeBrowTilt = 1.0
    var skullRadius: CGFloat{
        return min(bounds.size.width, bounds.size.height)/2 * scale
    }
    var skullCenter : CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    private struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset:CGFloat = 3
        static let SkullRadiusToBrowOffset: CGFloat = 5
    }
    
    private enum Eye {
        case leftEye
        case rightEye
    }
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint , withRadius radius: CGFloat) -> UIBezierPath {
        let path =  UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*M_PI),
            clockwise: false
        )
        path.lineWidth = linewidth
        return path
    }
    private func  getEyeCenter(eye: Eye) -> CGPoint{
        let eyeOffset =  skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .leftEye:  eyeCenter.x -= eyeOffset
        case .rightEye: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    private func pathForEye(eye: Eye)-> UIBezierPath {
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let eyeCenter = getEyeCenter(eye: eye)
        if eyesOpen {
        return pathForCircleCenteredAtPoint(midPoint: eyeCenter, withRadius: eyeRadius)
        } else {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
            path.lineWidth = linewidth
            return path
        }
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth =  skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        
        let smileOffset = CGFloat(max(-1,min(mouthCurvature,1)))*mouthHeight
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end   = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 =   CGPoint(x: mouthRect.minX + mouthRect.width/3, y: mouthRect.minY + smileOffset)
        let cp2 =   CGPoint(x: mouthRect.maxX - mouthRect.width/3, y: mouthRect.minY + smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = linewidth
        return path
    }
    
    private func pathForEyebrow(eye: Eye) -> UIBezierPath {
        
        var tilt = eyeBrowTilt
        switch eye {
        case .leftEye: tilt *= -1.0
        case .rightEye: break
        }
        var browCenter = getEyeCenter(eye: eye)
        browCenter.y  -= skullRadius / Ratios.SkullRadiusToBrowOffset
        let eyeRadius  = skullRadius / Ratios.SkullRadiusToEyeRadius
        let tiltOffset = CGFloat(max(-1 , min(tilt ,1))) * eyeRadius / 2
        let browStart  = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd    = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = linewidth
        return path
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        color.set()
        pathForCircleCenteredAtPoint(midPoint: skullCenter, withRadius: skullRadius).stroke()
        pathForEye(eye: .leftEye).stroke()
        pathForEye(eye: .rightEye).stroke()
        pathForMouth().stroke()
        pathForEyebrow(eye: .leftEye).stroke()
        pathForEyebrow(eye: .rightEye).stroke()
    }
  }
