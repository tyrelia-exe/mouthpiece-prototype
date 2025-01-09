//
//  Step3SchoolInfoView.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//

import SwiftUICore
import SwiftUI

import SwiftUI

struct Step3SchoolInfoView: View {
    @Binding var isStudent: Bool
    @Binding var school: String
    @Binding var grade: String
    var onNext: () -> Void

    let grades = ["9th", "10th", "11th", "12th", "College"]

    var body: some View {
        VStack(spacing: 20) {
            Text("School Information")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Toggle("Are you a student?", isOn: $isStudent)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.white)

            if isStudent {
                CustomTextField(placeholder: "School Name", text: $school)

                Picker("Grade", selection: $grade) {
                    ForEach(grades, id: \.self) { grade in
                        Text(grade)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.white)
            }

            Button(action: onNext) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .padding()
        .background(Color(#colorLiteral(red: 0.118, green: 0.078, blue: 1, alpha: 1))) // Matches the background color
        .ignoresSafeArea()
    }
}
