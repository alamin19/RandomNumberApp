//
//  SettingsVC.swift
//  RandomNumberApp
//
//  Created by Al Amin on 01/03/18.
//  Copyright © 2018 Al Amin. All rights reserved.
//

import UIKit

let ACCEPTABLE_CHARACTERS_SINGLE = "0123456789,"
let ACCEPTABLE_CHARACTERS_RANGE = "0123456789-"

class SettingsVC: UIViewController {
    
    @IBOutlet weak var switch_Duplicate: UISwitch!
    @IBOutlet weak var switch_History: UISwitch!
    @IBOutlet weak var segmentIncludeExclude: UISegmentedControl!
    @IBOutlet weak var txtRange: UITextField!
    @IBOutlet weak var txtSeparate: UITextField!
    @IBOutlet weak var lblIncludeExclude: UILabel!
    @IBOutlet weak var height_Include_Exclude: NSLayoutConstraint!
    
    var strMin: String = "0"
    var strMax: String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appDelegate.isKeyPresentInUserDefaults(key: "Duplicate") {
            
            if UserDefaults.standard.value(forKey: "Duplicate") as! Bool {
                self.switch_Duplicate.isOn = true
            } else {
                self.switch_Duplicate.isOn = false
            }
        }
        
        if appDelegate.isKeyPresentInUserDefaults(key: "History") {
            
            if UserDefaults.standard.value(forKey: "History") as! Bool {
                self.switch_History.isOn = true
            } else {
                self.switch_History.isOn = false
            }
        }
        
        if appDelegate.isKeyPresentInUserDefaults(key: "IncExc") {
            
            if UserDefaults.standard.value(forKey: "IncExc") as! String == "Include" {
                self.segmentIncludeExclude.selectedSegmentIndex = 0
            } else {
                self.segmentIncludeExclude.selectedSegmentIndex = 1
            }
            
            if appDelegate.isKeyPresentInUserDefaults(key: "Separate") {
                appDelegate.arrIncludeExcludeSeparate = UserDefaults.standard.value(forKey: "Separate") as! [Int]
                let formattedArray = (appDelegate.arrIncludeExcludeSeparate.map{String($0)}).joined(separator: ",")
                self.txtSeparate.text = formattedArray
            }
            
            if appDelegate.isKeyPresentInUserDefaults(key: "Range") {
                appDelegate.arrIncludeExcludeRange = UserDefaults.standard.value(forKey: "Range") as! [Int]
                self.txtRange.text = "\(appDelegate.arrIncludeExcludeRange.first!)-\(appDelegate.arrIncludeExcludeRange.last!)"
            }
            
            UIView.animate(withDuration: 0.4, animations: {
                self.height_Include_Exclude.constant = 80.0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if txtSeparate.text != "" {
            let arrSeparate = self.txtSeparate.text?.components(separatedBy: ",")
            var arrInt: [Int] = []
            for (_, value) in (arrSeparate?.enumerated())! {
                arrInt.append(Int(value)!)
            }
            UserDefaults.standard.set(arrInt, forKey: "Separate")
        }
        
        if txtRange.text != "" && (txtRange.text?.contains("-"))! {
            let arrRange = self.txtRange.text?.components(separatedBy: "-")
            
            var arrRangeInt: [Int] = []
            
            if Int(arrRange![0])! > Int(arrRange![1])! {
                for index in (Int(arrRange![1])! ... Int(arrRange![0])!) {
                    arrRangeInt.append(index)
                }
            } else {
                for index in (Int(arrRange![0])! ... Int(arrRange![1])!) {
                    arrRangeInt.append(index)
                }
            }
            
            if arrRangeInt.count > 0 {
                UserDefaults.standard.set(arrRangeInt, forKey: "Range")
            }
        }
    }
    
    @IBAction func switchShowHistory(_ sender: UISwitch) {
        
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "History")
        } else {
            UserDefaults.standard.set(false, forKey: "History")
        }
    }
    
