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
    
    // Initialize stack to store the operation values
    var operandStack = Array<Double>()
    
    var userIsInTheMiddleOfTypingANumber = false
    
    @IBOutlet weak var display: UILabel!
    
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
    
    // Run a basic operation with numbers off the stack.
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
            case "✕": performOperation { $0 * $1 }
            case "÷": performOperation { $1 / $0 }
            case "+": performOperation { $0 + $1 }
            case "−":  performOperation { $1 - $0 }
            case "√":  performOperation { sqrt($0) }
            default: break
        }
    }
    
    // Perform operation on two doubles
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }

    // Perform operation on a single double
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    // Add the displayValue to the stack
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
    }
    
    // Getters and setters for displayValue
    var displayValue: Double {
        get {
            // Tutorial code throws error (iPhone 4, iOS 7). This works better
            return (display.text! as NSString).doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
}

