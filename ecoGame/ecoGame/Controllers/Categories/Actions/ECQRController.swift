//
//  ECQRController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 14/06/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit
import AVFoundation

protocol ECQRDelegate {
    func qrController(qrc: ECQRController, hasScannedWithValue value: String)
}

class ECQRController: UIViewController {
    @IBOutlet private weak var qrImageView: UIImageView!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var inputField: UITextField!
    
    var qrDict: Dictionary<String, AnyObject>? = nil
    var delegate: ECQRDelegate? = nil
    var scannedValue: String! = ""
    var targetActionCell: ECCategoryActionCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let JSONText = String(self.qrDict!["id"]!) + ";" + String(self.qrDict!["name"]!)
        let qrCode = QRCode(JSONText)
        self.qrImageView.image = qrCode?.image
        self.preferredContentSize = CGSizeMake(400, 700);
        self.inputField.attributedPlaceholder = NSAttributedString(string: "input value", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGR)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func doneAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.delegate?.qrController(self, hasScannedWithValue: self.inputField.text!)
    }
    
    @IBAction func cancelAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
