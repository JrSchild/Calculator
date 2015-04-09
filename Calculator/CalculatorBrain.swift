//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Joram Ruitenschild on 08-04-15.
//  Copyright (c) 2015 Joram Ruitenschild. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    var formula = ""
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    private var variableValues = [String:Double]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("✕", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") { $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", { sin($0) }))
        learnOp(Op.UnaryOperation("cos", { cos($0) }))
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, formula: String, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, "\(operand)", remainingOps)
            case .UnaryOperation(let symbol, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), "\(symbol)(\(operandEvaluation.formula))", operandEvaluation.remainingOps)
                }
            case .BinaryOperation(let symbol, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), "(\(op1Evaluation.formula)\(symbol)\(op2Evaluation.formula))", op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, "", ops)
    }
    
    func evaluate() -> Double? {
        let (result, formula, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        println("formula = \(formula)")
        self.formula = formula
        
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        if let value = variableValues[symbol] {
            return pushOperand(value)
        }
        return nil
    }
    
    func PerformOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}