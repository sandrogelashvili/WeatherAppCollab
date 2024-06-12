//
//  WeatherPageViewModel.swift
//  Collaboration2
//
//  Created by nuca on 11.06.24.
//

import Foundation
import NetworkingService

class WeatherPageViewModel: ObservableObject {
    //MARK: - Properties
    @Published var weather: [WeatherData]?
    @Published var city: City = City(name: "Tbilisi", latitude: 41.6934591, longitude: 44.8014495)
    
    private var url: String {
        let firstPart = "https://api.openweathermap.org/data/2.5/forecast?lat="
        let lanLon = "\(city.latitude ?? 41.6934591)" + "&lon=" + "\(city.longitude ?? 44.8014495)"
        let appID = "&appid=2bc0404bf7932948f77efddde0175888&units=metric"
        
        return firstPart + lanLon + appID
    }
    
    init() {
        fetch()
    }
    
    //MARK: - Methods
    func fetch() {
        NetworkService.networkService.getData(urlString: url) { (result: Result<Weather, Error>) in
            switch result {
            case .success(let data):
                self.weather = data.list
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func imageURL(url: String) -> URL? {
        URL(string: url)
    }
    
    func getHumidity() -> Int {
        guard let weather = weather?[0].main?.humidity else { return 0 }
        return weather
    } 
    
    func getWindSpeed() -> Int {
        guard let weather = weather?[0].wind?.speed else { return 0 }
        return Int(weather)
    }
    
    func getRain() -> Int {
        guard let weather = weather?[0].rain?.threeHours else { return 0 }
        return Int(weather)
    }
}
