//
//  NSFetchedResultsController+ECAdditions.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 05/04/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import Foundation
import CoreData

extension NSFetchedResultsController {
    func ec_performFetch() {
        do {
            try self.performFetch()
        } catch {
            let nserror = error as NSError
            NSLog("Error performing fetch \(nserror), \(nserror.userInfo)")
        }
    }
}