//
//  ViewController.swift
//  Calculator
//
//  Created by Joram Ruitenschild on 02-04-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    
    @IBOutlet weak var historyLabel: UILabel!
    
    // Add digits to display text
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func addComma() {
        if display.text!.rangeOfString(".") == nil {
            display.text = display.text! + "."
        }
    }
    
    @IBAction func addConstant(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            switch operation {
            case "π":
                displayValue = M_PI
                enter()
            default: break
            }
        }
    }
    
    // Run a basic operation with numbers off the stack.
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.PerformOperation(operation) {
                historyLabel.text = brain.formula
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    // Add the displayValue to the stack
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    // Getters and setters for displayValue
    var displayValue: Double? {
        get {
            // Tutorial code throws error (iPhone 4, iOS 7). This works better
            return (display.text! as NSString).doubleValue
        }
        set {
            if newValue == nil {
                display.text = ""
            } else {
                display.text = "\(newValue!)"
                userIsInTheMiddleOfTypingANumber = false
            }
        }
    }
}

