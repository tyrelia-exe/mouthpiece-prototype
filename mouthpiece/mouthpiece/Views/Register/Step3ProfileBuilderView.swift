import SwiftUI

struct Step3ProfileBuilderView: View {
    @Binding var isStudent: Bool
    @Binding var school: String
    @Binding var selectedSport: String
    @Binding var primaryPosition: String
    @Binding var secondaryPosition: String
    @Binding var primaryPlaystyle: String
    @Binding var secondaryPlaystyle: String
    var onComplete: () -> Void

    let sports = ["Basketball", "Soccer", "Baseball"]
    let positions = ["Point Guard", "Shooting Guard", "Forward", "Center"]
    let playstyles = ["Offensive", "Defensive", "Aggressive", "Strategic"]
    var playstyleTag: String {
           "\(primaryPlaystyle) \(secondaryPlaystyle) \(primaryPosition)"
       }
    var body: some View {
        VStack(spacing: 20) {
            Text("Build Your Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Toggle("Are you a student?", isOn: $isStudent)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)

            if isStudent {
                CustomTextField(placeholder: "School Name", text: $school)
            }

            VStack(spacing: 15) {
                CustomPicker(placeholder:"Sport", selection: $selectedSport, options: sports)
                CustomPicker(placeholder:"Primary Position", selection: $primaryPosition, options: positions)
                CustomPicker(placeholder:"Secondary Position", selection: $secondaryPosition, options: positions)
                CustomPicker(placeholder:"Primary Playstyle", selection: $primaryPlaystyle, options: playstyles)
                CustomPicker(placeholder:"Secondary Playstyle", selection: $secondaryPlaystyle, options: playstyles)
            }

            Button(action: onComplete) {
                Text("Finish")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
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

struct CustomPicker: View {
    var placeholder: String
    @Binding var selection: String
    var options: [String]

    var body: some View {
        Picker(placeholder, selection: $selection) {
            ForEach(options, id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(MenuPickerStyle())
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(10)
        .foregroundColor(.white)
        .shadow(radius: 5)
    }
}
