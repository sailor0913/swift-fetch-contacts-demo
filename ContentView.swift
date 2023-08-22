//
//  ContentView.swift
//  Fetch Contacts
//
//  Created by ryp on 2023/8/22.
//

import SwiftUI

struct ContactView: View {
    let contact: Contact
    
    var body: some View {
        HStack {
            Text(contact.firstName ?? "-")
            Text(contact.lastName ?? "-")
            Spacer()
            Text(contact.phoneNumber ?? "-")
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var coreDataStack: CoreDataStack
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Contact.lastName, ascending: true),
            NSSortDescriptor(keyPath: \Contact.firstName, ascending: false)
        ]
    )
    var contacts: FetchedResults<Contact>
    
    @State private var isAddContactPresented = false
    
    var body: some View {
        NavigationView {
            List(contacts, id:\.self) {
                ContactView(contact: $0)
            }
            .listStyle(.plain)
            .navigationBarTitle("Contact", displayMode: .inline)
            .navigationBarItems(
                trailing:
                    Button(action: {
                        isAddContactPresented.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
            )
        }
        .sheet(isPresented: $isAddContactPresented) {
            AddNewContact(isAddContactPresented: $isAddContactPresented)
                .environmentObject(coreDataStack)
        }
    }
}
    
struct AddNewContact: View {
    @EnvironmentObject var coreDataStack: CoreDataStack
    @Binding var isAddContactPresented: Bool
    @State var firstName = ""
    @State var lastName = ""
    @State var phoneNumber = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("first name", text: $firstName)
                TextField("last name", text: $lastName)
                TextField("phoneNumber", text: $phoneNumber)
                    .keyboardType(.phonePad)
                Spacer()
            }
            .padding(16)
            .navigationTitle("add a new contact")
            .navigationBarItems(
                trailing:
                    Button(action: saveContact, label: {
                        Image(systemName: "checkmark")
                            .font(.headline)
                    })
                    .disabled(isDisabled)
            )
        }
    }
    
    private var isDisabled: Bool {
        firstName.isEmpty || lastName.isEmpty || phoneNumber.isEmpty
    }
    
    private func saveContact() {
        coreDataStack.insertContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        isAddContactPresented.toggle()
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
