//
//  ViewController.swift
//  QR Universe
//
//  Created by Viraat Das on 10/13/18.
//  Copyright © 2018 Viraat Das. All rights reserved.
//

import UIKit
import FirebaseMLVision

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var textRecognizer: VisionTextRecognizer!
    var cloudTextRecognizer: VisionTextRecognizer!

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let vision = Vision.vision()
        //textRecognizer = vision.onDeviceTextRecognizer()
        cloudTextRecognizer = vision.cloudTextRecognizer()
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
            
            var finaltext = ""
            
            for block in features.blocks {
                for line in block.lines {
                    for element in line.elements {
                        finaltext += element.text + " "
                    }
                }
            }
            
            print(finaltext)
            // add final NLINGUISTICS
            
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
                    }
                }
            }
            
        })
        
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)

            
        }))
        
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
