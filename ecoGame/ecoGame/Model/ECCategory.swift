//
//  ECCategory.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 04/05/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit
import CoreData

@objc(ECCategory)
class ECCategory: ECSeralizableObject {
    @NSManaged var categoryName: String
    @NSManaged private var level: Int32
    var userLevel:ECConstants.ECCategoryLevel {
        get { return ECConstants.ECCategoryLevel(rawValue: level) ?? .Beginner }
        set { level = newValue.rawValue }
    }
    @NSManaged private var type: Int32
    var categoryType:ECConstants.Category {
        get { return ECConstants.Category(rawValue: type) ?? .Energy }
        set { type = newValue.rawValue
            self.categoryName = newValue.ec_enumName()
        }
    }
    @NSManaged private var scores: String
    var category_scores:[ECScore]!
    var categoryScores:[ECScore]! {
        get {
            
            if category_scores == nil {
                category_scores = [ECScore]()
                do {
                    let jsonScores = try NSJSONSerialization.JSONObjectWithData(scores.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableLeaves)
                    for jsonScore in (jsonScores as? [AnyObject])!  {
                        category_scores.append(ECScore(dictionary: jsonScore as! Dictionary<String, AnyObject>))
                    }
                } catch {
                    
                }
            }
            
            return category_scores
        }
        set {
            category_scores = nil

            do {
                var tempJSONScores = [Dictionary<String, AnyObject>]()
                
                for score:ECScore in newValue! {
                    tempJSONScores.append(["score" : score.score, "metadata" : score.metadata, "action" : score.action])
                }
                
                let jsonData = try NSJSONSerialization.dataWithJSONObject(tempJSONScores, options: NSJSONWritingOptions(rawValue: 0))
                self.scores = String(data: jsonData, encoding: NSUTF8StringEncoding)!
            } catch {
                self.scores = ""
            }
        }
    }
    
    override func serializationKeyForAttribute(attribute: String) -> String? {
        if attribute == "id" {
            return "category_name"
        } else if attribute == "level" {
            return "category_level"
        } else if attribute == "type" {
            return "category_type"
        } else if attribute == "scores" {
            return "category_scores"
        } else if attribute == "createdAt" {
            return nil
        } else if attribute == "categoryName" {
            return nil
        } else if attribute == "dirty" {
            return nil
        }
        
        return attribute
    }
    
    override func serializationValueForAttribute(attribute: String, andValue value:AnyObject) -> AnyObject? {
        if attribute == "level" ||
           attribute == "type" {
            let stringValue = value as! String
            
            return NSNumber(integer: Int(stringValue)!)
        }
        
        return value
    }
    
