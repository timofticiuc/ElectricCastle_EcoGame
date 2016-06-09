//
//  ECActionInputController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 09/06/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

protocol ECActionInputDelegate {
    func actionController(ac: ECActionInputController, hasInputedValue value: String)
}

class ECActionInputController: UIViewController {
    @IBOutlet weak var inputTextField: UITextField!
    var delegate: ECActionInputDelegate? = nil
    var targetActionCell: ECCategoryActionCell!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.inputTextField.attributedPlaceholder = NSAttributedString(string: "input value", attributes: [NSForegroundColorAttributeName : UIColor.lightGrayColor()])
        self.preferredContentSize = CGSizeMake(400, 200);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneAction() {
        self.delegate?.actionController(self, hasInputedValue: self.inputTextField.text!)
        self.dismissViewControllerAnimated(true, completion: nil)
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
