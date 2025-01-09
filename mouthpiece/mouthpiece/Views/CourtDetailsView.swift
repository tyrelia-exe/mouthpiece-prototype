////
////  CourtDetailsView.swift
////  mouthpiece
////
////  Created by Jennifer Biggs on 12/10/24.
////
//
//
//import SwiftUI
//// Court Details View
//struct CourtDetailsView: View {
//    let courtDetails: CourtDetails
//    let onClose: () -> Void
//
//    var body: some View {
//        VStack(spacing: 10) {
//            HStack {
//                Text(courtDetails.name)
//                    .font(.headline)
//                Spacer()
//                Button(action: onClose) {
//                    Image(systemName: "xmark.circle.fill")
//                        .foregroundColor(.gray)
//                        .font(.title2)
//                }
//            }
//            Text(courtDetails.address)
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            HStack {
//                Text("Hours: \(courtDetails.hours)")
//                Text("Rating: \(courtDetails.rating)")
//            }
//            .font(.subheadline)
//            .foregroundColor(.blue)
//
//            Text("Active Users: \(courtDetails.activeUsers)")
//                .font(.subheadline)
//                .foregroundColor(.green)
//
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack {
//                    ForEach(courtDetails.images, id: \.self) { imageUrl in
//                        AsyncImage(url: URL(string: imageUrl)) { image in
//                            image.resizable()
//                        } placeholder: {
//                            Color.gray
//                        }
//                        .frame(width: 100, height: 100)
//                        .cornerRadius(10)
//                        .shadow(radius: 5)
//                    }
//                }
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(15)
//        .shadow(radius: 5)
//        .padding()
//    }
//}
