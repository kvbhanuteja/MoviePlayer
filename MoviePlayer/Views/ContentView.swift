//
//  ContentView.swift
//  MoviePlayer
//
//  Created by bhanuteja on 05/02/22.
//

import SwiftUI

struct ContentView: View {

    @StateObject var videoManager = VideoManager()
    var columns = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(Query.allCases, id: \.self) {
                        searchQuery in
                        QueryTag(query: searchQuery, isSelected: videoManager.selectedQuery == searchQuery)
                            .onTapGesture {
                                self.videoManager.selectedQuery = searchQuery
                            }
                        }
                    }
                }.padding(.horizontal)
                
                ScrollView {
                    if videoManager.videos.isEmpty {
                        ProgressView()
                    } else {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(videoManager.videos, id: \.id) {video in
                                NavigationLink {
                                    VideoPlayerView(video: video)
                                } label: {
                                    VideoCard(video: video)
                                }
                            }
                        }
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .background(Color("AccentColor"))
            .navigationBarHidden(true)
        }
    }
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
