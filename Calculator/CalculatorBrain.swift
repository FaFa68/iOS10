//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Farshad Faradji on 02/03/17.
//  Copyright © 2017 FaFa. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private enum  Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = [
        "Π"   : Operation.constant(Double.pi),
        "e"   : Operation.constant(M_E),
        "√"   : Operation.unaryOperation(sqrt),
        "cos" :Operation.unaryOperation(cos),
        "+"   : Operation.binaryOperation({$0 + $1}),
        "-"   : Operation.binaryOperation({$0 - $1}),
        "*"   : Operation.binaryOperation({$0 * $1}),
        "÷"   : Operation.binaryOperation({$1 / $0}),
        "="   : Operation.equals
    ]
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with :  accumulator!)
        }
    }
    private var pendingBinaryOperation : PendingBinaryOperation?
    private  struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperan: Double
        
        func perform(with secondOperand: Double)-> Double {
            return function(firstOperan, secondOperand)
        }
    }
    mutating func performOperation (_ Symbol:String){
        if let operation = operations[Symbol]{
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperan: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    mutating func setOperand(_ operand : Double){
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
    
}
