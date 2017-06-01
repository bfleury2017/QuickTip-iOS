//
//  ViewController.swift
//  QuickTip
//
//  Created by Brian on 5/27/17.
//  Copyright © 2017 Fleury Mobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {


    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billOutlet: UITextField!
    @IBOutlet weak var tipSegment: UISegmentedControl!
    @IBOutlet weak var pickerView: UIPickerView!
    
    let percentage = ["20%","25%","30%","35%"]
    var numbers = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //execute tip calculation when text field value changes
        billOutlet.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func textFieldDidChange() {
        calculateTip()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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

    @IBAction func tipSegment(_ sender: Any) {
        calculateTip()
    }
    
    func calculateTip() {
        //get the current tip selection
        var tipPercent: Double = 20
        
        switch(tipSegment.selectedSegmentIndex) {
        case 0: tipPercent = 20
        case 1: tipPercent = 25
        case 2: tipPercent = 30
        case 3: tipPercent = 35
        default: tipPercent = 20
            
        }
        
//        switch(pickerView.selectedRow(inComponent: 0)) {
//        case 0: tipPercent = 20
//        case 1: tipPercent = 25
//        case 2: tipPercent = 30
//        case 3: tipPercent = 35
//        default: tipPercent = 20
//            
//        }
        
        //only calculate for size greater than 0
        let charCount = billOutlet.text?.characters.count

        if (charCount! > 0) {
            let numbers = Double(billOutlet.text!)!
            
            //var numberFromField = (NSString(string: currentString).doubleValue)/100
            //billOutlet.text = formatter.string(from: numbers)
            
            //billOutlet.text = String(format: "%.2f", numbers)

            let newBill = numbers//(numbers * 10) + numbers / 100
            //billOutlet.text = String(format: "%0.2f", newBill)
            
            let tip = newBill * tipPercent / 100
            let total = newBill + tip
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "en_US")
            
            tipLabel.text = formatter.string(from: tip as NSNumber)
            totalLabel.text = formatter.string(from: total as NSNumber)
        } else {
            tipLabel.text = "TIP"
            totalLabel.text = "TOTAL"
        }
    }
    
    
    //hide the keyboard when the view background is tapped
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //view.endEditing(true)
        billOutlet.resignFirstResponder()
        super.touchesBegan(touches, with: event)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return percentage.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return percentage[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        calculateTip()
    }
    
    //change the row height
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
}

