//
//  ViewController.swift
//  RandomNumberApp
//
//  Created by Al Amin on 26/02/18.
//  Copyright © 2018 Al Amin. All rights reserved.
//

import UIKit
import ChameleonFramework
import Foundation

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldMin: UITextField!
    @IBOutlet weak var textFieldMax: UITextField!
    @IBOutlet weak var labelResult: UILabel!
    @IBOutlet weak var labelNumbers: UILabel!
    @IBOutlet weak var btnRandom: DesignableButton!
    
    var titleString = ""
    var arrNumbers: [Int] = []
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         Do any additional setup after loading the view, typically from a nib.
        
        textFieldMin.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        textFieldMax.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        
        let gradientColor = GradientColor(.bottomToTop, frame: self.view.frame, colors: [UIColor.init(randomColorIn: [UIColor.blue,UIColor.purple,UIColor.flatPink,UIColor.orange])!, UIColor.init(randomColorIn: [UIColor.blue,UIColor.purple,UIColor.flatPink,UIColor.orange])!])
        self.view.backgroundColor = gradientColor
        
        if appDelegate.isKeyPresentInUserDefaults(key: "CurrentHistory") {
            
            self.arrNumbers = UserDefaults.standard.value(forKey: "CurrentHistory") as! [Int]
            
            if appDelegate.isKeyPresentInUserDefaults(key: "History") {
                if UserDefaults.standard.value(forKey: "History") as! Bool {
                    self.labelNumbers.isHidden = false
                    if self.arrNumbers.count > 0 {
                        self.labelNumbers.text = String(describing: self.arrNumbers)
                    }
                } else {
                    self.labelNumbers.isHidden = true
                }
            } else {
                self.labelNumbers.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if appDelegate.isKeyPresentInUserDefaults(key: "IncExc") {
            
            if appDelegate.isKeyPresentInUserDefaults(key: "Separate") {
                
                appDelegate.arrIncludeExcludeSeparate = UserDefaults.standard.value(forKey: "Separate") as! [Int]
            }
            
            if appDelegate.isKeyPresentInUserDefaults(key: "Range") {
                
                appDelegate.arrIncludeExcludeRange = UserDefaults.standard.value(forKey: "Range") as! [Int]
            }
        }
        
        if appDelegate.isKeyPresentInUserDefaults(key: "ClearHistory") {
            if UserDefaults.standard.value(forKey: "ClearHistory") as! Bool {
                self.arrNumbers = []
                self.labelNumbers.text = ""
                UserDefaults.standard.set(false, forKey: "ClearHistory")
            } else {
                
            }
        }
        
        if appDelegate.isKeyPresentInUserDefaults(key: "History") {
            if UserDefaults.standard.value(forKey: "History") as! Bool {
                self.labelNumbers.isHidden = false
                if self.arrNumbers.count > 0 {
                    self.labelNumbers.text = String(describing: self.arrNumbers)
                }
            } else {
                self.labelNumbers.isHidden = true
            }
        } else {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonGenerateRandom(_ sender: Any) {

        self.view.endEditing(true)
        
        let gradientColor = GradientColor(.bottomToTop, frame: self.view.frame, colors: [UIColor.init(randomColorIn: [UIColor.blue,UIColor.purple,UIColor.flatPink,UIColor.orange])!, UIColor.init(randomColorIn: [UIColor.blue,UIColor.purple,UIColor.flatPink,UIColor.orange])!])
        
        self.view.backgroundColor = gradientColor
        
        if (textFieldMin.text != "" && textFieldMax.text != ""){
            
            let min = UInt32(textFieldMin.text!)!
            let max = UInt32(textFieldMax.text!)!
            
            var arrRange: [Int] = []
            
            if min > max {
                for index in (Int(max) ... Int(min)) {
                    arrRange.append(index)
                }
            } else {
                for index in (Int(min) ... Int(max)) {
                    arrRange.append(index)
                }
            }
            
            if appDelegate.isKeyPresentInUserDefaults(key: "IncExc") {
                let strIncExc = UserDefaults.standard.value(forKey: "IncExc") as! String
                
                if strIncExc == "Include" {
                    arrRange.append(contentsOf: appDelegate.arrIncludeExcludeSeparate)
                    arrRange.append(contentsOf: appDelegate.arrIncludeExcludeRange)
                } else {
                    
                    for (_,value) in appDelegate.arrIncludeExcludeSeparate.enumerated() {
                        
                        if let ind = arrRange.index(where: {$0 == value}) {
                            arrRange.remove(at: ind)
                        }
                    }
                    
                    for (_,value) in appDelegate.arrIncludeExcludeRange.enumerated() {
                        
                        if let ind = arrRange.index(where: {$0 == value}) {
                            arrRange.remove(at: ind)
                        }
                    }
                }
            }
            
            let randomNumber = arrRange.randomItem()
            
            var isFound: Bool = false
            if appDelegate.isKeyPresentInUserDefaults(key: "Duplicate") {
                
                if appDelegate.isKeyPresentInUserDefaults(key: "History") {
                    if UserDefaults.standard.value(forKey: "History") as! Bool {
                        if UserDefaults.standard.value(forKey: "Duplicate") as! Bool {
                            labelResult.text = "\(String(describing: randomNumber!))"
                        } else {
                            
                            if arrNumbers.contains(randomNumber!) {
                                isFound = true
                                let alertController = UIAlertController(title: "Pretty Random", message: "Duplicate record found! Would you like to generate new?", preferredStyle:UIAlertControllerStyle.alert)
                                
                                alertController.addAction(UIAlertAction(title: "New", style: UIAlertActionStyle.default)
                                { action -> Void in
                                    self.buttonGenerateRandom(self.btnRandom)
                                    
                                    var arrTest: [Int] = []
                                    var arrTest2: [Int] = []
                                    
                                    for value in (min...max) {
                                        
                                        arrTest.append(Int(value))
                                        
                                        if value == max {
                                            arrTest.sort()
                                            arrTest2 = self.arrNumbers.removeDuplicates()
                                            arrTest2.sort()
                                            if arrTest.containsSameElements(as: arrTest2) {
                                                self.showAlert("You generate all numbers, Please clear history or change min and max numbers")
                                            }
                                        }
                                    }
                                })
                                
                                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
                                { action -> Void in
                                    
                                })
                                
                                DispatchQueue.main.async {
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            } else {
                                labelResult.text = "\(String(describing: randomNumber!))"
                            }
                        }
                    } else {
                        labelResult.text = "\(String(describing: randomNumber!))"
                    }
                } else {
                    if UserDefaults.standard.value(forKey: "Duplicate") as! Bool {
                        labelResult.text = "\(String(describing: randomNumber!))"
                    } else {
                        
                        if arrNumbers.contains(randomNumber!) {
                            isFound = true
                            let alertController = UIAlertController(title: "Pretty Random", message: "Duplicate record found! Would you like to generate new?", preferredStyle:UIAlertControllerStyle.alert)
                            
                            alertController.addAction(UIAlertAction(title: "New", style: UIAlertActionStyle.default)
                            { action -> Void in
                                self.buttonGenerateRandom(self.btnRandom)
                                
                                var arrTest: [Int] = []
                                
                                for value in (min...max) {
                                    
                                    arrTest.append(Int(value))
                                    
                                    if value == max {
                                        if arrTest.containsSameElements(as: self.arrNumbers) {
                                            self.showAlert("You generate all numbers, Please clear history or change min and max numbers")
                                        }
                                    }
                                }
                            })
                            
                            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
                            { action -> Void in
                                
                            })
                            
                            DispatchQueue.main.async {
                                self.present(alertController, animated: true, completion: nil)
                            }
                        } else {
                            labelResult.text = "\(String(describing: randomNumber!))"
                        }
                    }
                }
                
            } else {
                labelResult.text = "\(String(describing: randomNumber!))"
            }
            
            if !isFound {
                self.arrNumbers.append(randomNumber!)
                UserDefaults.standard.set(self.arrNumbers, forKey: "CurrentHistory")
            }
            
            if appDelegate.isKeyPresentInUserDefaults(key: "History") {
                if UserDefaults.standard.value(forKey: "History") as! Bool {
                    self.labelNumbers.isHidden = false
                    self.labelNumbers.text = String(describing: self.arrNumbers)
                } else {
                    self.labelNumbers.isHidden = true
                }
            }
        }
            
        else if (textFieldMin.text == "" && textFieldMax.text != ""){
            titleString = "Min value required"
            showAlert(titleString)
            
        }
        else if(textFieldMin.text != "" && textFieldMax.text == ""){
            titleString = "Max value required"
            showAlert(titleString)
        }
            
        else{
            titleString = "Min and Max values required"
            showAlert(titleString)
        }
    }
    
    @IBAction func btnSettingsClicked(_ sender: UIButton) {
        
        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        if self.textFieldMin.text == "" {
            settingsVC.strMin = "0"
        } else {
            settingsVC.strMin = self.textFieldMin.text!
        }
        if self.textFieldMax.text == "" {
            settingsVC.strMax = "0"
        } else {
            settingsVC.strMax = self.textFieldMax.text!
        }
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.buttonGenerateRandom(self.btnRandom)
        }
    }
    
    // Alert
    
    func showAlert(_ titleStr: String){
        let alert = UIAlertController(title: titleStr, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Hide the keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "SettingsVC" {
            let settingsVC = segue.destination as! SettingsVC
            if self.textFieldMin.text == "" {
                settingsVC.strMin = self.textFieldMin.text!
            } else {
                settingsVC.strMin = "0"
            }
            if self.textFieldMax.text == "" {
                settingsVC.strMax = self.textFieldMax.text!
            } else {
                settingsVC.strMax = "0"
            }
            
            
            print(settingsVC)
        }
    }
}

extension Array where Element: Comparable {
    
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
    
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
    
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
