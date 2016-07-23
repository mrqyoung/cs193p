//
//  CalculatorWonderModel.swift
//  Calc
//
//  Created by Mr.Q.Young on 16/7/14.
//  Copyright © 2016年 Yorn. All rights reserved.
//

import Foundation


class CalculatorWonderModel: CalculatorModel {
    // MARK : object Op
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperator(String, Double -> Double)
        case BinaryOperator(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand): return String(operand)
                case .UnaryOperator(let symbol, _): return symbol
                case .BinaryOperator(let symbol, _): return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String: Op]()
    var title: String = "Reverse Polish Calculator"
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        /*
        knownOps["+"] = Op.BinaryOperator("+", +)
        knownOps["×"] = Op.BinaryOperator("×", *)
        knownOps["−"] = Op.BinaryOperator("−") { $1 - $0 }
        knownOps["÷"] = Op.BinaryOperator("÷") { $1 / $0 }
        knownOps["^"] = Op.BinaryOperator("^", pow)
        knownOps["√"] = Op.UnaryOperator("√", sqrt)
        */
        learnOp( Op.BinaryOperator("+", +) )
        learnOp( Op.BinaryOperator("×", *) )
        learnOp( Op.BinaryOperator("−") { $1 - $0 } )
        learnOp( Op.BinaryOperator("÷") { $1 / $0 } )
        learnOp( Op.BinaryOperator("^", pow) )
        learnOp( Op.UnaryOperator("√", sqrt) )
        learnOp( Op.UnaryOperator("%") { $0 / 100 } )
    }
    
    func pushOperand(operand o: Double) {
        opStack.append(Op.Operand(o))
    }
    
    func reset() {
        opStack.removeAll()
    }
    
    func performOperation(operation o: String) -> Double? {
        if let op = knownOps[o] {
            opStack.append(op)
            return evaluate()
        }
        return nil
    }
    
    func evaluate() -> Double? {
        let (result, r) = evaluate(opStack)
        print("result=\(result), stack=\(r)")
        return result
    }
    
    private func evaluate(ops: [Op]) -> (Double?, [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let number):
                return (number, remainingOps)
            case .UnaryOperator(_, let operation):
                let (num, ops1) = evaluate(remainingOps)
                if (num != nil) {
                   return (operation(num!), ops1)
                }
            case .BinaryOperator(_, let operation):
                let (num1, ops1) = evaluate(remainingOps)
                let (num2, ops2) = evaluate(ops1)
                if num1 != nil && num2 != nil {
                    return (operation(num1!, num2!), ops2)
                }
            }
        }
        return (nil, ops)
    }
}
