//
//  Weather.swift
//  Exomind_Test
//
//  Created by guimeus on 31/03/2023.
//

import Foundation

struct WeatherModel: Codable, Identifiable {
    let id: Int
    let weather: [Weather]
    let name: String
    let main: Main
    
    struct Main: Codable {
        let temp: Double
    }
}


extension WeatherModel.Main {
    var tempCelsius: Double {
        return temp - 273.15
    }
}

struct Weather: Codable {
    let main: String
    let description: String
}

extension Weather {
    var emoji: WeatherEmoji {
        switch self.main.lowercased() {
        case "clear":
            return .clear
        case "clouds":
            return .cloudy
        case "rain":
            return .rain
        case "thunderstorm":
            return .thunderstorm
        case "snow":
            return .snow
        case "mist", "fog", "haze", "smoke":
            return .mist
        default:
            return .unknown
        }
    }
}

enum WeatherEmoji: String {
    case clear = "☀️"
    case fewClouds = "⛅️"
    case cloudy = "☁️"
    case rain = "🌧"
    case thunderstorm = "⛈"
    case snow = "❄️"
    case mist = "🌫"
    case unknown = "❓"
}
