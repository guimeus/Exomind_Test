//
//  HomeView.swift
//  Exomind_Test
//
//  Created by guimeus on 31/03/2023.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("App Météo - Exomind")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 74 / 255, green: 144 / 255, blue: 226 / 255))
                    .padding(.bottom, 50)
                
                NavigationLink(destination: WeatherListView()) {
                    Text("Afficher la météo")
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("Home", displayMode: .inline)
        }
    }
}
