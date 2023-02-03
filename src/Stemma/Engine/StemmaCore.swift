//
//  StemmaCore.swift
//  Stemma
//
//  Created by Michal Soukup on 28.03.2021.
//

import SwiftUI
import Foundation

class StemmaCore: ObservableObject {
    @Published var totalPersons: Int = 0
    @Published var manGrandfather: Person = Person()
    @Published var manGrandmother: Person = Person()
    @Published var man: Person = Person()
    @Published var womanGrandfather: Person = Person()
    @Published var womanGrandmother: Person = Person()
    @Published var woman: Person = Person()
    @Published var children: [Person] = []
    @Published var manSiblings: [Person] = []
    @Published var womanSiblings: [Person] = []
    @Published var wedding: Bool = true
    private var doc: StemmaDocument
    
    init() {
        // Create empty document
        self.doc = StemmaDocument()
    }
    
    func AssignDocument(document: StemmaDocument) {
        // Assigned document
        self.doc = document
        self.totalPersons = self.doc.data.persons.count
        self.LoadFirstCouple()
    }
    
    func ResetLoadedPersons() {
        self.manGrandfather = Person()
        self.manGrandmother = Person()
        self.man = Person()
        self.womanGrandfather = Person()
        self.womanGrandmother = Person()
        self.woman = Person()
        self.children = []
        self.manSiblings = []
        self.womanSiblings = []
    }
    
    func LoadSiblings(of: Person) {
        print("Load Siblings of: \(of.id!)")
        let siblings = self.doc.data.persons.filter { ($0.fatherId == of.fatherId ?? UUID() || $0.motherId == of.motherId ?? UUID()) && $0.id != of.id }
        switch of.gender! {
        case Gender.Male:
            self.manSiblings = siblings
            print("Loaded: \(self.manSiblings.count)")
        case Gender.Female:
            self.womanSiblings = siblings
            print("Loaded: \(self.womanSiblings.count)")
        }
    }

    // TODO: Children has to have both parents
    func LoadChildren(id: UUID) {
        let children = self.doc.data.persons.filter { $0.motherId == id }
        self.children = children.sorted(by: { (person1, person2) -> Bool in
            person1.birthday != nil && person2.birthday != nil ? person1.birthday! < person2.birthday! : true
        })
    }
    
    func LoadGrandparents(of: Gender, gender: Gender, id: UUID) {
        let person = self.doc.data.persons.first { $0.id == id }
        if person != nil {
            switch of {
            case Gender.Male:
                switch gender {
                case Gender.Male:
                    self.manGrandfather = person!
                case Gender.Female:
                    self.manGrandmother = person!
                }
            case Gender.Female:
                switch gender {
                case Gender.Male:
                    self.womanGrandfather = person!
                case Gender.Female:
                    self.womanGrandmother = person!
                }
            }
        }
    }
    
    func LoadPerson(id: UUID) {
        self.ResetLoadedPersons()
        let person = self.doc.data.persons.first { $0.id == id }
        if person != nil {
            var couple: Couple? = nil
            if person?.gender == Gender.Male {
                couple = self.doc.data.couples.first { $0.man == person?.id }
            } else {
                couple = self.doc.data.couples.first { $0.woman == person?.id }
            }
            
            if couple != nil {
                self.LoadCouple(couple: couple!)
            } else {
                if person?.gender == Gender.Male {
                    self.man = person!
                    if person?.fatherId != nil {
                        let gId = person?.fatherId
                        self.LoadGrandparents(of: Gender.Male, gender: Gender.Male, id: gId!)
                    }
                    if person?.motherId != nil {
                        let gId = person?.motherId
                        self.LoadGrandparents(of: Gender.Male, gender: Gender.Female, id: gId!)
                    }
                    self.LoadSiblings(of: person!)
                    self.LoadChildren(id: self.man.id!)
                } else {
                    self.woman = person!
                    if person?.fatherId != nil {
                        let gId = person?.fatherId
                        self.LoadGrandparents(of: Gender.Female, gender: Gender.Male, id: gId!)
                    }
                    if person?.motherId != nil {
                        let gId = person?.motherId
                        self.LoadGrandparents(of: Gender.Female, gender: Gender.Female, id: gId!)
                    }
                    self.LoadSiblings(of: person!)
                    self.LoadChildren(id: self.woman.id!)
                }
            }
        } else {
            print("Person: \(id) not found! Cannot be loaded.")
        }
    }
    
