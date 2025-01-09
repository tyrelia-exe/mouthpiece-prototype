//
//  RegistrationView.swift
//  mouthpiece
//
//  Created by Jennifer Biggs on 12/8/24.
//

import FirebaseCore
import SwiftUI
import _PhotosUI_SwiftUI
import FirebaseAuth
import FirebaseFirestore
struct RegistrationView: View {
    @State private var step = 1
    @EnvironmentObject var authService: AuthenticationService
    
    // Personal Information
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var dateOfBirth = Date()
    @State private var gender = "Male"
    @State private var email = ""
    @State private var password = ""
    
    // Location
    @State private var city = ""
    @State private var state = ""
    @State private var selectedLocation: CLLocationCoordinate2D?
    
    // School Info
    @State private var isStudent = false
    @State private var school = ""
    @State private var grade = ""
    
    // Sport & Playstyles
    @State private var selectedSport = "Basketball"
    @State private var primaryPosition = ""
    @State private var secondaryPosition = ""
    @State private var primaryPlaystyle = ""
    @State private var secondaryPlaystyle = ""
    @State private var playstyleTag = ""
    
    // Profile Picture & Bio
    @State private var bio = ""
    @State private var profilePicture: UIImage? = nil
    @State private var selectedProfilePicture: PhotosPickerItem? = nil
    
    private let db = Firestore.firestore()
    
    var body: some View {
        ZStack {
            // Background Color
            Color(#colorLiteral(red: 0.118, green: 0.078, blue: 1, alpha: 1)) // #1e14ff
                .ignoresSafeArea()
            
            VStack {
                if step == 1 {
                    Step1PersonalInfoView(
                        firstName: $firstName,
                        lastName: $lastName,
                        username: $username,
                        dateOfBirth: $dateOfBirth,
                        gender: $gender,
                        email: $email,
                        password: $password,
                        onNext: { step = 2 }
                    )
                } else if step == 2 {
                    Step2LocationView { city, state, coordinates in
                        self.city = city
                        self.state = state
                        self.selectedLocation = coordinates
                        step = 3
                    }
                } else if step == 3 {
                    Step3SchoolInfoView(
                        isStudent: $isStudent,
                        school: $school,
                        grade: $grade,
                        onNext: { step = 4 }
                    )
                } else if step == 4 {
                    Step4SportInfoView(
                        selectedSport: $selectedSport,
                        primaryPosition: $primaryPosition,
                        secondaryPosition: $secondaryPosition,
                        primaryPlaystyle: $primaryPlaystyle,
                        secondaryPlaystyle: $secondaryPlaystyle,
                        playstyleTag: $playstyleTag,
                        onNext: {
                            playstyleTag = generatePlaystyleTag(
                                primaryPosition: primaryPosition,
                                primaryPlaystyle: primaryPlaystyle,
                                secondaryPlaystyle: secondaryPlaystyle
                            )
                            step = 5
                        }
                    )
                } else if step == 5 {
                    Step5ProfilePictureAndBioView(
                        bio: $bio,
                        profilePicture: $profilePicture,
                        selectedProfilePicture: $selectedProfilePicture,
                        onNext: { step = 6 }
                    )
                } else if step == 6 {
                    ProfileReviewView(
                        firstName: firstName,
                        lastName: lastName,
                        username: username,
                        dateOfBirth: dateOfBirth,
                        gender: gender,
                        email: email,
                        password: password,
                        city: city,
                        state: state,
                        bio: bio,
                        profilePicture: profilePicture,
                        selectedSport: selectedSport,
                        primaryPosition: primaryPosition,
                        secondaryPosition: secondaryPosition,
                        primaryPlaystyle: primaryPlaystyle,
                        secondaryPlaystyle: secondaryPlaystyle,
                        playstyleTag: playstyleTag,
                        onRegisterSuccess: saveUserData
                    )
                }
            }
            .padding()
        }
    }
    
    private func saveUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "username": username,
            "dateOfBirth": Timestamp(date: dateOfBirth),
            "gender": gender,
            "email": email,
            "password": password,
            "city": city,
            "state": state,
            "bio": bio,
            "profilePictureURL": "", // Placeholder for uploaded profile picture URL
            "school": isStudent ? school : "",
            "grade": grade,
            "selectedSport": selectedSport,
            "primaryPosition": primaryPosition,
            "secondaryPosition": secondaryPosition,
            "primaryPlaystyle": primaryPlaystyle,
            "secondaryPlaystyle": secondaryPlaystyle,
            "playstyleTag": playstyleTag,
            "locationCoordinates": [
                "latitude": selectedLocation?.latitude ?? 0,
                "longitude": selectedLocation?.longitude ?? 0
            ],
            "createdAt": Timestamp()
        ]
        
        db.collection("users").document(userId).setData(userData) { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            } else {
                print("User data saved successfully.")
                authService.isAuthenticated = true // Sign the user in
            }
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
}
