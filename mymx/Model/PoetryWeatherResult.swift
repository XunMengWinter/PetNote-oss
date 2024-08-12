// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherResult = try? JSONDecoder().decode(WeatherResult.self, from: jsonData)

import Foundation

// MARK: - WeatherResult
struct PoetryWeatherResult: Codable {
    var poetryWeatherList: [PoetryWeather]
    let updateTime: String
    let nowWeather: NowWeather
}

// MARK: - PoetryWeatherList
struct PoetryWeather: Codable, Hashable {
    let bgImage: String
    let poem: String
    let weather: Weather
}

// MARK: - PoetryWeatherListWeather
struct Weather: Codable, Hashable {
    let cloud, fxDate, humidity, iconDay, dayEmoji, dateStr: String
    let iconNight, moonPhase, moonPhaseIcon, moonrise: String
    let moonset, precip, pressure, sunrise: String
    let sunset, tempMax, tempMin, textDay: String
    let textNight, uvIndex, vis, wind360Day: String
    let wind360Night, windDirDay, windDirNight, windScaleDay: String
    let windScaleNight, windSpeedDay, windSpeedNight: String
}

// MARK: - WeatherResultWeather
struct NowWeather: Codable {
    let cloud, dew, feelsLike, humidity: String
    let icon, obsTime, precip, pressure: String
    let temp, text, vis, wind360: String
    let windDir, windScale, windSpeed: String
}
