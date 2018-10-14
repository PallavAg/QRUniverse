//
//  twoViewController.swift
//  SendEmail
//
//  Created by Pallav Agarwal on 10/13/18.
//  Copyright © 2018 Seemu. All rights reserved.
//

import UIKit

var textBodyRaw = "Dear %f, how are you? %f"
var textSubjectRaw = "follow up"

class twoViewController: UIViewController {
    
    @IBOutlet weak var subjectText: UITextView!
    @IBOutlet weak var bodyText: UITextView!
    var personName_2 = personName
    //var personLastName = "Agarwal"
    var personEmail_2 = personEmail
    var personAddress_2 = personAddress
    var personPhone_2 = personPhone
    

    
    
    func parseBody(text: String) -> String {
        var index1 = 0
        var potentialKey = false
        var str = NSMutableString()
        str.append(text)
        var check = "" as NSMutableString
        
        var counter = 0
        for (index, char) in text.enumerated() {
            
            if (char == "%"){
                counter+=1
            }
        }
        var looper = 0
        
        while looper < counter+1 {
            
            looper += 1
            
            for (index, char) in (str as String).enumerated() {
                if (char == "%") {
                    
                    index1 = index
                    
                    potentialKey = true
                } else if (potentialKey == true && char == "f") { //first name %f
                    
                    potentialKey = false
                    str.deleteCharacters(in: NSMakeRange(index1, 2))
                    str.insert(personName_2, at: index1)
                    
                    break;
                    
                }
//                else if (potentialKey == true && char == "l") { //last name %l
//                    
//                    potentialKey = false
//                    str.deleteCharacters(in: NSMakeRange(index1, 2))
//                    str.insert(personLastName, at: index1)
//                    break;
//                    
//                }
                else if (potentialKey == true && char == "a") { //Address %a
                    
                    potentialKey = false
                    str.deleteCharacters(in: NSMakeRange(index1, 2))
                    str.insert(personAddress_2, at: index1)
                    break;
                    
                } else if (potentialKey == true && char == "p") { //Phone %p
                    
                    potentialKey = false
                    str.deleteCharacters(in: NSMakeRange(index1, 2))
                    str.insert(personPhone_2, at: index1)
                    break;
                    
                } else {
                    potentialKey = false
                }
            }
        }
        
        return str as String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectText.text = subject
        print("Raw: \(textBodyRaw)")
        bodyText.text = textBodyRaw
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            subject = subjectText.text
            textBodyRaw = bodyText.text
            print("Raw: \(textBodyRaw)")
            textBody = parseBody(text: textBodyRaw)
            //bodyText.text = textBody
            print ("TEXTBODY")
            print (textBody)
            self.view.endEditing(true)
            
        }
    }
    
}
