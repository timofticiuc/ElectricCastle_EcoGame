//
//  ECCarbonFootprintController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 09/06/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

protocol ECCarbonFootprintDelegate {
    func carbonFootprintController(cfc: ECCarbonFootprintController, hasInputedValue value: String)
}

class ECCarbonFootprintController: UIViewController, ECActionInputDelegate {
    @IBOutlet private weak var webView:UIWebView!
    var delegate: ECCarbonFootprintDelegate? = nil
    var targetActionCell: ECCategoryActionCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.generatiaverde.ro/co2/")!))
        self.preferredContentSize = CGSizeMake(800, 650);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneAction() {
        let actionVC: ECActionInputController = ECActionInputController.ec_createFromStoryboard() as! ECActionInputController
        actionVC.delegate = self
        actionVC.targetActionCell = self.targetActionCell
        
        actionVC.modalPresentationStyle = .FormSheet
        self.presentViewController(actionVC, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - ECActionInputDelegate
    
    func actionController(ac: ECActionInputController, hasInputedValue value: String) {
        if value.characters.count == 0 {
            return
        }
        self.delegate?.carbonFootprintController(self, hasInputedValue: value)
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
