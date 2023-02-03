//
//  ContentView.swift
//  Stemma
//
//  Created by Michal Soukup on 27.03.2021.
//

import SwiftUI

struct VisualEffectView: NSViewRepresentable
{
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView
    {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = NSVisualEffectView.State.active
        return visualEffectView
    }

    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context)
    {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
}

struct ContentView: View {
    @StateObject var core = StemmaCore()
    @Binding var document: StemmaDocument
    @State var moduleSelection: Set<Int> = [0]

    var body: some View {
        VStack {
            NavigationView {
                List(selection: self.$moduleSelection) {
                    NavigationLink(
                        destination: FamilyTreeView(document: $document).environmentObject(core),
                        label: {
                            HStack(alignment: .center) {
                                Label("Family Tree", systemImage: "leaf.fill")
                                Spacer()
                                ZStack {
                                    Text("\(String(core.totalPersons))")
                                        .font(Font.system(size: 12))
                                        .padding(.leading, 4)
                                        .padding(.trailing, 4)
                                        .foregroundColor(.white)
                                        .background(Color.accentColor)
                                        .cornerRadius(5)
                                }
                            }
                        }).tag(0)
                    NavigationLink(
                        destination: DocumentsView(document: $document).environmentObject(core),
                        label: {
                            Label("Documents", systemImage: "folder.fill")
                        }).tag(1)
                    NavigationLink(
                        destination: ChartsView(document: $document).environmentObject(core),
                        label: {
                            Label("Charts", systemImage: "flowchart.fill")
                        }).tag(2)
                }
                .listStyle(SidebarListStyle())
                .frame(minWidth: 200, idealWidth: 200, maxWidth: 400, maxHeight: .infinity, alignment: .center)

                // Destination placeholder
            }
            .id("Sidebar")
            .frame(minWidth: 200)
            .toolbar {
                ToolbarItem (placement: .automatic) {
                    Menu {
                        Button("Order Now", action: {
                            
                        })
                    } label: {
                        Label("Options", systemImage: "ellipsis.circle")
                    }
                }
                ToolbarItem (placement: .navigation) {
                    Button(action: {
                        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                    }) {
                        Image(systemName: "sidebar.left")
                    }
                }
                ToolbarItem (placement: .navigation) {
                    Button(action: {
                        print("Show previous person")
                    }) {
                        Image(systemName: "chevron.backward")
                    }
                }
                ToolbarItem (placement: .navigation) {
                    Button(action: {
                        print("Show next person")
                    }) {
                        Image(systemName: "chevron.forward")
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                    print("Delay ...")
                }
            }
        }
        .background(
            // Visual effect for main view
            VisualEffectView(material: NSVisualEffectView.Material.contentBackground, blendingMode: NSVisualEffectView.BlendingMode.withinWindow)
        )
        .frame(minWidth: 1024, minHeight: 700)
        .onAppear {
            // Assign oppened document into the Core Engine
            core.AssignDocument(document: document)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(StemmaDocument()))
    }
}
