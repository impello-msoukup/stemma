//
//  DocumentsView.swift
//  Bloodline
//
//  Created by Michal Soukup on 24.03.2021.
//

import SwiftUI

struct FamilyTreeView: View {
    @EnvironmentObject var core: StemmaCore
    @Binding var document: StemmaDocument
    @State private var showPersonEditor = false
    @State var formPerson = FormPerson(
        of: Gender.Male,
        generation: Generation.Parent,
        person: Person(),
        genderOn: false,
        birthdayOn: false,
        diedOn: false,
        saved: false)

    var body: some View {
        GeometryReader { canvas in
            // Lines
            ZStack {
                // Line between parents
                Path { path in
                    path.move(to: CGPoint(x: canvas.size.width / 2 - 150, y: canvas.size.height / 2 - 10))
                    path.addLine(to: CGPoint(x: canvas.size.width / 2 + 150, y: canvas.size.height / 2 - 10))
                }
                .stroke(style: StrokeStyle(lineWidth: 1,dash: [5]))
                .foregroundColor(.gray)
                .opacity(core.man.id != nil || core.woman.id != nil ? 1 : 0)
                .animation(.easeInOut, value: core.man.id != nil || core.woman.id != nil)

                // Line man to his parents
                Path { path in
                    path.move(to: CGPoint(x: canvas.size.width / 2 - 200, y: canvas.size.height / 2 - 60))
                    path.addLine(to: CGPoint(x: canvas.size.width / 2 - 200, y: canvas.size.height / 2 - 150))
                }
                .stroke(style: StrokeStyle(lineWidth: 1,dash: [5]))
                .foregroundColor(.gray)
                .opacity(core.man.id != nil ? 1 : 0)
                .animation(.easeInOut, value: core.man.id != nil)

                // Line under man's parents
                Path { path in
                    path.move(to: CGPoint(x: canvas.size.width / 2 - 300, y: canvas.size.height / 2 - 150))
                    path.addLine(to: CGPoint(x: canvas.size.width / 2 - 100, y: canvas.size.height / 2 - 150))
                }
                .stroke(style: StrokeStyle(lineWidth: 1,dash: [5]))
                .foregroundColor(.gray)
                .opacity(core.man.id != nil ? 1 : 0)
                .animation(.easeInOut, value: core.man.id != nil)

                // Line woman to her parents
                Path { path in
                    path.move(to: CGPoint(x: canvas.size.width / 2 + 200, y: canvas.size.height / 2 - 60))
                    path.addLine(to: CGPoint(x: canvas.size.width / 2 + 200, y: canvas.size.height / 2 - 150))
                }
                .stroke(style: StrokeStyle(lineWidth: 1,dash: [5]))
                .foregroundColor(.gray)
                .opacity(core.woman.id != nil ? 1 : 0)
                .animation(.easeInOut, value: core.woman.id != nil)

                // Line under woman's parents
                Path { path in
                    path.move(to: CGPoint(x: canvas.size.width / 2 + 300, y: canvas.size.height / 2 - 150))
                    path.addLine(to: CGPoint(x: canvas.size.width / 2 + 100, y: canvas.size.height / 2 - 150))
                }
                .stroke(style: StrokeStyle(lineWidth: 1,dash: [5]))
                .foregroundColor(.gray)
                .opacity(core.woman.id != nil ? 1 : 0)
                .animation(.easeInOut, value: core.woman.id != nil)

                // Line from parents to children
                Path { path in
                    path.move(to: CGPoint(x: canvas.size.width / 2, y: canvas.size.height / 2))
                    path.addLine(to: CGPoint(x: canvas.size.width / 2, y: canvas.size.height / 2 + 150))
                }
                .stroke(style: StrokeStyle(lineWidth: 1,dash: [5]))
                .foregroundColor(.gray)
                .opacity(core.man.id != nil && core.woman.id != nil ? 1 : 0)
                .animation(.easeInOut, value: core.man.id != nil && core.woman.id != nil)

                // Line above parent's children
                Path { path in
                    path.move(to: CGPoint(x: canvas.size.width / 2 - 300, y: canvas.size.height / 2 + 150))
                    path.addLine(to: CGPoint(x: canvas.size.width / 2 + 300, y: canvas.size.height / 2 + 150))
                }
                .stroke(style: StrokeStyle(lineWidth: 1,dash: [5]))
                .foregroundColor(.gray)
                .opacity(core.man.id != nil && core.woman.id != nil ? 1 : 0)
                .animation(.easeInOut, value: core.man.id != nil && core.woman.id != nil)
            }
            
            // Action button to add first person into family tree
            AddPersonView(action: {
                self.PersonEditorOpen(of: Gender.Male, generation: Generation.Parent)
            })
            .frame(width: 100, height: 100)
            .position(x: canvas.size.width / 2, y: canvas.size.height / 2)
            .opacity(core.totalPersons == 0 ? 1 : 0)

            // Parents
            ZStack {
                // Parents (add buttons)
                // Man add button
                AddPersonView(action: {
                    self.PersonEditorOpen(of: Gender.Male, generation: Generation.Parent)
                })
                .frame(width: 100, height: 100)
                .position(x: core.totalPersons > 0 && core.man.id == nil ? canvas.size.width / 2 - 200 : canvas.size.width / 2, y: canvas.size.height / 2)
                .opacity(core.totalPersons > 0 && core.man.id == nil ? 1 : 0)
                .animation(.easeInOut, value: core.totalPersons > 0 && core.man.id == nil)
                
                // Woman add button
                AddPersonView(action: {
                    self.PersonEditorOpen(of: Gender.Female, generation: Generation.Parent)
                })
                .frame(width: 100, height: 100)
                .position(x: core.totalPersons > 0 && core.woman.id == nil ? canvas.size.width / 2 + 200 : canvas.size.width / 2, y: canvas.size.height / 2)
                .opacity(core.totalPersons > 0 && core.woman.id == nil ? 1 : 0)
                .animation(.easeInOut, value: core.totalPersons > 0 && core.woman.id == nil)

                // Parents (preview buttons)
                // Man edit button
                PersonView(
                    generation: Generation.Parent,
                    person: $core.man,
                    action: {
                        self.PersonEditorOpen(of: Gender.Male, generation: Generation.Parent)
                })
                .frame(width: 150, height: 100)
                .position(x: canvas.size.width / 2 - 200, y: canvas.size.height / 2)
                .opacity(core.man.id != nil ? 1 : 0)
                .animation(.easeInOut, value: core.man.id != nil)
                
                // Woman edit button
                PersonView(
                    generation: Generation.Parent,
                    person: $core.woman,
                    action: {
                        self.PersonEditorOpen(of: Gender.Female, generation: Generation.Parent)
                })
                .frame(width: 150, height: 100)
                .position(x: canvas.size.width / 2 + 200, y: canvas.size.height / 2)
                .opacity(core.woman.id != nil ? 1 : 0)
                .animation(.easeInOut, value: core.woman.id != nil)
            }

            // Grandparents
            ZStack {
                // Man's grandparents (add buttons)
                // Man's grandfather add button
                AddPersonView(title: "Add Father", action: {
                    self.PersonEditorOpen(of: Gender.Male, generation: Generation.Grandparent)
                })
                .frame(width: 100, height: 100)
                .opacity(core.man.id != nil && core.manGrandfather.id == nil ? 1 : 0)
                .position(x: core.man.id != nil && core.manGrandfather.id == nil ? canvas.size.width / 2 - 280 : canvas.size.width / 2 - 200, y: canvas.size.height / 2 - 270)
                .animation(.easeInOut, value: core.man.id != nil && core.manGrandfather.id == nil)
                
                // Man's grandmother add button
                AddPersonView(title: "Add Mother", action: {
                    self.PersonEditorOpen(of: Gender.Male, generation: Generation.Grandparent)
                })
                .frame(width: 100, height: 100)
                .opacity(core.man.id != nil && core.manGrandmother.id == nil ? 1 : 0)
                .position(x: core.man.id != nil && core.manGrandmother.id == nil ? canvas.size.width / 2 - 120 : canvas.size.width / 2 - 200, y: canvas.size.height / 2 - 270)
                .animation(.easeInOut, value: core.man.id != nil && core.manGrandmother.id == nil)

                // Man's grandparents (preview buttons)
                // Man's grandfather edit button
                PersonView(
                    generation: Generation.Grandparent,
                    person: $core.manGrandfather,
                    action: {
                        core.LoadPerson(id: core.manGrandfather.id!)
                })
                .frame(width: 140, height: 100)
                .opacity(core.manGrandfather.id != nil ? 1 : 0)
                .position(x: canvas.size.width / 2 - 280, y: canvas.size.height / 2 - 250)
                .animation(.easeInOut, value: core.manGrandfather.id != nil)
                
                // Man's grandmother edit button
                PersonView(
                    generation: Generation.Grandparent,
                    person: $core.manGrandmother,
                    action: {
                        core.LoadPerson(id: core.manGrandmother.id!)
                })
                .frame(width: 140, height: 100)
                .opacity(core.manGrandmother.id != nil ? 1 : 0)
                .position(x: canvas.size.width / 2 - 120, y: canvas.size.height / 2 - 250)
                .animation(.easeInOut, value: core.manGrandmother.id != nil)

                // Woman's grandparents (add buttons)
                // Woman's grandfather add button
                AddPersonView(title: "Add Father", action: {
                    self.PersonEditorOpen(of: Gender.Female, generation: Generation.Grandparent)
                })
                .frame(width: 100, height: 100)
                .opacity(core.woman.id != nil && core.womanGrandfather.id == nil ? 1 : 0)
                .position(x: core.woman.id != nil && core.womanGrandfather.id == nil ? canvas.size.width / 2 + 120 : canvas.size.width / 2 + 200, y: canvas.size.height / 2 - 270)
                .animation(.easeInOut, value: core.woman.id != nil && core.womanGrandfather.id == nil)
                
                // Woman's grandmother add button
                AddPersonView(title: "Add Mother", action: {
                    self.PersonEditorOpen(of: Gender.Female, generation: Generation.Grandparent)
                })
                .frame(width: 100, height: 100)
                .opacity(core.woman.id != nil && core.womanGrandmother.id == nil ? 1 : 0)
                .position(x: core.woman.id != nil && core.womanGrandmother.id == nil ? canvas.size.width / 2 + 280 : canvas.size.width / 2 + 200, y: canvas.size.height / 2 - 270)
                .animation(.easeInOut, value: core.woman.id != nil && core.womanGrandmother.id == nil)

                // Woman's grandparents (preview buttons)
                // Woman's grandfather edit button
                PersonView(
                    generation: Generation.Grandparent,
                    person: $core.womanGrandfather,
                    action: {
                        core.LoadPerson(id: core.womanGrandfather.id!)
                })
                .frame(width: 140, height: 100)
                .opacity(core.womanGrandfather.id != nil ? 1 : 0)
                .position(x: canvas.size.width / 2 + 120, y: canvas.size.height / 2 - 250)
                .animation(.easeInOut, value: core.womanGrandfather.id != nil)
                
                // Woman's grandmother edit button
                PersonView(
                    generation: Generation.Grandparent,
                    person: $core.womanGrandmother,
                    action: {
                        core.LoadPerson(id: core.womanGrandmother.id!)
                })
                .frame(width: 140, height: 100)
                .opacity(core.womanGrandmother.id != nil ? 1 : 0)
                .position(x: canvas.size.width / 2 + 280, y: canvas.size.height / 2 - 250)
                .animation(.easeInOut, value: core.womanGrandmother.id != nil)
            }
            
            // Children (add button)
            ChildrenView(action: {
                    self.PersonEditorOpen(of: Gender.Male, generation: Generation.Child)
            }).environmentObject(core)
        }
        .sheet(isPresented: $showPersonEditor) {
            PersonEditorView(showModal: self.$showPersonEditor, formPerson: self.$formPerson.onChange(PersonEditorChanged))
        }
    }
    
