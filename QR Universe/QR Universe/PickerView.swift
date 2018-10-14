//
//  PickerView.swift
//  QR Universe
//
//  Created by Pallav Agarwal on 10/14/18.
//  Copyright © 2018 Viraat Das. All rights reserved.
//

import UIKit

var colorInt = 0

class PickerView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //Pickerview Code
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    @IBOutlet weak var label: UILabel!
    
    
    let colors = ["Orange", "Red", "Blue", "Green", "Yellow"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        label.text = colors[row]
        
        switch row {
        case 0:
            colorInt = 0
            
        case 1:
            colorInt = 1
        case 2:
            colorInt = 2
        case 3:
            colorInt = 3
        case 4:
            colorInt = 4
        default:
            colorInt = 5
        }
        
        
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
