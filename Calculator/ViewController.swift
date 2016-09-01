//
//  ViewController.swift
//  Calculator
//
//  Created by Rokon Uddin on 7/14/16.
//  Copyright © 2016 Rokon Uddin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet private weak var display: UILabel!
    private var userIsInTheMiddleOfTyping = false {
        didSet {
            if !userIsInTheMiddleOfTyping {
                userIsInTheMiddleOfFloatingPointNummer = false
            }
        }
    }
    
    private var userIsInTheMiddleOfFloatingPointNummer = false
    private var brain = CalculatorBarin()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustButtonLayout(view, portrait: traitCollection.horizontalSizeClass == .Compact && traitCollection.verticalSizeClass == .Regular)
        self.view.backgroundColor = UIColor.darkGrayColor();
        self.display.backgroundColor = UIColor.darkGrayColor();
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        adjustButtonLayout(view, portrait: newCollection.horizontalSizeClass == .Compact && newCollection.verticalSizeClass == .Regular)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private  var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction private func touchDigit(sender: UIButton) {
        var digit = sender.currentTitle!
        
        if digit == "." {
            if userIsInTheMiddleOfFloatingPointNummer {
                return
            }
            
            if !userIsInTheMiddleOfTyping {
                digit = "0."
            }
            userIsInTheMiddleOfFloatingPointNummer = true
        }
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }else{
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false;
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
    
    private func adjustButtonLayout(view: UIView, portrait: Bool) {
        for subview in view.subviews {
            if subview.tag == 1 {
                subview.hidden = portrait
            } else if subview.tag == 2 {
                subview.hidden = !portrait
            }
            if let button = subview as? UIButton {
                button.setBackgroundColor(UIColor.blackColor(), forState: .Highlighted)
            } else if let stack = subview as? UIStackView {
                adjustButtonLayout(stack, portrait: portrait);
            }
        }
    }
    
    
    
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState state: UIControlState) {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext();
        color.setFill()
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        setBackgroundImage(image, forState: state);
    }
}

