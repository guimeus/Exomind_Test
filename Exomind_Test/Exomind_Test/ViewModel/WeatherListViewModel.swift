//
//  WeatherListViewModel.swift
//  Exomind_Test
//
//  Created by guimeus on 28/03/2023.
//

import Foundation
import Combine
import SwiftUI

class WeatherListViewModel: ObservableObject {
    @Published var weatherData: [WeatherModel] = []
    private var cancellables = Set<AnyCancellable>()
    @Published var isLoading = true
    
    // Cities that we will fetch
    private var currentCityIndex: Int = 0
    private let cities = ["Rennes", "Paris", "Nantes", "Bordeaux", "Lyon"]
    
    // Timer setup
    public var timer = Timer.publish(every: 1.0, on: .main, in: .common)
    private var timerSubscription: Cancellable?
    
    // Messages
    var messages = ["Nous téléchargeons les données...", "C’est presque fini...", "Plus que quelques secondes avant d’avoir le résultat..."]
    var messageIndex = 0
    
    init() {
        startTimer()
        updateCity()
    }
    
    func startTimer() {
        timerSubscription = timer.connect()
    }
    
    func stopTimer() {
        timerSubscription?.cancel()
        timerSubscription = nil
        isLoading = false
    }
    
    
    func restart() {
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
        startTimer()
        isLoading = true
    }
    
    func updateCity() {
        if currentCityIndex < cities.count {
            fetchWeatherData()
            currentCityIndex += 1
        }
    }
    
    func updateMessage() {
        messageIndex = (messageIndex + 1) % messages.count
    }
    
    func fetchWeatherData() {
        let city = cities[currentCityIndex]
        let urlString = URL(string: AppConfig.baseUrl + "weather?q=\(city)&appid=\(AppConfig.weatherApiKey)")
        
        // Je force unwrap l'optional ici, parce que ça ne me dérange pas si l'appli crash à ce moment. Cela signifierait que la création du type URL n'a pas fonctionné, et je saurai directement ce qu'il faut débug.
        URLSession.shared.dataTaskPublisher(for: urlString!)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                print ("\(city) API Call : \(String(data: element.data, encoding: .utf8)!)")
                return element.data
            }
            .decode(type: WeatherModel?.self, decoder: JSONDecoder())
            .catch { error -> Just<WeatherModel?> in
                print("Error fetching weather data for city '\(city)': \(error)")
                return Just(nil)
            }
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] weather in
                self?.weatherData.append(weather)
            })
            .store(in: &cancellables)
    }
}
