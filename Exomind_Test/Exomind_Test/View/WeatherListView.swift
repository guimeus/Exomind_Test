//
//  ContentView.swift
//  Exomind_Test
//
//  Created by guimeus on 28/03/2023.
//

import SwiftUI
import Combine

enum City: Int {
    case Rennes = 0
    case Paris = 1
    case Nantes = 2
    case Bordeaux = 3
    case Lyon = 4
}

struct WeatherListView: View {
    @State private var progress: CGFloat = 0.0
    @ObservedObject var vm = WeatherListViewModel()
    
    var body: some View {
        VStack {
            if (!vm.isLoading) {
                LazyVStack(spacing: 10) {
                    ForEach(vm.weatherData) { weather in
                        VStack {
                            HStack(spacing: 20) {
                                Text(weather.name)
                                    .font(.headline)
                                Spacer()
                                Text(weather.weather.first?.emoji.rawValue ?? "")
                                Spacer()
                                Text("\(weather.main.tempCelsius, specifier: "%.0f") °C")
                            }
                            
                        }
                    }
                }.padding(.top, 50)
            }
            
            Spacer()
            
            if(vm.isLoading) {
                ProgressView(value: progress, total: 1.0)
                    .frame(height: 30)
                    .padding()
                
                Text("Chargement... \(Int(progress * 100))%")
                    .font(.headline)
                    .padding()
                
                Text(vm.messages[vm.messageIndex])
                    .font(.headline)
                    .padding()
            } else {
                MyWeatherButton(action: {
                    vm.restart()
                    progress = 0.0
                }, title: "Recommencer")
                .padding(.bottom, 30)
            }
        }
        .onReceive(vm.timer) { _ in
            if progress >= 1.0 {
                vm.stopTimer()
                return
            }
            progress += 1.0 / 60.0
            
            if Int(progress * 60) % 10 == 0 {
                vm.updateCity()
            }
            if Int(progress * 60) % 6 == 0 {
                vm.updateMessage()
            }
        }
    }
}


struct WeatherListView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherListView()
    }
}
