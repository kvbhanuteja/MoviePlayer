//
//  VideoPlayerView.swift
//  MoviePlayer
//
//  Created by bhanuteja on 05/02/22.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    var video: Video
    @State private var player = AVPlayer()
    var body: some View {
        VideoPlayer(player: player)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                if let link =  video.videoFiles.first?.link {
                    player = AVPlayer(url: URL(string: link)!)
                    player.play()
                }
            }
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView(video: previewVideo)
    }
}
