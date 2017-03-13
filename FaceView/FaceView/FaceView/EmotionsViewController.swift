//
//  EmotionsViewController.swift
//  FaceView
//
//  Created by Farshad Faradji on 13/03/17.
//  Copyright © 2017 FaFa. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {

 
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationViewController = destinationViewController as? UINavigationController {
            destinationViewController = navigationViewController.visibleViewController ?? destinationViewController
       //     destinationViewController.title = segue.identifier
        }
        if let faceViewController = destinationViewController as? FaceViewController {
            if let identifier = segue.identifier {
                if let expression = emotionalFaces[identifier]{
                    faceViewController.expression = expression
                 faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
                }
            }
        }
    }
    private let emotionalFaces : Dictionary<String , FacialExpression> = [
        "sad"     : FacialExpression(eyes: .Closed , eyeBrows: .Furrowed ,mouth: .Frown),
        "happy"   : FacialExpression(eyes: .Open   , eyeBrows: .Relaxed  ,mouth: .Smile),
        "Worried" : FacialExpression(eyes: .Open   , eyeBrows: .Normal   ,mouth: .Smirk)]
}
  