    private var _actions: [Dictionary<String, AnyObject>]!
    func actions() -> [Dictionary<String, AnyObject>] {
        if _actions == nil {
            switch self.categoryType {
            case .Energy:
                _actions = [[kTitle:"Play the Pedals Battle",
                    kDescription:"Instalatia de biciclete pe care pedaleaza 2-4 oameni, care produc energie stocata in baterii de la care se incarca telefoanele mobile",
                    kScore:ECConstants.ECCategoryLevel.Legend.ec_value(),
                    kAction:true,
                    kMultiplier:3],
                        [kTitle:"Calculate your carbon footprint",
                            kDescription:"Aplicatie tip quiz dezvoltata de Asociatia Generatia Verde cu are voluntarii MAINOI le calculeaza participantilor amprenta de carbon",
                            kScore:ECConstants.ECCategoryLevel.Angel.ec_value(),
                            kAction:true,
                            kMultiplier:2],
                        [kTitle:"Watch a video about energy at ECO Cinema",
                            kDescription:"In fiecare seara vor fi filme din toate categoriile, in sesiuni. Participarea la o sesiune pe tema ENERGY se puncteaza ca actiune. Voluntarii de la ECO CINEMA inscriu participantul in aplicatie la finalul sesiunii",
                            kScore:ECConstants.ECCategoryLevel.Guardian.ec_value(),
                            kMultiplier:1]]
            case .Water:
                _actions = [[kTitle:"Take 5 minutes showers",
                    kDescription:"In fiecare zi, sunt trimise patrule de voluntari la dusuri, in intervalele orare cand e aglomerat la showers. Voluntarii eco promoveaza cele doua actiuni, cronometreaza timpul petrecut in dus al participantului si il inscrie in concurs daca acesta face dus sub 5 minute",
                    kScore:ECConstants.ECCategoryLevel.Legend.ec_value(),
                    kMultiplier:3],
                        [kTitle:"Shower in two",
                            kDescription:"In fiecare zi, sunt trimise patrule de voluntari la dusuri, in intervalele orare cand e aglomerat la showers. Voluntarii eco promoveaza facutul dusului in doi si ii inscrie in concurs pe cei care o fac",
                            kScore:ECConstants.ECCategoryLevel.Angel.ec_value(),
                            kMultiplier:2],
                        [kTitle:"Watch a video about water at ECO Cinema",
                            kDescription:"In fiecare seara vor fi filme din toate categoriile, in sesiuni. Participarea la o sesiune pe tema APA se puncteaza ca actiune. Voluntarii de la ECO CINEMA inscriu participantul in aplicatie la finalul sesiunii.",
                            kScore:ECConstants.ECCategoryLevel.Guardian.ec_value(),
                            kMultiplier:1]]
            case .Transport:
                _actions = [[kTitle:"Come to the festival by bicycle",
                    kDescription:"Cei cu bicicleta ne arata tichetul de parcare. Ciclistii participanti la tura din Cluj sunt inregistrati de voluntarii MAINOI la sosire pe tablete.",
                    kScore:ECConstants.ECCategoryLevel.Legend.ec_value(),
                    kMultiplier:4],
                        [kTitle:"By train",
                            kDescription:"Cei cu trenul ne arata biletul de tren cu destinatia Cluj.",
                            kScore:ECConstants.ECCategoryLevel.Angel.ec_value(),
                            kAction:true,
                            kMultiplier:3],
                        [kTitle:"4 in a car",
                            kDescription:"Fie ne arata ca si-au folosit contul de carpooling, fie sunt parte din activarea propusa catre OMV",
                            kScore:ECConstants.ECCategoryLevel.Guardian.ec_value(),
                            kAction:true,
                            kMultiplier:2],
                        [kTitle:"By bus",
                            kDescription:"Cei cu autobuzul ne arata biletul de autobuz, cu destinatia Cluj sau Bontida.",
                            kScore:ECConstants.ECCategoryLevel.Guardian.ec_value(),
                            kAction:true,
                            kMultiplier:1],
                        [kTitle:"Transport video",
                            kDescription:"In fiecare seara vor fi filme din toate categoriile, in sesiuni. Participarea la o sesiune pe tema APA se puncteaza ca actiune. Voluntarii de la ECO CINEMA inscriu participantul in aplicatie la finalul sesiunii.",
                            kScore:ECConstants.ECCategoryLevel.Guardian.ec_value(),
                            kMultiplier:1]]
            case .Social:
                _actions = [[kTitle:"Play the Gas Twist",
                    kDescription:"Pe formatul jocului twister, câte 2-4 participanți, ghidați de un arbitru-voluntar MAINOI, învață structurile atomice ale gazelor cu efect de seră, precum și efectele acestora asupra mediului înconjurător",
                    kScore:ECConstants.ECCategoryLevel.Legend.ec_value(),
                    kMultiplier:3],
                        [kTitle:"Music Drives Change",
                            kDescription:"·Accepta provocarea artistilor in Music Drives Change leaat de actiuni pe care le poti face ca sa fii eco inainte si in timpul festivalului.",
                            kScore:ECConstants.ECCategoryLevel.Angel.ec_value(),
                            kMultiplier:2],
                        [kTitle:"ECO-match / ECO Quiz",
                            kDescription:"ECO Quiz este o aplicatie pe care am dezvoltat-o anul trecut sub forma de intrebari si raspunsuri din zona eco, si il vom folosi daca nu dezvoltam aplicatia ECO Match. ECO Match este o aplicatie care combina oamenii singuri, in functie de obiceiurile si preferintele lor eco.",
                            kScore:ECConstants.ECCategoryLevel.Guardian.ec_value(),
                            kAction:true,
                            kMultiplier:1],
                        [kTitle:"Social video",
                            kDescription:"In fiecare seara vor fi filme din toate categoriile, in sesiuni. Participarea la o sesiune pe tema APA se puncteaza ca actiune. Voluntarii de la ECO CINEMA inscriu participantul in aplicatie la finalul sesiunii.",
                            kScore:ECConstants.ECCategoryLevel.Guardian.ec_value(),
                            kMultiplier:1]]
            case .Waste:
                _actions = [[kTitle:"Collect 30 waste packages",
                    kDescription:"Pe desen va arata ce poti aduce la reciclat (doze de aluminiu, pachete de tigari, sticle de plastic). In functie de cate aduci, primesti punctajul corespunzator.",
                    kScore:ECConstants.ECCategoryLevel.Legend.ec_value(),
                    kMultiplier:3],
                        [kTitle:"Collect 20 waste packages",
                            kDescription:"Pe desen va arata ce poti aduce la reciclat (doze de aluminiu, pachete de tigari, sticle de plastic). In functie de cate aduci, primesti punctajul corespunzator.",
                            kScore:ECConstants.ECCategoryLevel.Angel.ec_value(),
                            kMultiplier:2],
                        [kTitle:"Collect 10 waste packages",
                            kDescription:"Pe desen va arata ce poti aduce la reciclat (doze de aluminiu, pachete de tigari, sticle de plastic). In functie de cate aduci, primesti punctajul corespunzator.",
                            kScore:ECConstants.ECCategoryLevel.Guardian.ec_value(),
                            kMultiplier:1],
                        [kTitle:"Waste video",
                            kDescription:"In fiecare seara vor fi filme din toate categoriile, in sesiuni. Participarea la o sesiune pe tema APA se puncteaza ca actiune. Voluntarii de la ECO CINEMA inscriu participantul in aplicatie la finalul sesiunii.",
                            kScore:ECConstants.ECCategoryLevel.Guardian.ec_value(),
                            kMultiplier:1]]
            default:
                _actions = [];
            }
            
        }
        
        return _actions
    }
    
