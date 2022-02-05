//
//  VideoManager.swift
//  MoviePlayer
//
//  Created by bhanuteja on 05/02/22.
//

import Foundation

enum Query: String, CaseIterable {
    case nature, animals, people, ocean, food
}

class VideoManager: ObservableObject {
    @Published private(set) var videos: [Video] = []
    @Published var selectedQuery: Query = Query.nature {
        didSet {
            Task.init {
                await findVideos(topic: selectedQuery)
            }
        }
    }
    
    init() {
        Task.init {
            await findVideos(topic: selectedQuery)
        }
    }
    
    func findVideos(topic: Query) async {
        do {
            guard let url = URL(string: "https://api.pexels.com/videos/search?query=\(topic)&per_page=10&orientation=portrait") else {
                fatalError("Missing url")
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue("563492ad6f91700001000001c77a23bdcadd496b8c4cf25834aa5d7f", forHTTPHeaderField: "Authorization")
            let (data , response) = try await URLSession.shared.data(for: urlRequest)
            print(data, response)
            guard let res = response as? HTTPURLResponse, res.statusCode == 200 else {
                fatalError("Error while fetching data")
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoderData = try decoder.decode(VideoRespose.self, from: data)
            DispatchQueue.main.async {
                self.videos = []
                self.videos = decoderData.videos
            }
        } catch {
            print("Error fetching videos from pexels: \(error)")
        }
    }
}
struct VideoRespose: Decodable {
    var page: Int
    var perPage: Int
    var totalResults: Int
    var url: String
    var videos: [Video]
}

struct Video: Identifiable, Decodable {
    var id: Int
    var image: String
    var duration: Int
    var user: User
    var videoFiles: [VideoFile]
    
    struct User: Identifiable, Decodable {
        var id: Int
        var name: String
        var url: String
    }
    
    struct VideoFile: Identifiable, Decodable {
        var id: Int
        var quality: String
        var fileType: String
        var link: String
    }
    
    
}
