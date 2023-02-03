//
//  PersonEditorView.swift
//  Stemma
//
//  Created by Michal Soukup on 29.03.2021.
//

import SwiftUI
import Cocoa

// Form Models
struct FormPerson {
    var of: Gender
    var generation: Generation
    var person: Person
    var genderOn: Bool
    var birthdayOn: Bool
    var diedOn: Bool
    var saved: Bool
}

struct PersonEditorView: View {
    @Binding var showModal: Bool
    @Binding var formPerson: FormPerson

    var body: some View {
        VStack {
            HStack {
                VStack {
                    Button("Open") {
                        selectImage()
                    }
                    if formPerson.person.portrait != nil {
                        Image(nsImage: NSImage(data: formPerson.person.portrait!)!)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(red: 239/255, green: 241/255, blue: 243/255, opacity: 1), lineWidth: 5))
                    } else {
                        Image(formPerson.person.gender == Gender.Male ? "ManAvatar" : "WomanAvatar")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color(red: 239/255, green: 241/255, blue: 243/255, opacity: 1), lineWidth: 5))
                    }
                }
                .frame(width: 100, height: 100)
                Text(
                    formPerson.person.name ?? "" != "" && formPerson.person.surname ?? "" != "" ? "\(formPerson.person.name!) \(formPerson.person.surname!)" :
                        formPerson.person.surname ?? "" != "" ? "\(formPerson.person.surname!)" :
                        formPerson.person.name ?? "" != "" ? "\(formPerson.person.name!)" : "Unknown"
                ).fontWeight(.bold).font(.system(size: 16)).lineLimit(2).padding(.leading, 5)
                Spacer()
            }
            .padding(.bottom, 10)
            Divider()
            HStack {
                Spacer()
                Text("Gender")
                Picker("", selection: $formPerson.person.gender.onNone(Gender.Male)) {
                    Text("Male").tag(Gender.Male)
                    Text("Female").tag(Gender.Female)
                }
                .frame(width: 200)
                .pickerStyle(SegmentedPickerStyle())
                .disabled(!formPerson.genderOn)
            }
            Group {
                HStack {
                    Spacer()
                    Text("Name")
                    TextField("", text: $formPerson.person.name.onNone(""))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                }
                HStack {
                    Spacer()
                    Text("Surname")
                    TextField("", text: $formPerson.person.surname.onNone(""))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                }
                if formPerson.person.gender == Gender.Female {
                    HStack {
                        Spacer()
                        Text("At Birth")
                        TextField("", text: $formPerson.person.surnameAtBirth.onNone(""))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 200)
                    }
                } else {
                    HStack {
                        Text("Hidden")
                        TextField("", text: $formPerson.person.surnameAtBirth.onNone(""))
                    }.hidden()
                }
                HStack {
                    Spacer()
                    Text("Birthday")
                    VStack(alignment: .trailing) {
                        Toggle("", isOn: $formPerson.birthdayOn).toggleStyle(SwitchToggleStyle())
                        DatePicker("", selection: $formPerson.person.birthday.onNone(Date()), displayedComponents: .date)
                            .frame(width: 200)
                            .disabled(!formPerson.birthdayOn)
                    }
                }
                HStack {
                    Spacer()
                    Text("Birthplace")
                    TextField("", text: $formPerson.person.birthplace.onNone(""))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                }
                HStack {
                    Spacer()
                    Text("Country")
                    TextField("", text: $formPerson.person.birthplaceCountry.onNone(""))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                }
                HStack {
                    Spacer()
                    Text("Died")
                    VStack(alignment: .trailing) {
                        Toggle("", isOn: $formPerson.diedOn).toggleStyle(SwitchToggleStyle())
                        DatePicker("", selection: $formPerson.person.died.onNone(Date()), displayedComponents: .date)
                            .frame(width: 200)
                            .disabled(!formPerson.diedOn)
                    }
                }
            }
            HStack(alignment: .center) {
                Spacer()
                Button("Cancel") {
                    self.showModal.toggle()
                    self.formPerson.saved = false
                }
                .keyboardShortcut(.cancelAction)
                Button("Save") {
                    self.showModal.toggle()
                    self.formPerson.saved = true
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding(.top, 20)
        }
        .padding()
        .onAppear {

        }
    }
    
    func selectImage() {
        var path: String = ""
        let dialog = NSOpenPanel()
        dialog.title                   = "Choose an image | Our Code World"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.allowsMultipleSelection = false
        dialog.canChooseDirectories = false
        dialog.canCreateDirectories = true
        dialog.allowedFileTypes        = ["png", "jpg", "jpeg", "gif"]
        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file

            if (result != nil) {
                path = result!.path
                print("Selected file: \(path)")
            
                do {
                    formPerson.person.portrait = try Data(contentsOf: dialog.url!)
                    var image: NSImage = NSImage(data: formPerson.person.portrait!)!
                    
                    //self.imageLoader.LoadImage(data: formPerson.person.portrait!)
                    
                    print("Before = width: \(image.size.width), height: \(image.size.height)")
                    image = image.resizeMaintainingAspectRatio(withSize: NSSize(width: 512, height: 512))!
                    print("After = width: \(image.size.width), height: \(image.size.height)")
                    formPerson.person.portrait = image.JPGRepresentation
                } catch {
                    print("")
                }
            }
            
        } else {
            // User clicked on "Cancel"
            print("Cancel")
            return
        }
    }
}
