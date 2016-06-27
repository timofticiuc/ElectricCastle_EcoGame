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
    var categoryScores:[ECScore]! {
        get {
            var tempScores:[ECScore] = [ECScore]()
            do {
                let jsonScores = try NSJSONSerialization.JSONObjectWithData(scores.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableLeaves)
                for jsonScore in (jsonScores as? [AnyObject])!  {
                    tempScores.append(ECScore(dictionary: jsonScore as! Dictionary<String, AnyObject>))
                }
            } catch {
                
            }
            
            return tempScores
        }
        set {
            do {
                var tempJSONScores = [Dictionary<String, AnyObject>]()
                
                for score:ECScore in newValue! {
                    tempJSONScores.append(["score" : score.score, "metadata" : score.metadata])
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
    
    func actions() -> [Dictionary<String, AnyObject>] {
        switch self.categoryType {
        case .Energy:
            return [[kTitle:"Play the Pedals Battle",
                    kDescription:"Instalatia de biciclete pe care pedaleaza 2-4 oameni, care produc energie stocata in baterii de la care se incarca telefoanele mobile",
                    kScore:ECConstants.ECCategoryLevel.Legend.ec_value(),
                    kAction:true],
                    [kTitle:"Calculate your carbon footprint",
                    kDescription:"Aplicatie tip quiz dezvoltata de Asociatia Generatia Verde cu are voluntarii MAINOI le calculeaza participantilor amprenta de carbon",
                    kScore:ECConstants.ECCategoryLevel.Angel.ec_value(),
                    kAction:true],
                    [kTitle:"Watch a video about energy at ECO Cinema",
                    kDescription:"In fiecare seara vor fi filme din toate categoriile, in sesiuni. Participarea la o sesiune pe tema ENERGY se puncteaza ca actiune. Voluntarii de la ECO CINEMA inscriu participantul in aplicatie la finalul sesiunii",
                    kScore:ECConstants.ECCategoryLevel.Guardian.ec_value()]]
        case .Water:
            return [[kTitle:"Take 5 minutes showers",
                    kDescription:"In fiecare zi, sunt trimise patrule de voluntari la dusuri, in intervalele orare cand e aglomerat la showers. Voluntarii eco promoveaza cele doua actiuni, cronometreaza timpul petrecut in dus al participantului si il inscrie in concurs daca acesta face dus sub 5 minute",
                    kScore:ECConstants.ECCategoryLevel.Legend.ec_value()],
                    [kTitle:"Shower in two",
                    kDescription:"In fiecare zi, sunt trimise patrule de voluntari la dusuri, in intervalele orare cand e aglomerat la showers. Voluntarii eco promoveaza facutul dusului in doi si ii inscrie in concurs pe cei care o fac",
                    kScore:ECConstants.ECCategoryLevel.Angel.ec_value()],
                    [kTitle:"Watch a video about water at ECO Cinema",
                    kDescription:"In fiecare seara vor fi filme din toate categoriile, in sesiuni. Participarea la o sesiune pe tema APA se puncteaza ca actiune. Voluntarii de la ECO CINEMA inscriu participantul in aplicatie la finalul sesiunii.",
                    kScore:ECConstants.ECCategoryLevel.Guardian.ec_value()]]
        case .Transport:
            return [[kTitle:"Come to the festival by bicycle",
                    kDescription:"Cei cu bicicleta ne arata tichetul de parcare. Ciclistii participanti la tura din Cluj sunt inregistrati de voluntarii MAINOI la sosire pe tablete.",
                    kScore:ECConstants.ECCategoryLevel.Legend.ec_value()],
                    [kTitle:"By train",
                    kDescription:"Cei cu trenul ne arata biletul de tren cu destinatia Cluj.",
                    kScore:ECConstants.ECCategoryLevel.Angel.ec_value(),
                    kAction:true],
                    [kTitle:"4 in a car",
                    kDescription:"Fie ne arata ca si-au folosit contul de carpooling, fie sunt parte din activarea propusa catre OMV",
                    kScore:ECConstants.ECCategoryLevel.Guardian.ec_value(),
                    kAction:true],
                    [kTitle:"By bus",
                    kDescription:"Cei cu autobuzul ne arata biletul de autobuz, cu destinatia Cluj sau Bontida.",
                    kScore:ECConstants.ECCategoryLevel.Guardian.ec_value(),
                    kAction:true]]
        case .Social:
            return [[kTitle:"Play the Gas Twist",
                    kDescription:"Pe formatul jocului twister, câte 2-4 participanți, ghidați de un arbitru-voluntar MAINOI, învață structurile atomice ale gazelor cu efect de seră, precum și efectele acestora asupra mediului înconjurător",
                    kScore:ECConstants.ECCategoryLevel.Legend.ec_value()],
                    [kTitle:"Music Drives Change",
                    kDescription:"·Accepta provocarea artistilor in Music Drives Change leaat de actiuni pe care le poti face ca sa fii eco inainte si in timpul festivalului.",
                    kScore:ECConstants.ECCategoryLevel.Angel.ec_value()],
                    [kTitle:"ECO-match / ECO Quiz",
                    kDescription:"ECO Quiz este o aplicatie pe care am dezvoltat-o anul trecut sub forma de intrebari si raspunsuri din zona eco, si il vom folosi daca nu dezvoltam aplicatia ECO Match. ECO Match este o aplicatie care combina oamenii singuri, in functie de obiceiurile si preferintele lor eco.",
                    kScore:ECConstants.ECCategoryLevel.Guardian.ec_value(),
                    kAction:true]]
        case .Waste:
            return [[kTitle:"Collect 30 waste packages",
                    kDescription:"Pe desen va arata ce poti aduce la reciclat (doze de aluminiu, pachete de tigari, sticle de plastic). In functie de cate aduci, primesti punctajul corespunzator.",
                    kScore:ECConstants.ECCategoryLevel.Legend.ec_value()],
                    [kTitle:"Collect 20 waste packages",
                    kDescription:"Pe desen va arata ce poti aduce la reciclat (doze de aluminiu, pachete de tigari, sticle de plastic). In functie de cate aduci, primesti punctajul corespunzator.",
                    kScore:ECConstants.ECCategoryLevel.Angel.ec_value()],
                    [kTitle:"Collect 10 waste packages",
                    kDescription:"Pe desen va arata ce poti aduce la reciclat (doze de aluminiu, pachete de tigari, sticle de plastic). In functie de cate aduci, primesti punctajul corespunzator.",
                    kScore:ECConstants.ECCategoryLevel.Guardian.ec_value()]]
        case .Count:
            break;
        }
        
        return [];
    }
    
    func defaultScores() -> [ECScore] {
        switch self.categoryType {
        case .Energy:
            return [ECScore(),ECScore(),ECScore()]
        case .Water:
            return [ECScore(),ECScore(),ECScore()]
        case .Transport:
            return [ECScore(),ECScore(),ECScore(),ECScore()]
        case .Social:
            return [ECScore(),ECScore(),ECScore()]
        case .Waste: 
            return [ECScore(),ECScore(),ECScore()]
        case .Count: 
            return []
        }
    }
    
    static func fetchRequestForCategories() -> NSFetchRequest {
        let fr: NSFetchRequest = NSFetchRequest(entityName: String(self))
        fr.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        return fr
    }
}