    func LoadCouple(couple: Couple) {
        let man = self.doc.data.persons.first { $0.id == couple.man }
        if man != nil {
            self.man = man!
            // Load grandparents of man
            if self.man.fatherId != nil {
                let gId = self.man.fatherId
                self.LoadGrandparents(of: Gender.Male, gender: Gender.Male, id: gId!)
            }
            if self.man.motherId != nil {
                let gId = self.man.motherId
                self.LoadGrandparents(of: Gender.Male, gender: Gender.Female, id: gId!)
            }
        }
        let woman = self.doc.data.persons.first { $0.id == couple.woman }
        if woman != nil {
            self.woman = woman!
            // Load grandparents of woman
            if self.woman.fatherId != nil {
                let gId = self.woman.fatherId
                self.LoadGrandparents(of: Gender.Female, gender: Gender.Male, id: gId!)
            }
            if self.woman.motherId != nil {
                let gId = self.woman.motherId
                self.LoadGrandparents(of: Gender.Female, gender: Gender.Female, id: gId!)
            }
            // Load children & siblings
            self.LoadChildren(id: self.woman.id!)
            self.LoadSiblings(of: self.man)
            self.LoadSiblings(of: self.woman)
        }
    }

    func LoadFirstPerson() {
        let person = self.doc.data.persons.first
        if person != nil {
            let id = person?.id
            self.LoadPerson(id: id!)
        }
    }
    
    func LoadFirstCouple() {
        let couple = self.doc.data.couples.first
        if couple != nil {
            self.LoadCouple(couple: couple!)
        } else {
            self.LoadFirstPerson()
        }
    }
    
    func GetDocument() -> StemmaDocument {
        return self.doc
    }
    
    func MergeParents() {
        if self.man.id != nil && self.woman.id != nil {
            let couple = self.doc.data.couples.first { $0.man == man.id && $0.woman == woman.id }
            if couple == nil {
                // Create couple
                self.doc.data.couples.append(Couple(man: self.man.id!, woman: self.woman.id!, married: false, date: nil, place: nil))
            }
        }
    }
    
    func MergeGrandparents() {
        // Grandparents of man
        if self.manGrandfather.id != nil && self.manGrandmother.id != nil {
            let couple = self.doc.data.couples.first { $0.man == self.manGrandfather.id && $0.woman == self.manGrandmother.id }
            if couple == nil {
                // Create couple
                self.doc.data.couples.append(Couple(man: self.manGrandfather.id!, woman: self.manGrandmother.id!, married: false, date: nil, place: nil))
            }
        }
        // Grandparents of woman
        if self.womanGrandfather.id != nil && self.womanGrandmother.id != nil {
            let couple = self.doc.data.couples.first { $0.man == self.womanGrandfather.id && $0.woman == self.womanGrandmother.id }
            if couple == nil {
                // Create couple
                self.doc.data.couples.append(Couple(man: self.womanGrandfather.id!, woman: self.womanGrandmother.id!, married: false, date: nil, place: nil))
            }
        }
    }
    
    func AddPerson(of: Gender, generation: Generation, person: Person) {
        if person.id != nil && person.gender != nil {
            self.doc.data.persons.append(person)
            self.totalPersons = self.doc.data.persons.count
            
            switch generation {
            case Generation.Child:
                // Handle post-adding of child
                self.LoadChildren(id: person.motherId!)
            case Generation.Parent:
                // Handle post-adding of parent
                switch person.gender! {
                case Gender.Male:
                    self.man = person
                    self.MergeParents()
                case Gender.Female:
                    self.woman = person
                    self.MergeParents()
                }
            case Generation.Grandparent:
                // Handle post-adding of grandparent
                switch of {
                case Gender.Male:
                    switch person.gender! {
                    case Gender.Male:
                        self.manGrandfather = person
                        self.MergeGrandparents()
                    case Gender.Female:
                        self.manGrandmother = person
                        self.MergeGrandparents()
                    }
                case Gender.Female:
                    switch person.gender! {
                    case Gender.Male:
                        self.womanGrandfather = person
                        self.MergeGrandparents()
                    case Gender.Female:
                        self.womanGrandmother = person
                        self.MergeGrandparents()
                    }
                }
            }
        }
    }
    
    func UpdatePerson(person: Person) {
        if person.id != nil {
            let index = self.doc.data.persons.firstIndex { $0.id == person.id }
            if index != nil {
                self.doc.data.persons[index!] = person
            }
            self.totalPersons = self.doc.data.persons.count
            if person.gender == Gender.Male {
                self.man = person
            } else {
                self.woman = person
            }
            self.MergeParents()
        }
    }
}
