//
//  twoViewController.swift
//  SendEmail
//
//  Created by Pallav Agarwal on 10/13/18.
//  Copyright © 2018 Seemu. All rights reserved.
//

import UIKit

var textBodyRaw = "Dear %f, how are you? %f \nIt was so great to meet you at MHacks 11\n %c"
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
                } else if (potentialKey == true && char == "f") { //name %f
                    
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
            //textBody = parseBody(text: textBodyRaw)
            //bodyText.text = textBody
            self.view.endEditing(true)
            
//            twoViewController.subjectTextEnvoy = subjectText.text
//            twoViewController.bodyTextEnvoy = bodyText.text
            
        }
    }
    @IBAction func greetingsAction(_ sender: Any) {
        subjectText.text = "Great to Meet you"
        subject = subjectText.text
        
        bodyText.text = "Hi %f,\n\nIt was so great to meet you at event. \n\n%ps"
        textBodyRaw = bodyText.text
    }

    @IBAction func thanksAction(_ sender: Any) {
        subjectText.text = "Thank you!"
        subject = subjectText.text

        bodyText.text = "Hi %f,\n\nThank you very much for your help at event!\n\n%ps"
        textBodyRaw = bodyText.text

    }

    @IBAction func interviewAction(_ sender: Any) {
        subjectText.text = "Excited for this opportunity!"
        subject = subjectText.text


        bodyText.text = "Hi %f,\n\nThank you for this interview opportunity. \n\nI look forward to hearing from you. \n\n%ps"
        textBodyRaw = bodyText.text
    }

    @IBAction func checkInAction(_ sender: Any) {
        subjectText.text = "How have you been?"
        subject = subjectText.text
        
        bodyText.text = "Hi %f,\n\nIt has been so long since we last talked. It would be great to catch-up and grab coffee sometime soon!\n\n%ps"
        textBodyRaw = bodyText.text
    }
    
    
    
}


