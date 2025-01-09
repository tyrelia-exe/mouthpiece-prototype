import SwiftUI

struct Step1PersonalInfoView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var username: String // New username field
    @Binding var dateOfBirth: Date
    @Binding var gender: String
    @Binding var email: String
    @Binding var password: String
    var onNext: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Mouthpiece!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            HStack(spacing: 15) {
                CustomTextField(placeholder: "First Name", text: $firstName)
                CustomTextField(placeholder:"Last Name", text: $lastName)
            }

            CustomTextField(placeholder:"Username", text: $username) // Username input

            CustomDatePicker(placeholder:"Date of Birth", date: $dateOfBirth)

            Picker("", selection: $gender) {
                Text("Male").tag("Male")
                Text("Female").tag("Female")
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(Color.white.opacity(0.2))
            .cornerRadius(10)

            CustomTextField(placeholder:"Email", text: $email)
            CustomSecureField(placeholder:"Password", text: $password)

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
        .background(Color.white.opacity(0.2))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(10)
            .foregroundColor(.white) // Makes user-entered text white
            .placeholder(when: text.isEmpty) {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.7)) // Placeholder text in white
                    .padding(.leading, 8)
            }
    }
}

extension View {
    func placeholder<Content: View>(when shouldShow: Bool, alignment: Alignment = .leading, @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}


struct CustomDatePicker: View {
    var placeholder: String
    @Binding var date: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(placeholder)
                .foregroundColor(.white.opacity(0.8))
                .font(.caption)

            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .shadow(radius: 5)
        }
    }
}


struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.6)) // White placeholder text
                    .padding(.leading, 8)
            }
            SecureField("", text: $text)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.white) // Text color
                .shadow(radius: 5)
        }
    }
}
