//
//  ParentView.swift
//  Stemma
//
//  Created by Michal Soukup on 05.04.2021.
//

import SwiftUI

struct Portrait: View {
    @State var generation: Generation = Generation.Parent
    @Binding var person: Person
    
    var body: some View {
        if person.portrait != nil {
            Image(nsImage: NSImage(data: person.portrait!)!)
                .resizable()
                .scaledToFill()
                .frame(width: self.generation == Generation.Parent ? 100 : self.generation == Generation.Grandparent ? 80 : 60, height: self.generation == Generation.Parent ? 100 : self.generation == Generation.Grandparent ? 80 : 60)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
                .offset(x: person.gender == Gender.Male ? 2 : -2, y: 4)
        } else {
            Image(person.gender == Gender.Male ? "ManAvatar" : "WomanAvatar")
            .resizable()
            .frame(width: self.generation == Generation.Parent ? 100 : self.generation == Generation.Grandparent ? 80 : 60, height: self.generation == Generation.Parent ? 100 : self.generation == Generation.Grandparent ? 80 : 60)
            .scaledToFit()
            .background(Color.white)
            .clipShape(Circle())
            .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
            .offset(x: person.gender == Gender.Male ? 2 : -2, y: 4)
        }
    }
}

struct PersonView: View {
    @State var generation: Generation = Generation.Parent
    @Binding var person: Person
    @State var action: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 2) {
            Button(action: self.action) {
                Circle()
                    .frame(width: self.generation == Generation.Parent ? 120 : self.generation == Generation.Grandparent ? 100 : 80, height: self.generation == Generation.Parent ? 120 : self.generation == Generation.Grandparent ? 100 : 80)
                    .foregroundColor(Color.white)
                    .overlay(
                        Circle()
                            .frame(width: self.generation == Generation.Parent ? 115 : self.generation == Generation.Grandparent ? 95 : 75, height: self.generation == Generation.Parent ? 115 : self.generation == Generation.Grandparent ? 95 : 75)
                            .foregroundColor(person.gender == Gender.Male ? Color("MaleColor") : Color("FemaleColor"))
                            .overlay(
                                Portrait(generation: generation, person: $person)
                            )
                    )
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 5)
            
            Text(ShowName(name: person.name, surname: person.surname))
                .font(.system(size: 12))
                .bold()
                .lineLimit(2)
                .multilineTextAlignment(.center)
            if generation != Generation.Child {
                Text(ShowDate(date: person.birthday)).font(.system(size: 10))
                Text(ShowDate(date: person.died)).font(.system(size: 10))
                Text(ShowBirthplace(place: person.birthplace, country: person.birthplaceCountry))
                    .font(.system(size: 10))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(
            width: self.generation == Generation.Parent ? 140 : self.generation == Generation.Grandparent ? 120 : 100,
            height: self.generation == Generation.Parent ? 220 : self.generation == Generation.Grandparent ? 200 : 130,
            alignment: .top
        )
    }
}

struct PersonView_PreviewsMale: PreviewProvider {
    static var previews: some View {
        PersonView(generation: Generation.Grandparent, person: .constant(Person(gender: Gender.Male)))
    }
}

struct PersonView_PreviewsFemale: PreviewProvider {
    static var previews: some View {
        PersonView(person: .constant(Person()))
    }
}

struct PersonView_PreviewsChild: PreviewProvider {
    static var previews: some View {
        PersonView(generation: Generation.Child, person: .constant(Person(gender: Gender.Female, name: "Ladislava Soukupová")))
    }
}
