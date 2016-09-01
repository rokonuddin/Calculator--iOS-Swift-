//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Rokon Uddin on 7/14/16.
//  Copyright © 2016 Rokon Uddin. All rights reserved.
//

import Foundation

func factorial(op1: Double) -> Double {
    if (op1 <= 1) {
        return 1
    }
    return op1 * factorial(op1 - 1.0)
}

class CalculatorBarin
{
    private enum Operation {
        case Constant(Double)
        case UnaryOPeration((Double) -> Double)
        case BinaryOperation ((Double, Double) -> Double)
        case Equals
    }
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOPeration({-$0}),
        "√" : Operation.UnaryOPeration(sqrt),
        "x²" : Operation.UnaryOPeration({ pow($0, 2) }),
        "x³" : Operation.UnaryOPeration({ pow($0, 3) }),
        "x⁻¹" : Operation.UnaryOPeration({ 1/$0 }),
        "xʸ" : Operation.BinaryOperation(pow),
        "sin" : Operation.UnaryOPeration(sin),
        "cos" : Operation.UnaryOPeration(cos),
        "tan" : Operation.UnaryOPeration(tan),
        "sinh" : Operation.UnaryOPeration(sinh),
        "cosh" : Operation.UnaryOPeration(cosh),
        "tanh" : Operation.UnaryOPeration(tanh),
        "ln" : Operation.UnaryOPeration(log),
        "log" : Operation.UnaryOPeration(log10),
        "eˣ" : Operation.UnaryOPeration(exp),
        "10ˣ" : Operation.UnaryOPeration({ pow(10, $0) }),
        "x!" : Operation.UnaryOPeration(factorial),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "-" : Operation.BinaryOperation({$0 - $1}),
        "=" : Operation.Equals
        
    ]
    
    func setOperand(opetand: Double){
        accumulator = opetand
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol)
        if let operation = operations[symbol]{
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOPeration(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePrivateBinaryFunction()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePrivateBinaryFunction()
            }
        }
        
    }
    
    private func executePrivateBinaryFunction()
    {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject]  {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operand = op as? String {
                        performOperation(operand)
                    }
                }
            }
        }
    }
    
    func clear(){
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    
}