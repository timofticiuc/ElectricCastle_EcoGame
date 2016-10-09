//
//  ECStatsController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 06/10/2016.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

class ECStatsController: UITableViewController {
    var users: [ECUser]!
    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var energyCountLabel: UILabel!
        @IBOutlet weak var energyActionLabel1: UILabel!
        @IBOutlet weak var energyActionLabel2: UILabel!
        @IBOutlet weak var energyActionLabel3: UILabel!

    @IBOutlet weak var wasteCountLabel: UILabel!
        @IBOutlet weak var wasteActionLabel1: UILabel!
        @IBOutlet weak var wasteActionLabel2: UILabel!
        @IBOutlet weak var wasteActionLabel3: UILabel!
        @IBOutlet weak var wasteActionLabel4: UILabel!
    
    @IBOutlet weak var waterCountLabel: UILabel!
        @IBOutlet weak var waterActionLabel1: UILabel!
        @IBOutlet weak var waterActionLabel2: UILabel!
        @IBOutlet weak var waterActionLabel3: UILabel!
    
    @IBOutlet weak var transportCountLabel: UILabel!
        @IBOutlet weak var transportActionLabel1: UILabel!
        @IBOutlet weak var transportActionLabel2: UILabel!
        @IBOutlet weak var transportActionLabel3: UILabel!
        @IBOutlet weak var transportActionLabel4: UILabel!
        @IBOutlet weak var transportActionLabel5: UILabel!
    
    @IBOutlet weak var socialCountLabel: UILabel!
        @IBOutlet weak var socialActionLabel1: UILabel!
        @IBOutlet weak var socialActionLabel2: UILabel!
        @IBOutlet weak var socialActionLabel3: UILabel!
        @IBOutlet weak var socialActionLabel4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.calculateStats()
    }
    
    func calculateStats() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            var energyCount = 0
            var energyActions = [0,0,0]
            var energyCarbon = 0.0
            
            var wasteCount = 0
            var wasteActions = [0,0,0,0]
            
            var waterCount = 0
            var waterActions = [0,0,0]
            
            var transportCount = 0
            var transportKM = 0
            var transportActions = [0,0,0,0,0]
            var transportActionsKM = [0,0,0,0]
            
            var socialCount = 0
            var socialActions = [0,0,0,0]
            
            for user in self.users {
                for categ in user.userCategories {
                    switch categ.categoryType {
                    case .Energy:
                        energyCount += (categ.overallScore() > 0 ? 1 : 0)
                        for i in 0...categ.categoryScores.count - 1 {
                            let score = categ.categoryScores[i]
                            energyActions[i] += (score.score > 0 ? 1 : 0)
                            if i == 1 {
                                let metadataValue = Double(score.metadata)
                                if metadataValue != nil {
                                    energyCarbon += metadataValue!
                                }
                            }
                        }
                        break
                        
                    case .Waste:
                        wasteCount += (categ.overallScore() > 0 ? 1 : 0)
                        for i in 0...categ.categoryScores.count - 1 {
                            let score = categ.categoryScores[i]
                            wasteActions[i] += (score.score > 0 ? 1 : 0)
                        }
                        break
                        
                    case .Water:
                        waterCount += (categ.overallScore() > 0 ? 1 : 0)
                        for i in 0...categ.categoryScores.count - 1 {
                            let score = categ.categoryScores[i]
                            waterActions[i] += (score.score > 0 ? 1 : 0)
                        }
                        break
                        
                    case .Transport:
                        transportCount += (categ.overallScore() > 0 ? 1 : 0)
                        for i in 0...categ.categoryScores.count - 1 {
                            let score = categ.categoryScores[i]
                            transportActions[i] += (score.score > 0 ? 1 : 0)
                            if i < categ.categoryScores.count - 1 {
                                let metadataValue = Int(score.metadata)
                                if metadataValue != nil {
                                    transportKM += metadataValue!
                                    transportActionsKM[i] += metadataValue!
                                }
                            }
                        }
                        break
                        
                    case .Social:
                        socialCount += (categ.overallScore() > 0 ? 1 : 0)
                        for i in 0...categ.categoryScores.count - 1 {
                            let score = categ.categoryScores[i]
                            socialActions[i] += (score.score > 0 ? 1 : 0)
                        }
                        break
                        
                    default:
                        break
                    }
                }
            }
                
            dispatch_async(dispatch_get_main_queue(), {
                self.spinner.hidden = true
                self.statusLabel.hidden = true
                
                self.totalCountLabel.text = String(self.users.count)
                self.energyCountLabel.text = String(energyCount)
                self.energyActionLabel1.text = String(energyActions[0])
                self.energyActionLabel2.text = String(energyActions[1]) + "(overall avg: " +
                    String(format:"%.2f", energyCarbon/Double(energyActions[1])) + ")"
                self.energyActionLabel3.text = String(energyActions[2])
                
                self.wasteCountLabel.text = String(wasteCount)
                self.wasteActionLabel1.text = String(wasteActions[0])
                self.wasteActionLabel2.text = String(wasteActions[1])
                self.wasteActionLabel3.text = String(wasteActions[2])
                self.wasteActionLabel4.text = String(wasteActions[3])
                
                self.waterCountLabel.text = String(waterCount)
                self.waterActionLabel1.text = String(waterActions[0])
                self.waterActionLabel2.text = String(waterActions[1])
                self.waterActionLabel3.text = String(waterActions[2])
                
                self.transportCountLabel.text = String(transportCount) + "(" + String(transportKM) + "km)"
                self.transportActionLabel1.text = String(transportActions[0])
                self.transportActionLabel2.text = String(transportActions[1]) + "(" + String(transportActionsKM[1]) + "km)"
                self.transportActionLabel3.text = String(transportActions[2]) + "(" + String(transportActionsKM[2]) + "km)"
                self.transportActionLabel4.text = String(transportActions[3]) + "(" + String(transportActionsKM[3]) + "km)"
                self.transportActionLabel5.text = String(transportActions[4])
                
                self.socialCountLabel.text = String(socialCount)
                self.socialActionLabel1.text = String(socialActions[0])
                self.socialActionLabel2.text = String(socialActions[1])
                self.socialActionLabel3.text = String(socialActions[2])
                self.socialActionLabel4.text = String(socialActions[3])
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