    private var _defaultScores: [ECScore]!
    func defaultScores() -> [ECScore] {
        if _defaultScores == nil {
            switch self.categoryType {
            case .Energy:
                _defaultScores = [ECScore(dictionary: ["action":"Play the Pedals Battle "]),
                        ECScore(dictionary: ["action":"Calculate your carbon footprint"]),
                        ECScore(dictionary: ["action":"Watch a video about energy at the ECO Cinema"])]
            case .Water:
                _defaultScores = [ECScore(dictionary: ["action":"Take 5 minutes showers"]),
                        ECScore(dictionary: ["action":"Shower in two"]),
                        ECScore(dictionary: ["action":"Watch a video about water at the ECO Cinema"])]
            case .Transport:
                _defaultScores = [ECScore(dictionary: ["action":"Come to the festival by bicycle"]),
                        ECScore(dictionary: ["action":"By train"]),
                        ECScore(dictionary: ["action":"4 in a car"]),
                        ECScore(dictionary: ["action":"By bus"]),
                        ECScore(dictionary: ["action":"Transport Video"])]
            case .Social:
                _defaultScores = [ECScore(dictionary: ["action":"Play the Gas Twist"]),
                        ECScore(dictionary: ["action":"Music Drives Change"]),
                        ECScore(dictionary: ["action":"ECO Quiz"]),
                        ECScore(dictionary: ["action":"Social video"])]
            case .Waste:
                _defaultScores = [ECScore(dictionary: ["action":"Collect 30 waste packages"]),
                        ECScore(dictionary: ["action":"Collect 20 waste packages"]),
                        ECScore(dictionary: ["action":"Collect 10 waste packages"]),
                        ECScore(dictionary: ["action":"Waste video"])]
            default:
                _defaultScores = []
            }
        }
        return _defaultScores
    }
    
    func overallScore() -> Int {
        var _overallScore = 0
        for i in (0...self.categoryScores.count - 1) {
            _overallScore += self.categoryScores[i].score * self.actions()[i][kMultiplier]!.integerValue
        }
        return _overallScore
    }
    
    func scoreCompleteness() -> Int {
        var _scoreCompleteness = 0
        for i in (0...self.categoryScores.count - 1) {
            if self.categoryScores[i].score > 0 {
                _scoreCompleteness += 1
            }
        }
        return _scoreCompleteness
    }
    
    static func fetchRequestForCategories() -> NSFetchRequest {
        let fr: NSFetchRequest = NSFetchRequest(entityName: String(self))
        fr.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        return fr
    }
}
