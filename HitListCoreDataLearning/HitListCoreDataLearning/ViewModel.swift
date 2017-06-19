//
//  ViewModel.swift
//  HitListCoreDataLearning
//
//  Created by Phetrungnapha, K. on 6/18/2560 BE.
//  Copyright © 2560 iTopStory. All rights reserved.
//

import Foundation

class ViewModel {
    
    private let person: Person
    
    init(person: Person) {
        self.person = person
    }
    
    var fullName: String {
        return "\(person.firstName) \(person.lastName)"
    }
    
    var personIdentifier: String {
        return person.identifier
    }
    
}

extension ViewModel {
    
    static func addPerson(firstName: String, lastName: String) -> ViewModel {
        let identifier = UUID().uuidString
        let person = Person(identifier: identifier, firstName: firstName, lastName: lastName)
        let personViewModel = ViewModel(person: person)
        
        if let personManagedObject = CoreDataService.shared.prepareManagedObject(entityName: "PersonManagedObject") {
            personManagedObject.setValue(identifier, forKey: "identifier")
            personManagedObject.setValue(firstName, forKey: "firstName")
            personManagedObject.setValue(lastName, forKey: "lastName")
            CoreDataService.shared.saveContext()
        }
        
        return personViewModel
    }
    
    static func fetchPerson(entityName: String) -> [ViewModel] {
        var viewModels = [ViewModel]()
        if let personManagedObjects = CoreDataService.shared.fetchObjects(entityName: entityName) {
            viewModels = personManagedObjects.map {
                let identifier = $0.value(forKeyPath: "identifier") as? String ?? ""
                let firstName = $0.value(forKeyPath: "firstName") as? String ?? ""
                let lastName = $0.value(forKeyPath: "lastName") as? String ?? ""
                let person = Person(identifier: identifier, firstName: firstName, lastName: lastName)
                return ViewModel(person: person)
            }
        }
        return viewModels
    }
    
    static func deletePerson(identifier: String, completion: (() -> ())) {
        CoreDataService.shared.deleteObject(entityName: "PersonManagedObject", identifier: identifier)
        completion()
    }
    
}