//
//  CustomButton.swift
//  Exomind_Test
//
//  Created by guimeus on 31/03/2023.
//

import SwiftUI

struct MyWeatherButton: View {
    let action: () -> Void
    let title: String

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(Color.blue)
                .cornerRadius(30)
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 4)
        }
    }
}
