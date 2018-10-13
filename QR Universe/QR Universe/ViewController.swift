//
//  ViewController.swift
//  QR Universe
//
//  Created by Viraat Das on 10/12/18.
//  Copyright © 2018 Viraat Das. All rights reserved.
//

import UIKit
//import Firebase


class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate{

    @IBOutlet weak var imagePicked: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    @IBAction func openCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    


}

