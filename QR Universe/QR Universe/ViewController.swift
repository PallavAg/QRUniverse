//
//  ViewController.swift
//  QR Universe
//
//  Created by Viraat Das on 10/13/18.
//  Copyright © 2018 Viraat Das. All rights reserved.
//

import UIKit
import FirebaseMLVision
import MessageUI
import Disk

var personName = ""
//var personLastName = "Agarwal"
var personEmail = ""
var personAddress = ""
var personPhone = ""
var subject = "Follow Up"
var textBody = "Dear %f, how are you? %f"

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,MFMailComposeViewControllerDelegate {
    
    var textRecognizer: VisionTextRecognizer!
    var cloudTextRecognizer: VisionTextRecognizer!
    var carouselList = [Interest] ()

//    @IBOutlet weak var textName: UITextField!
//
//    @IBOutlet weak var textEmail: UITextField!
//    @IBOutlet weak var textPhoneNumber: UITextField!
    
    @IBOutlet weak var textName: UITextField!
    
    @IBOutlet weak var textEmail: UITextField!
    
    @IBOutlet weak var textPhoneNumber: UITextField!
    
    @IBOutlet weak var textAddress: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            self.carouselList = try Disk.retrieve("contacts.json", from: .caches, as: [Interest].self)
        } catch {
            print("loading list failed")
        }
        
        let vision = Vision.vision()
        //textRecognizer = vision.onDeviceTextRecognizer()
        cloudTextRecognizer = vision.cloudTextRecognizer()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
    }
    
//    func runTextRecognition(with image: UIImage) {
//        let visionImage = VisionImage(image: image)
//        textRecognizer.process(visionImage, completion: { (features, error) in
//            self.processResult(from: features, error: error)
//        })
//    }
    
    func runCloudTextRecognition(with image: UIImage) {
        let visionImage = VisionImage(image: image)
        cloudTextRecognizer.process(visionImage, completion: { (possibleFeatures, error) in
            guard let features = possibleFeatures else {
                return
            }
            
            var finaltext  = ""
            
            for block in features.blocks {
                for line in block.lines {
                    for element in line.elements {
                        finaltext += element.text + " "
                    }
                }
            }
            
            print(finaltext)
            //add name tag
            var card  = [String]()
            var fullName = ""
            
            let tagger = NSLinguisticTagger(tagSchemes: [.nameType], options: 0)
            tagger.string = finaltext
            
            let range = NSRange(location: 0, length: finaltext.utf16.count)
            
            let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
            let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
            
            tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, stop in
                if let tag = tag, tags.contains(tag) {
                    if let range = Range(tokenRange, in: finaltext) {
                        let name = finaltext[range]
                        print ("\(name): \(tag)")
                        if "\(tag)" == "NSLinguisticTag(_rawValue: PersonalName)" && fullName == ""{
                            fullName = ("\(name)")
                            
                        }
                        if "\(tag)" == "NSLinguisticTag(_rawValue: OrganizationName)"{
                            
                            print ("\(name): \(tag)")
                        }
                    }
                }
            }

            
            
            
            
            
            //add remaining tags (enmails, address, phone number)
            
           
            var email : String = ""
            var address : String = ""
            var phoneNumber : String = ""

            let charset = CharacterSet(charactersIn: "@") //later used to only add emails
            
            let testString : NSString = finaltext as NSString
            let types : NSTextCheckingResult.CheckingType = [.address , .date, .phoneNumber, .link ]
            let dataDetector = try? NSDataDetector(types: types.rawValue)
          
            
            dataDetector?.enumerateMatches(in: testString as String, options: [], range: NSMakeRange(0,testString.length), using: { (match, flags, _) in
                
                let matchString = testString.substring(with: (match?.range)!)
                
               if match?.resultType == .phoneNumber {
                if phoneNumber == "" {
                    phoneNumber = "\(matchString)"
                }
                //card.append("\(matchString)")
                    print("phoneNumber: \(matchString)")
                    
                    
                }else if match?.resultType == .address {
                if address == "" {
                    address = "\(matchString)"
                }
                //card.append("\(matchString)")
                    print("address: \(matchString)")
                    
                    
                }else if match?.resultType == .link {
                
                if "\(matchString)".rangeOfCharacter(from: charset) != nil {
                    email = "\(matchString)"
                }
                    //card.append("\(matchString)")
                    print("link: \(matchString)")
                    
                    
                }
                    
                else{
                    print("else \(matchString)")
                }
                
            })
            

            
            
//        var fullNameArr = split(fullName) {$0 == " "}
//        var firstName: String = fullNameArr[0]
//        var lastName: String = fullNameArr.count > 1 ? fullNameArr[1] : nil
//        card.append(firstName)
//        card.append(lastName)
        card.append(fullName)
        card.append(phoneNumber)
        card.append(address)
        card.append(email)
        
            
            personName = card[0]
        //var personLastName = "Agarwal"
            personEmail = card[3]
            personAddress = card[2]
            personPhone = card[1]
            
            self.textName.text = personName
            self.textEmail.text = personEmail
            self.textPhoneNumber.text = personPhone
            self.textAddress.text = personAddress
            
    
        
            

            
            
        })
        
    }
  
    
    @IBAction func saveContact(_ sender: Any) {
        personName = textName.text!
        personEmail = textEmail.text!
        personPhone = textPhoneNumber.text!
        personAddress = textAddress.text!
        print ("NAME " + personName)
        print ("EMAIL " + personEmail)
        
        var contact = Interest(title:(personName + " "  +  personEmail + " " + personPhone + " " +  personAddress))
        
        do {
            try Disk.append(contact, to: "contacts.json", in: .caches)
        } catch {
            print("failed to save")
        }
        
        carouselList.append(contact)
    }
    
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
                
                
            }))
            
        }
        else {
            print("Sorry cant take picture")
        }
       
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            
            self.present(imagePickerController, animated: true, completion: nil)
            
            
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        imageView.image = image
        
        runCloudTextRecognition(with: image)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)

    }
    
//Iplementing send email functionality
  
    
    
    //var textBody = "Dear \(personeName) \(personLastName),\n How %d are you doing? "
   // var textBody = "Dear %f, how are you? %f"

    
    @IBAction func sendEmail(_ sender: Any) {
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        var subject = "Follow up"
        mailComposerVC.setToRecipients(["\(personEmail)"])
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody(textBody, isHTML: false)
        
        return mailComposerVC
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
