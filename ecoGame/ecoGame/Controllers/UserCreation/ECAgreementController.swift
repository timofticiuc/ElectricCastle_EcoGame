//
//  ECAgreementController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 07/06/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

protocol ECAgreementDelegate {
    func agreementController(ac: ECAgreementController, hasCompletedWithSelectedTerms selectedTerms:Bool)
}

class ECAgreementController: UIViewController {
    @IBOutlet private weak var agreedLabel:UILabel!
    var delegate:ECAgreementDelegate? = nil
    private var hasAgreed:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Mark: - Actions
    
    @IBAction func agreementSwitchHasToggled(agreementSwitch: UISwitch) {
        self.agreedLabel.text = (agreementSwitch.on ? "DA" : "NU")
        self.hasAgreed = agreementSwitch.on
    }
    
    @IBAction func doneAgreeing() {
        self.delegate?.agreementController(self, hasCompletedWithSelectedTerms: self.hasAgreed)
        self.dismissViewControllerAnimated(true) {
            
        }
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
