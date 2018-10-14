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
import Contacts

var personName = ""
var personEmail = ""
var personAddress = ""
var personPhone = ""
var subject = "Follow Up"
var textBody = "Dear %n,\n\nHow are you? \n\nIt was so great to meet you at the event\n\n %ps"
var personCustom = ""
var personCalendy = ""
var personLocation = ""
var personEvent = ""

var colorInteger = 0

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
    @IBOutlet weak var customMessage: UITextView!
    
    var store: CNContactStore!
    
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
        
        store = CNContactStore()
        checkContactsAccess()
    }
    
    private func checkContactsAccess() {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        // Update our UI if the user has granted access to their Contacts
        case .authorized:
            self.accessGrantedForContacts()
            
        // Prompt the user for access to Contacts if there is no definitive answer
        case .notDetermined :
            self.requestContactsAccess()
            
        // Display a message if the user has denied or restricted access to Contacts
        case .denied,
             .restricted:
            let alert = UIAlertController(title: "Privacy Warning!",
                                          message: "Permission was not granted for Contacts.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func requestContactsAccess() {
        store.requestAccess(for: .contacts) {granted, error in
            if granted {
                DispatchQueue.main.async {
                    self.accessGrantedForContacts()
                    return
                }
            }
        }
    }
    
    // This method is called when the user has granted access to their address book data.
    private func accessGrantedForContacts() {
        //Update UI for grated state.
        //...
        print("access granted for contacts!")
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
            self.customMessage.text = personCustom
            
            
        })
        
    }
  
    
    @IBAction func saveContact(_ sender: Any) {
        personName = textName.text!
        personEmail = textEmail.text!
        personPhone = textPhoneNumber.text!
        personAddress = textAddress.text!
        personCustom = customMessage.text!
        print ("NAME " + personName)
        print ("EMAIL " + personEmail)
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
        
        let dateString = dateFormatter.string(from: date)
        
        do{
            let contact = CNMutableContact()
            contact.givenName = String(personName.split(separator: " ")[0])
            contact.familyName = String(personName.split(separator: " ")[1])
            contact.phoneNumbers = [CNLabeledValue(
                label:CNLabelPhoneNumberiPhone,
                value:CNPhoneNumber(stringValue:personPhone)),
                                    CNLabeledValue(
                                        label:CNLabelPhoneNumberiPhone,
                                        value:CNPhoneNumber(stringValue:personPhone))]
            
            let workEmail = CNLabeledValue(label:CNLabelWork, value:personEmail as NSString)
            contact.emailAddresses = [workEmail]
            
            let saveRequest = CNSaveRequest()
            saveRequest.add(contact, toContainerWithIdentifier:nil)
            try store.execute(saveRequest)
            print("saved")
        }catch{
            print("error")
        }
        
        var contact = Interest(title:(personName + "\n"  +  personEmail + "\n" + personPhone + "\n" +  personAddress + "\n\n" + dateString))
        
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

    
    @IBAction func sendEmail(_ sender: twoViewController) {
        //twoViewController().viewWillDisappear(true)
//            subject = twoViewController.subjectTextEnvoy
//            textBodyRaw = twoViewController.bodyTextEnvoy
        personName = textName.text!
        personEmail = textEmail.text!
        personPhone = textPhoneNumber.text!
        personAddress = textAddress.text!
        personCustom = customMessage.text!
        print ("NAME " + personName)
        print ("EMAIL " + personEmail)
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
        
        let dateString = dateFormatter.string(from: date)
        
        
        var contact = Interest(title:(personName + "\n"  +  personEmail + "\n" + personPhone + "\n" +  personAddress + "\n\n" + dateString))
        
        do {
            try Disk.append(contact, to: "contacts.json", in: .caches)
        } catch {
            print("failed to save")
        }
        
        carouselList.append(contact)
        
        textBody = parseBody(text: textBodyRaw)
//            //bodyText.text = textBody
        print("Raw: \(textBody)")
        let mailComposeViewController = configureMailController(email: personEmail, subject: subject, body: textBody)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
        
        
        
    }
    
    func configureMailController(email: String, subject: String, body: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        let subject = "Follow up"
        mailComposerVC.setToRecipients(["\(email)"])
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody(body, isHTML: false)
        
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
                print("index \(index) char: + \(char)")
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
    
    
    
}
