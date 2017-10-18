//
//  ViewController.swift
//  QuickTip
//
//  Created by Brian on 5/27/17.
//  Copyright © 2017 Fleury Mobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billOutlet: UITextField!
    @IBOutlet weak var tipSegment: UISegmentedControl!
    
    var billAmount = 0.00
    let numberFormatter = NumberFormatter()
    let currencyFormatter = NumberFormatter()
    var digitDeleted = true
    
    @IBAction func tipSegment(_ sender: Any) {
        calculateTip(adjustPercentage: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initial formatting of fields using monetary
        currencyFormatter.numberStyle = .currency
        if let formattedBill = currencyFormatter.string(from: billAmount as NSNumber) {
            billOutlet.text = formattedBill
            tipLabel.text = formattedBill
            totalLabel.text = formattedBill
        }
        
        //execute tip calculation when text field value changes
        billOutlet.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func textFieldDidChange() {
        //remove dollar signs from string
        var editedBill = billOutlet.text?.replacingOccurrences(of: "$", with: "")
        //remove commas from string
        editedBill = editedBill?.replacingOccurrences(of: ",", with: "")
        
        //get the double value from the string
        if let amount = numberFormatter.number(from: editedBill!)?.doubleValue {
            billAmount = amount
            calculateTip(adjustPercentage: false)
        } else {
            print("Invalid number: \(String(describing: editedBill))")
        }
    }
    
    func calculateTip(adjustPercentage: Bool) {
        
        //get the current tip selection
        var tipPercent: Double = 20
        
        //get the selected tip percentage from segment bar
        switch(tipSegment.selectedSegmentIndex) {
            case 0: tipPercent = 20
            case 1: tipPercent = 25
            case 2: tipPercent = 30
            case 3: tipPercent = 35
            default: tipPercent = 20
        }
        
        //only calculate if not changing percentage
        if !adjustPercentage {
            //if user deleted a digit divide by 10, otherwise multiply by 10
            billAmount = digitDeleted ? (billAmount / 10) : (billAmount * 10)
            
            //format the field with the new value
            if let formattedBill = currencyFormatter.string(from: billAmount as NSNumber) {
                billOutlet.text = formattedBill
            }
        }
        
        //calculate the tip and the total
        let tip = billAmount * tipPercent / 100
        let total = billAmount + tip
        
        //update the labels and move cursor to beginning of view
        tipLabel.text = currencyFormatter.string(from: tip as NSNumber)
        totalLabel.text = currencyFormatter.string(from: total as NSNumber)
        let newPosition = billOutlet.endOfDocument
        billOutlet.selectedTextRange = billOutlet.textRange(from: newPosition, to: newPosition)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //check if digit was deleted, count will be 0, set boolean as needed
        let textFieldCount = string.count
        digitDeleted = textFieldCount > 0 ? false : true
        
        //only allow one decimal in string
        let countdots = (textField.text?.components(separatedBy: ".").count)! - 1
        
        if countdots > 0 && string == "."
        {
            return false
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //hide the keyboard when the view background is tapped
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //view.endEditing(true)
        billOutlet.resignFirstResponder()
        super.touchesBegan(touches, with: event)
    }
    
}