    func PersonEditorOpen(of: Gender, generation: Generation) {
        switch generation {
        case Generation.Parent:
            // Add or Edit Parent
            formPerson.of = of
            formPerson.generation = generation
            formPerson.person = of == Gender.Male ? core.man : core.woman
            formPerson.person.gender = of
            formPerson.genderOn = core.man.id == nil && core.woman.id == nil ? true : false
            switch of {
            case Gender.Male:
                formPerson.birthdayOn = core.man.birthday != nil ? true : false
                formPerson.diedOn = core.man.died != nil ? true : false
            case Gender.Female:
                formPerson.birthdayOn = core.woman.birthday != nil ? true : false
                formPerson.diedOn = core.woman.died != nil ? true : false
            }
            self.showPersonEditor = true
        case Generation.Grandparent:
            // Add Grandparent
            formPerson.of = of
            formPerson.generation = generation
            formPerson.person = Person()
            switch of {
            case Gender.Male:
                formPerson.person.gender = core.manGrandfather.id == nil ? Gender.Male : Gender.Female
                formPerson.genderOn = core.manGrandfather.id == nil && core.manGrandmother.id == nil ? true : false
            case Gender.Female:
                formPerson.person.gender = core.womanGrandfather.id == nil ? Gender.Male : Gender.Female
                formPerson.genderOn = core.womanGrandfather.id == nil && core.womanGrandmother.id == nil ? true : false
            }
            formPerson.birthdayOn = false
            formPerson.diedOn = false
            self.showPersonEditor = true
        case Generation.Child:
            // Add Child
            formPerson.of = of
            formPerson.generation = generation
            formPerson.person = Person()
            formPerson.person.gender = Gender.Male
            formPerson.genderOn = true
            formPerson.birthdayOn = false
            formPerson.diedOn = false
            self.showPersonEditor = true
        }
    }

