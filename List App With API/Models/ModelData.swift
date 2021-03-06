//
//  ModelData.swift
//  List App With API
//
//  Created by 123456 on 11/8/21.
//

import Foundation
import SwiftUI

final class ModelData: ObservableObject{
//    @Published var highSchools: [HighSchool] = [HighSchool(name: "madison"),HighSchool( name: "murrow"),HighSchool(name: "goldstein")]
    @Published var highSchools: [HighSchool] = HighSchool.highSchools

//    func loadSchools() async throws -> [HighSchool] {
//        guard let url = HighSchool.baseURL else{
//            fatalError("invalid base url")
//        }
//
//        do{
//            let (data, _) = try await URLSession.shared.data(from: url)
//            let decoder = JSONDecoder()
//            return try decoder.decode([HighSchool].self, from: data)
//        }
//        catch{
//            fatalError("failed to decode data")
//        }
//    }
    
    
    func loadSchools() async{
        guard let url = HighSchool.baseURL else{
            fatalError("invalid base url")
        }
        
        do{
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoder = JSONDecoder()
                let highschools = try decoder.decode([HighSchool].self, from: data)
            DispatchQueue.main.async {
                self.highSchools = highschools
            }
        }
        catch{
//            fatalError("failed to decode data: \(error)")
        }
    }
    
    func loadSAT(schoolID:String) async -> SAT{
        guard let baseURL = SAT.baseURL, var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else{
            fatalError("invalid url")
        }
        
        components.queryItems = [URLQueryItem(name: "dbn", value: schoolID)]
        
        guard let url:URL = components.url else{
            fatalError("invalid compenents")
        }
        
        
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let sat = try decoder.decode([SAT].self, from: data)
            guard let sat = sat.first else{
                return SAT(totalTakers: "0", math: "0", reading: "0", writing: "0")

            }
            return sat
        }
        catch{
            fatalError("failed to decode data: \(error), url: \(url.absoluteString)")
        }
    }
    
    func load<T: BaseURL>() async throws->T{
        guard let url = T.baseURL else{
            fatalError("invalid base url")
        }
        
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }
        catch{
            fatalError("failed to decode data")
        }
    }
    
    
}

/*
 Improvements
 1) Fail gracefully
 2) Paging during scrolling
 3) Cacheing
 4) Search Functionality
 */