    @IBAction func switchDuplicateNumber(_ sender: UISwitch) {
        
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "Duplicate")
        } else {
            UserDefaults.standard.set(false, forKey: "Duplicate")
        }
    }
    
    @IBAction func btnClearHistoryClicked(_ sender: DesignableButton) {
        
        let alertController = UIAlertController(title: "Pretty Random", message: "Are you sure you want to clear history?", preferredStyle:UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default)
        { action -> Void in
            UserDefaults.standard.set(true, forKey: "ClearHistory")
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        { action -> Void in
            UserDefaults.standard.set(false, forKey: "ClearHistory")
        })
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        
        self.txtRange.text = ""
        self.txtSeparate.text = ""
        
        UserDefaults.standard.removeObject(forKey: "Separate")
        UserDefaults.standard.removeObject(forKey: "Range")
        
        if sender.selectedSegmentIndex == 0 {
            UserDefaults.standard.set("Include", forKey: "IncExc")
        } else {
            UserDefaults.standard.set("Exclude", forKey: "IncExc")
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            self.height_Include_Exclude.constant = 80.0
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnCrashClicked(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "Letf", sender: self)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SettingsVC: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtSeparate {
            if textField.text?.last == "," {
                textField.text?.removeLast()
                return true
            }
        } else {
            if textField.text?.last == "," || textField.text?.last == "-"{
                textField.text?.removeLast()
                return true
            }
            return true
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let length = textField.text!.length - range.length + string.length
        let inputStr = textField.text?.appending(string)
        
        if textField == txtSeparate {
            
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS_SINGLE).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            if (string != filtered) {
                showAlert("Pleae enter valid number")
                return false
            }
            
            if string == "" {
                return true
            }
            
            if string == "," && length != 1 {
                if length == 1 && string == "," {
                    showAlert("Pleaes enter proper value")
                    return false
                } else {
                    return true
                }
            } else {
                
                let inputArray = inputStr?.components(separatedBy: ",")
                let inputInt = Int(inputArray!.last!)
                
                if length == 1 && string == "," {
                    showAlert("Pleaes enter proper value")
                    return false
                } else if length == 0 {
                    return true
                }
                
                if inputStr?.last == "," {
                    if inputInt! >= 0 && inputInt! <= Int(strMax)! {
                        return true
                    } else {
                        if segmentIncludeExclude.selectedSegmentIndex == 0 {
                            return true
                        }
                        showAlert("Pleaes enter value between \(strMin) and \(strMax)")
                        return false
                    }
                } else {
                    if inputInt! >= 0 && inputInt! <= Int(strMax)! {
                        return true
                    } else {
                        if segmentIncludeExclude.selectedSegmentIndex == 0 {
                            return true
                        }
                        showAlert("Pleaes enter value between \(strMin) and \(strMax)")
                        return false
                    }
                }
            }
        } else {
            
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS_RANGE).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            if (string != filtered) {
                showAlert("Pleae enter valid number")
                return false
            }
            
            if string == "" {
                return true
            }
            
            let tok =  inputStr?.components(separatedBy:"-")
            if (tok?.count)! - 1 == 2 {
                showAlert("You just have to enter only signle range")
                return false
            }
            
            if (string == "-") && length != 1 {
                if length == 1 && string == "-" {
                    showAlert("Pleaes enter proper value")
                    return false
                } else {
                    if textField.text?.last == "-" {
                        showAlert("Pleaes enter proper value")
                        return false
                    } else {
                        return true
                    }
                    
                }
            } else {
                
                let inputArray = inputStr?.components(separatedBy: "-")
                let inputInt = Int(inputArray!.last!)
                
                if length == 1 && string == "-" {
                    showAlert("Pleaes enter proper value")
                    return false
                } else if length == 0 {
                    return true
                }
                
                if inputStr?.last == "-" {
                    if inputInt! >= 0 && inputInt! <= Int(strMax)! {
                        return true
                    } else {
                        if segmentIncludeExclude.selectedSegmentIndex == 0 {
                            return true
                        }
                        showAlert("Pleaes enter value between \(strMin) and \(strMax)")
                        return false
                    }
                } else {
                    if inputInt! >= 0 && inputInt! <= Int(strMax)! {
                        return true
                    } else {
                        if segmentIncludeExclude.selectedSegmentIndex == 0 {
                            return true
                        }
                        showAlert("Pleaes enter value between \(strMin) and \(strMax)")
                        return false
                    }
                }
            }
        }
    }
    
    func showAlert(_ titleStr: String){
        let alert = UIAlertController(title: titleStr, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

public extension String {
    public var isUsernameString : Bool{
        let invalidCharSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz._1234567890").inverted as CharacterSet
        let filtered : String = self.components(separatedBy: invalidCharSet).joined(separator: "")
        return (self == filtered)
    }
    public var isEmailString : Bool{
        let invalidCharSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz._1234567890@").inverted as CharacterSet
        let filtered : String = self.components(separatedBy: invalidCharSet).joined(separator: "")
        return (self == filtered)
    }
    public var isCharacter : Bool{
        let invalidCharSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz").inverted as CharacterSet
        let filtered : String = self.components(separatedBy: invalidCharSet).joined(separator: "")
        return (self == filtered)
    }
    
    public var isCharacterWithSpace : Bool{
        let invalidCharSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ").inverted as CharacterSet
        let filtered : String = self.components(separatedBy: invalidCharSet).joined(separator: "")
        return (self == filtered)
    }
    
    public var isNumber : Bool{
        let invalidCharSet = CharacterSet(charactersIn: "1234567890").inverted as CharacterSet
        let filtered : String = self.components(separatedBy: invalidCharSet).joined(separator: "")
        return (self == filtered)
    }
    public func widhtOfString (_ font : UIFont,height : CGFloat) -> CGFloat {
        let attributes = [NSAttributedStringKey.font:font]
        let rect = NSString(string: self).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude,height: height),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: attributes, context: nil)
        return  rect.size.width
    }
    
    public func heightOfString (_ font : UIFont,width : CGFloat) -> CGFloat {
        let attributes = [NSAttributedStringKey.font:font]
        let rect = NSString(string: self).boundingRect(
            with: CGSize(width:width ,height: CGFloat.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: attributes, context: nil)
        return  rect.size.height
    }
    public var intervalToDate : Date {
        return Date(timeIntervalSince1970: Double(self) != nil ? Double(self)! : 0)
    }
    public func toDate( _ format:String) -> Date? {
        let formatter:DateFormatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone =  TimeZone.ReferenceType.local
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    public var trim : String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    public var length : Int {
        return self.characters.count
    }
    public var ns: NSString {
        return self as NSString
    }
    public var pathExtension: String? {
        return ns.pathExtension
    }
    public var lastPathComponent: String? {
        return ns.lastPathComponent
    }
    
    //    public func contains(_ s: String) -> Bool
    //    {
    //        return self.range(of: s) != nil ? true : false
    //    }
    
    public func isMatch(_ regex: String, options: NSRegularExpression.Options) -> Bool
    {
        do {
            let exp = try NSRegularExpression(pattern: regex, options: options)
            let matchCount = exp.numberOfMatches(in: self, options: [], range: NSMakeRange(0, self.length))
            return matchCount > 0
        }
        catch {
            return false
        }
        
    }
    public func getMatches(_ regex: String, options: NSRegularExpression.Options) -> [NSTextCheckingResult]
    {
        do {
            let exp = try NSRegularExpression(pattern: regex, options: options)
            let matches = exp.matches(in: self, options: [], range: NSMakeRange(0, self.length))
            return matches as [NSTextCheckingResult]
        }
        catch {
            return [NSTextCheckingResult]()
        }
        
    }
}
extension String.Index{
    func successor(in string:String)->String.Index{
        return string.index(after: self)
    }
    
    func predecessor(in string:String)->String.Index{
        return string.index(before: self)
    }
    
    func advance(_ offset:Int,for string:String)->String.Index{
        return string.index(self, offsetBy: offset)
    }
}