    func PersonEditorChanged(to value: FormPerson) {
        if (formPerson.saved) {
            formPerson.saved = false
            formPerson.person.surnameAtBirth = formPerson.person.gender == Gender.Female ? formPerson.person.surnameAtBirth : nil
            formPerson.person.birthday = formPerson.birthdayOn ? formPerson.person.birthday : nil
            formPerson.person.died = formPerson.diedOn ? formPerson.person.died : nil
            if formPerson.person.id == nil {
                formPerson.person.id = UUID()
                if formPerson.generation == Generation.Child {
                    if core.man.id != nil {
                        formPerson.person.fatherId = core.man.id
                    }
                    if core.woman.id != nil {
                        formPerson.person.motherId = core.woman.id
                    }
                }
                core.AddPerson(of: formPerson.of, generation: formPerson.generation, person: formPerson.person)
                if formPerson.generation == Generation.Grandparent {
                    // Connect parents with grandparents
                    switch formPerson.of {
                    case Gender.Male:
                        switch formPerson.person.gender! {
                        case Gender.Male:
                            core.man.fatherId = formPerson.person.id
                            core.UpdatePerson(person: core.man)
                        case Gender.Female:
                            core.man.motherId = formPerson.person.id
                            core.UpdatePerson(person: core.man)
                        }
                    case Gender.Female:
                        switch formPerson.person.gender! {
                        case Gender.Male:
                            core.woman.fatherId = formPerson.person.id
                            core.UpdatePerson(person: core.woman)
                        case Gender.Female:
                            core.woman.motherId = formPerson.person.id
                            core.UpdatePerson(person: core.woman)
                        }
                    }
                }
            } else {
                core.UpdatePerson(person: formPerson.person)
            }
            document = core.GetDocument()
        }
    }
}
