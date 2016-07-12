//
//  ECQRController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 14/06/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit
import QRCode
import QRCodeReader
import AVFoundation

protocol ECQRDelegate {
    func qrController(qrc: ECQRController, hasScannedWithValue value: String)
}

class ECQRController: UIViewController {
    @IBOutlet private weak var qrImageView: UIImageView!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    lazy var readerVC = QRCodeReaderViewController(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showQRScanner() {
        self.qrImageView.hidden = true
        self.readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if result != nil {
                let values = result!.value.componentsSeparatedByString(";")
                if values.count == 3 {
                    let id = values[0]
                    let name = values[1]
                    let score = values[2]
                    
                    if id != String(self.qrDict!["id"]!) {
                        self.readerVC.dismissViewControllerAnimated(true, completion: nil)
                        return
                    }
                    
                    self.scoreLabel.text = "Generated power:\n" + score + " watts"
                    
                    let scoreDict = ["id":id,
                                     "name":name,
                                     "score":score]
                    
                    do {
                        let jsonData = try NSJSONSerialization.dataWithJSONObject(scoreDict, options: NSJSONWritingOptions.PrettyPrinted)
                        self.scannedValue = String(data: jsonData, encoding: NSASCIIStringEncoding)
                    } catch {
                        
                    }
                }
            }
            self.readerVC.dismissViewControllerAnimated(true, completion: nil)
        }
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .FormSheet
        presentViewController(readerVC, animated: true, completion: nil)
    }
    
    @IBAction func doneAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if self.scannedValue.characters.count == 0 {
            return
        }
        self.delegate?.qrController(self, hasScannedWithValue: self.scannedValue)
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
