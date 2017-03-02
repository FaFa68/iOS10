//
//  ViewController.swift
//  Calculator
//
//  Created by Farshad Faradji on 02/03/17.
//  Copyright © 2017 FaFa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  
    @IBOutlet weak var display: UILabel!
    var userIsInTheMiddleOfTyping = false
    var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    @IBAction func touchDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    @IBAction func performOperation(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle {
            switch mathematicalSymbol {
            case "Π":
                displayValue = M_PI
            default:
                break
            }
        }
    }
    @IBAction func performClear(_ sender: UIButton) {
        displayValue = 0
    }
}

