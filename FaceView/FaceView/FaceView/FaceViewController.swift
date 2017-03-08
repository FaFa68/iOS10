//
//  ViewController.swift
//  FaceView
//
//  Created by Farshad Faradji on 07/03/17.
//  Copyright © 2017 FaFa. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Normal , mouth: .Frown) {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView, action: #selector(FaceView.changeScale(recognizer:))
            ))
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.increaseHappiness)
            )
            happierSwipeGestureRecognizer.direction = .up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
            
            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self, action: #selector(FaceViewController.decreaseHappiness)
            )
            sadderSwipeGestureRecognizer.direction = .down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            updateUI()
        }
    }
    private var mouthCurvatures = [FacialExpression.Mouth.Frown     : -1.0,
                                   FacialExpression.Mouth.Smirk     : -0.5,
                                   FacialExpression.Mouth.Neutral   :  0.0,
                                   FacialExpression.Mouth.Grin      :  0.5,
                                   FacialExpression.Mouth.Smile     :  1.0]
    private var eyeBrowTilits = [FacialExpression.EyeBrows.Furrowed : -0.5,
                                 FacialExpression.EyeBrows.Normal   :  0.0,
                                 FacialExpression.EyeBrows.Relaxed  :  0.5]
    private func updateUI() {
        switch expression.eyes {
        case .Open: faceView.eyesOpen   = true
        case .Closed: faceView.eyesOpen = false
        case .Squinting: faceView.eyesOpen = false
        }
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        faceView.eyeBrowTilt = eyeBrowTilits[expression.eyeBrows]   ?? 0.0
    }
    
    func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
}

