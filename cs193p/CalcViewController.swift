//
//  ViewController.swift
//  Calc
//
//  Created by Mr.Q.Young on 16/7/11.
//  Copyright © 2016年 Yorn. All rights reserved.
//

import UIKit

class CalcViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    lazy var calc: CalculatorModel = CalculatorWonderModel()
    
    init?(style: Int) {
        super.init(nibName: nil, bundle: nil)
        if style == CalculatorModelStyle.NORMAL.rawValue {
            initNormalCalculator()
        }
    }
    
    var calculatorStyle: Int = 0
    
    private func initNormalCalculator() {
            self.calc = CalculatorNormalModel()
            self.title = self.calc.title
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        if calculatorStyle == CalculatorModelStyle.NORMAL.rawValue {
            initNormalCalculator()
        }
        print("init calc type: \(calculatorStyle)")
    }
    
    
    @IBOutlet weak var display: UILabel!
    
    @IBAction func inputNumber (sender: UIButton) {
        if let num = sender.currentTitle {
            if isTyping {
                if display.text!.characters.count > 9 {
                    print("TOOO LONG")
                    return
                }
                display.text = display.text! + num
            } else {
                display.text = num
                isTyping = true
            }
        }
    }
    
    var isTyping = false
    var displayValue: Double {
        set {
            let value = String(newValue)
            self.display.text = (value.characters.count > 10) ?
                value.substringToIndex(value.startIndex.advancedBy(10)) : value
            isTyping = false
        }
        get {
            if let text = self.display.text {
                return NSNumberFormatter().numberFromString(text)!.doubleValue
            } else {
                return 0
            }
        }
    }
    
    
    
    @IBAction func enter() {
        if isTyping {
            self.calc.pushOperand(operand: displayValue)
            isTyping = false
        }
    }
 
    @IBAction func clearAll() {
        self.calc.reset()
        self.displayValue = 0
    }

    @IBAction func clearErrorInput() {
        self.displayValue = 0
    }
    
    
    @IBAction func operate(sender: UIButton) {
        enter()
        if let operation = sender.currentTitle {
            let result  = self.calc.performOperation(operation: operation)
            displayValue = result ?? 0
        } else {
            displayValue = 0
        }
    }
    
    
}

