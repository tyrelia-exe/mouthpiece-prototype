//
//  Step4SportInfoView.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//

import SwiftUICore
import SwiftUI


struct Step4SportInfoView: View {
    @Binding var selectedSport: String
    @Binding var primaryPosition: String
    @Binding var secondaryPosition: String
    @Binding var primaryPlaystyle: String
    @Binding var secondaryPlaystyle: String
    @Binding var playstyleTag: String // Updated to @Binding
    var onNext: () -> Void

    let sports = ["Basketball", "Soccer", "Baseball"]
    let positions = ["Point Guard", "Shooting Guard", "Forward", "Center"]
    let playstyles = ["Shooting", "Finishing", "Playmaking", "Defense", "Rebounding"]

    var body: some View {
        VStack(spacing: 20) {
            Text("Select Your Sport")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineLimit(1) // Keep it on one line
                .minimumScaleFactor(0.5) // Scale down to half the size if needed

            // Sport Picker
                       ScrollablePicker(title: "Sport", selection: $selectedSport, options: sports)


            // Primary Position Picker
//                       Picker("Primary Position", selection: $primaryPosition) {
//                           ForEach(positions, id: \.self) { position in
//                               Text(position)
//                                   .lineLimit(2) // Prevent text from wrapping
//                                   .minimumScaleFactor(0.5) // Scale down long text
//                                   .frame(maxWidth: .infinity, alignment: .leading)
//                           }
//                       }
//                       .pickerStyle(SegmentedPickerStyle())
//                       .padding()
//                       .background(Color.white.opacity(0.2))
//                       .cornerRadius(10)
            // Primary Playstyle Dropdown
                        ScrollablePicker(title: "Primary Position", selection: $primaryPosition, options: positions)

            // Primary Playstyle Dropdown
                        ScrollablePicker(title: "Primary Playstyle", selection: $primaryPlaystyle, options: playstyles)

                        // Secondary Playstyle Dropdown
                        ScrollablePicker(title: "Secondary Playstyle", selection: $secondaryPlaystyle, options: playstyles)

                        // Display Playstyle Tag
                        Text("Playstyle Tag: \(playstyleTag)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.top, 20)
                            .lineLimit(1) // Keep it on one line
                            .minimumScaleFactor(0.75) // Scale down to half the size if needed

            // Next Button
            Button(action: {
                updatePlaystyleTag() // Update the playstyle tag
                onNext() // Trigger the next step in the flow
            }) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.top, 20)

            Spacer()
        }
        .padding()
        .background(Color(#colorLiteral(red: 0.118, green: 0.078, blue: 1, alpha: 1))) // Matches background
        .cornerRadius(15)
        .padding(.horizontal)
        .onChange(of: primaryPosition) { _ in updatePlaystyleTag() }
        .onChange(of: primaryPlaystyle) { _ in updatePlaystyleTag() }
        .onChange(of: secondaryPlaystyle) { _ in updatePlaystyleTag() }
    }

    private func updatePlaystyleTag() {
        playstyleTag = generatePlaystyleTag(
            primaryPosition: primaryPosition,
            primaryPlaystyle: primaryPlaystyle,
            secondaryPlaystyle: secondaryPlaystyle
        )
    }
}

func generatePlaystyleTag(
    primaryPosition: String,
    primaryPlaystyle: String,
    secondaryPlaystyle: String
) -> String {
    // Map primary positions to corresponding playstyle combinations
    let playstyleTags: [String: [String: [String: String]]] = [
        "Point Guard": [
            "Shooting": [
                "Shooting": "Sharpshooting Playmaker",
                "Finishing": "Scoring Guard",
                "Playmaking": "Shot-Creator",
                "Defense": "Two-Way Shooter",
                "Rebounding": "Stretch Floor General"
            ],
            "Finishing": [
                "Shooting": "Slashing Shot-Creator",
                "Finishing": "Relentless Scorer",
                "Playmaking": "Driving Playmaker",
                "Defense": "Two-Way Slasher",
                "Rebounding": "Slashing Rebounder"
            ],
            "Playmaking": [
                "Shooting": "Deep Range Playmaker",
                "Finishing": "Dynamic Finisher",
                "Playmaking": "Pure Playmaker",
                "Defense": "Two-Way Playmaker",
                "Rebounding": "Rebounding Playmaker"
            ],
            "Defense": [
                "Shooting": "Perimeter Lockdown",
                "Finishing": "Defensive Slasher",
                "Playmaking": "Defensive Playmaker",
                "Defense": "Pure Lockdown",
                "Rebounding": "Defensive Rebounder"
            ],
            "Rebounding": [
                "Shooting": "Stretch Rebounder",
                "Finishing": "Glass-Cleaning Slasher",
                "Playmaking": "Playmaking Glass Cleaner",
                "Defense": "Glass Lockdown",
                "Rebounding": "Pure Glass Cleaner"
            ]
        ],
        "Shooting Guard": [
            "Shooting": [
                "Shooting": "Sharpshooting Specialist",
                "Finishing": "Offensive Specialist",
                "Playmaking": "Scoring Facilitator",
                "Defense": "Two-Way Sniper",
                "Rebounding": "Stretch Wing"
            ],
            "Finishing": [
                "Shooting": "Slashing Shooter",
                "Finishing": "Athletic Scorer",
                "Playmaking": "Driving Facilitator",
                "Defense": "Two-Way Finisher",
                "Rebounding": "Athletic Rebounder"
            ],
            "Playmaking": [
                "Shooting": "Shot-Creator",
                "Finishing": "Driving Playmaker",
                "Playmaking": "Facilitating Guard",
                "Defense": "Two-Way Facilitator",
                "Rebounding": "Rebounding Playmaker"
            ],
            "Defense": [
                "Shooting": "Perimeter Defender",
                "Finishing": "Defensive Slasher",
                "Playmaking": "Defensive Facilitator",
                "Defense": "Pure Lockdown",
                "Rebounding": "Lockdown Rebounder"
            ],
            "Rebounding": [
                "Shooting": "Rebounding Shooter",
                "Finishing": "Glass-Cleaning Scorer",
                "Playmaking": "Playmaking Rebounder",
                "Defense": "Rebounding Defender",
                "Rebounding": "Glass Wing"
            ]
        ],
        "Forward": [
            "Shooting": [
                "Shooting": "Sharpshooting Forward",
                "Finishing": "Scoring Wing",
                "Playmaking": "Stretch Facilitator",
                "Defense": "Two-Way Stretch Forward",
                "Rebounding": "Stretch Glass Cleaner"
            ],
            "Finishing": [
                "Shooting": "Slashing Forward",
                "Finishing": "Athletic Wing",
                "Playmaking": "Driving Wing",
                "Defense": "Two-Way Slasher",
                "Rebounding": "Glass-Cleaning Scorer"
            ],
            "Playmaking": [
                "Shooting": "Stretch Playmaker",
                "Finishing": "Playmaking Slasher",
                "Playmaking": "Facilitating Wing",
                "Defense": "Defensive Facilitator",
                "Rebounding": "Glass Facilitator"
            ],
            "Defense": [
                "Shooting": "Two-Way Shooter",
                "Finishing": "Two-Way Slasher",
                "Playmaking": "Defensive Wing",
                "Defense": "Pure Lockdown",
                "Rebounding": "Defensive Glass Cleaner"
            ],
            "Rebounding": [
                "Shooting": "Stretch Glass Cleaner",
                "Finishing": "Athletic Rebounder",
                "Playmaking": "Playmaking Glass Cleaner",
                "Defense": "Glass Lockdown",
                "Rebounding": "Pure Glass Cleaner"
            ]
        ],
        "Center": [
            "Shooting": [
                "Shooting": "Stretch Five",
                "Finishing": "Scoring Big",
                "Playmaking": "Playmaking Stretch",
                "Defense": "Two-Way Stretch Five",
                "Rebounding": "Stretch Glass Cleaner"
            ],
            "Finishing": [
                "Shooting": "Scoring Big",
                "Finishing": "Athletic Big",
                "Playmaking": "Playmaking Finisher",
                "Defense": "Two-Way Finisher",
                "Rebounding": "Glass-Cleaning Finisher"
            ],
            "Playmaking": [
                "Shooting": "Playmaking Stretch",
                "Finishing": "Athletic Playmaker",
                "Playmaking": "Facilitating Five",
                "Defense": "Two-Way Facilitator",
                "Rebounding": "Glass Facilitator"
            ],
            "Defense": [
                "Shooting": "Stretch Defender",
                "Finishing": "Athletic Defender",
                "Playmaking": "Defensive Facilitator",
                "Defense": "Pure Rim Protector",
                "Rebounding": "Glass Lockdown"
            ],
            "Rebounding": [
                "Shooting": "Stretch Cleaner",
                "Finishing": "Athletic Glass Cleaner",
                "Playmaking": "Playmaking Glass Cleaner",
                "Defense": "Defensive Glass Cleaner",
                "Rebounding": "Pure Glass Cleaner"
            ]
        ]
    ]

    // Return the matching tag if it exists, otherwise return a default value
    return playstyleTags[primaryPosition]?[primaryPlaystyle]?[secondaryPlaystyle] ?? "Custom Build"
}
struct ScrollablePicker: View {
    var title: String
    @Binding var selection: String
    var options: [String]

    @State private var showPicker = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.white)
                .bold()

            Button(action: { showPicker.toggle() }) {
                HStack {
                    Text(selection.isEmpty ? "Select \(title)" : selection)
                        .foregroundColor(selection.isEmpty ? .white.opacity(0.7) : .white)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
            }
            .sheet(isPresented: $showPicker) {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                selection = option
                                showPicker = false
                            }) {
                                Text(option)
                                    .foregroundColor(.blue)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
