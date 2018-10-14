//
//  twoViewController.swift
//  SendEmail
//
//  Created by Pallav Agarwal on 10/13/18.
//  Copyright © 2018 Seemu. All rights reserved.
//

import UIKit

var textBodyRaw = "Dear %n,\n\nHow are you? \n\nIt was so great to meet you at the event\n\n %ps"
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
                } else if (potentialKey == true && char == "n") { //Contact Name %n
                    
                    potentialKey = false
                    str.deleteCharacters(in: NSMakeRange(index1, 2))
                    str.insert(personName, at: index1)
                    
                    break;
                    
                } else if (potentialKey == true && char == "a") { //Contact Address %a
                    
                    potentialKey = false
                    str.deleteCharacters(in: NSMakeRange(index1, 2))
                    str.insert(personAddress, at: index1)
                    
                    break;
                    
                } else if (potentialKey == true && char == "#") { //Phone %#
                    
                    potentialKey = false
                    str.deleteCharacters(in: NSMakeRange(index1, 2))
                    str.insert(personPhone, at: index1)
                    
                    break;
                    
                } else if (potentialKey == true && char == "p") { //Custom message %ps
                    
                    potentialKey = false
                    str.deleteCharacters(in: NSMakeRange(index1, 3))
                    str.insert(personCustom, at: index1)
                    
                    break;
                    
                } else if (potentialKey == true && char == "l") { //Location %loc
                    
                    potentialKey = false
                    str.deleteCharacters(in: NSMakeRange(index1, 4))
                    str.insert(personLocation, at: index1)
                    
                    break;
                    
                } else if (potentialKey == true && char == "e") { //Event %event
                    
                    potentialKey = false
                    str.deleteCharacters(in: NSMakeRange(index1, 6))
                    str.insert(personEvent, at: index1)
                    
                    break;
                    
                } else if (potentialKey == true && char == "c") { //Calendy link %cal
                    
                    potentialKey = false
                    str.deleteCharacters(in: NSMakeRange(index1, 4))
                    str.insert(personCalendy, at: index1)
                    
                    break;
                    
                } else {
                    potentialKey = false
                }
            }
        }
        
        return str as String
    }
    @IBOutlet weak var event: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var calendly: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectText.text = subject
        print("Raw: \(textBodyRaw)")
        bodyText.text = textBodyRaw
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        event.text = personEvent
        location.text = personLocation
        calendly.text = personCalendy
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            subject = subjectText.text
            textBodyRaw = bodyText.text
            //textBody = parseBody(text: textBodyRaw)
            //bodyText.text = textBody
            self.view.endEditing(true)
            
            personCalendy = calendly.text!
            personLocation = location.text!
            personEvent = event.text!
            
//            twoViewController.subjectTextEnvoy = subjectText.text
//            twoViewController.bodyTextEnvoy = bodyText.text
            
        }
    }
    @IBAction func greetingsAction(_ sender: Any) {
        subjectText.text = "Great to Meet you"
        subject = subjectText.text
        
        bodyText.text = "Hi %n,\n\nIt was so great to meet you at event. \n\n%ps"
        textBodyRaw = bodyText.text
    }

    @IBAction func thanksAction(_ sender: Any) {
        subjectText.text = "Thank you!"
        subject = subjectText.text

        bodyText.text = "Hi %n,\n\nThank you very much for your help at event!\n\n%ps"
        textBodyRaw = bodyText.text

    }

    @IBAction func interviewAction(_ sender: Any) {
        subjectText.text = "Excited for this opportunity!"
        subject = subjectText.text


        bodyText.text = "Hi %n,\n\nThank you for this interview opportunity at %loc. \n\nI look forward to seeing you at %event.\n\n%ps"
        textBodyRaw = bodyText.text
    }

    @IBAction func checkInAction(_ sender: Any) {
        subjectText.text = "How have you been?"
        subject = subjectText.text
        
        bodyText.text = "Hi %n,\n\nIt's Amulya. My number is 7656435624. It would be great to catch-up and grab coffee sometime soon! \n\nBy the way, is this the best number to reach you? %#\n\n%ps"
        textBodyRaw = bodyText.text
    }
    
    //Assign colors
 
    
    @IBAction func orangeAction(_ sender: Any) {
        colorInteger = 0
    }
    
    @IBAction func darkOrangeAction(_ sender: Any) {
        colorInteger = 1
    }
    
    @IBAction func greyAction(_ sender: Any) {
        colorInteger = 2
    }
    
    @IBAction func purpleAction(_ sender: Any) {
        colorInteger = 3
    }
    
    @IBAction func greenAction(_ sender: Any) {
        colorInteger = 4
    }
    
    @IBAction func tealAction(_ sender: Any) {
        colorInteger = 5
    }
    
}


