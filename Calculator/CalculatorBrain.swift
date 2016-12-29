//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Eugenio Penate on 12/28/16.
//  Copyright © 2016 Eugenio Penate. All rights reserved.
//

import Foundation

func multiply(op1: Double,op2: Double) -> Double {
    return op1 * op2
}
class CalculatorBrain
{
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI), //M_PI,
        "e" : Operation.Constant(M_E),                                              // associated value
        "√" : Operation.UnaryOperation(sqrt),                                       // associated function,
        "cos" : Operation.UnaryOperation(cos),                                      // associated function
        "×" : Operation.BinaryOperation(multiply),                                  // associated function
        "÷" : Operation.BinaryOperation( { (op1: Double, op2: Double) -> Double in  // Form of the closure function
            return op1 / op2                                                        // swift can infer the data type and the return, so it is redundant
        }),                                                                         // so it simplify by: { (op1, op2) in return op1 * op2 }
        "+" : Operation.BinaryOperation( {return $0 + $1 }),                        // it can have default arguments {($0, $1) in return $0 + $1 }
        "-" : Operation.BinaryOperation( {$0 - $1}),                                // because $0 - $1 is a double, and swift infer the return is a double, 
                                                                                    // it doesn't need the return
        "=" : Operation.Equals
    ]
    
    
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation ((Double) -> Double)
        case BinaryOperation ((Double, Double) -> Double)
        case Equals
        
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let associatedConstantValue):
                accumulator = associatedConstantValue
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation (let function):
                executePendingBinaryOperation()
                pending = PendinBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
            
        }
    }
    
    private func executePendingBinaryOperation()
    {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendinBinaryOperationInfo?
    
    struct PendinBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}
