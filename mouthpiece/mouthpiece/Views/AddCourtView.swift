//
//  AddCourtView.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/10/24.
//


import SwiftUI
import FirebaseFirestore

struct AddCourtView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var courtName = ""
    @State private var latitude = ""
    @State private var longitude = ""

    private let db = Firestore.firestore()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Court Details")) {
                    TextField("Court Name", text: $courtName)
                    TextField("Latitude", text: $latitude)
                        .keyboardType(.decimalPad)
                    TextField("Longitude", text: $longitude)
                        .keyboardType(.decimalPad)
                }

                Button(action: saveCourt) {
                    Text("Save Court")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Add Court")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func saveCourt() {
        guard let lat = Double(latitude), let lon = Double(longitude), !courtName.isEmpty else {
            print("Invalid input")
            return
        }

        db.collection("courts").addDocument(data: [
            "name": courtName,
            "latitude": lat,
            "longitude": lon,
            "rating": 0.0,
            "usersActive": 0
        ]) { error in
            if let error = error {
                print("Error saving court: \(error.localizedDescription)")
            } else {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
