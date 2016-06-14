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
    lazy var readerVC = QRCodeReaderViewController(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
    var qrDict: Dictionary<String, AnyObject>? = nil
    var delegate: ECQRDelegate? = nil
    var scannedValue: String! = ""
    var targetActionCell: ECCategoryActionCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(self.qrDict!, options: NSJSONWritingOptions.PrettyPrinted)
            let JSONText = String(data: jsonData, encoding: NSASCIIStringEncoding)
            let qrCode = QRCode(JSONText!)
            self.qrImageView.image = qrCode?.image
        } catch {

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showQRScanner() {
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            self.scannedValue = result!.value
        }
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .FormSheet
        presentViewController(readerVC, animated: true, completion: nil)
    }
    
    @IBAction func doneAction() {
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
