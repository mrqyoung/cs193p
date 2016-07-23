//
//  Calculator.swift
//  Calc
//
//  Created by Mr.Q.Young on 16/7/14.
//  Copyright © 2016年 Yorn. All rights reserved.
//

import Foundation


protocol CalculatorModel {
    var title: String {get set}
    func pushOperand(operand o: Double)
    func performOperation(operation o: String) -> Double?
    func reset()
}

enum CalculatorModelStyle: Int {
        case WONDER = 0
        case NORMAL = 1
}
