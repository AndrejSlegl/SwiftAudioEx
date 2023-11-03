//
//  AudioItem.swift
//  SwiftAudio
//
//  Created by Jørgen Henrichsen on 18/03/2018.
//

import Foundation
import AVFoundation
import UIKit

public enum SourceType {
    case stream
    case file
}

public protocol AudioItem {
    var id: String? { get }
    func getSourceUrl() -> String
    func getArtist() -> String?
    func getTitle() -> String?
    func getAlbumTitle() -> String?
    func getSourceType() -> SourceType
    func getArtwork(_ handler: @escaping (UIImage?) -> Void)
}

/// Make your `AudioItem`-subclass conform to this protocol to control which AVAudioTimePitchAlgorithm is used for each item.
public protocol TimePitching {
    
    func getPitchAlgorithmType() -> AVAudioTimePitchAlgorithm
    
}

/// Make your `AudioItem`-subclass conform to this protocol to control enable the ability to start an item at a specific time of playback.
public protocol InitialTiming {
    func getInitialTime() -> TimeInterval
}

/// Make your `AudioItem`-subclass conform to this protocol to set initialization options for the asset. Available keys available at [Apple Developer Documentation](https://developer.apple.com/documentation/avfoundation/avurlasset/initialization_options).
public protocol AssetOptionsProviding {
    func getAssetOptions() -> [String: Any]
}

public class DefaultAudioItem: AudioItem {
    public let id: String?
    
    public var audioUrl: String
    
    public var artist: String?
    
    public var title: String?
    
    public var albumTitle: String?
    
    public var sourceType: SourceType
    
    public var artwork: UIImage?
    
    public var getArtworkHandler: ((@escaping (UIImage?) -> Void) -> Void)?
    
    public init(id: String? = nil, audioUrl: String, artist: String? = nil, title: String? = nil, albumTitle: String? = nil, sourceType: SourceType, artwork: UIImage? = nil) {
        self.id = id
        self.audioUrl = audioUrl
        self.artist = artist
        self.title = title
        self.albumTitle = albumTitle
        self.sourceType = sourceType
        self.artwork = artwork
    }
    
    public func getSourceUrl() -> String {
        audioUrl
    }
    
    public func getArtist() -> String? {
        artist
    }
    
    public func getTitle() -> String? {
        title
    }
    
    public func getAlbumTitle() -> String? {
        albumTitle
    }
    
    public func getSourceType() -> SourceType {
        sourceType
    }

    public func getArtwork(_ callback: @escaping (UIImage?) -> Void) {
        if let handler = getArtworkHandler {
            handler(callback)
        } else {
            callback(artwork)
        }
    }
}

/// An AudioItem that also conforms to the `TimePitching`-protocol
public class DefaultAudioItemTimePitching: DefaultAudioItem, TimePitching {
    
    public var pitchAlgorithmType: AVAudioTimePitchAlgorithm
    
    public override init(id: String?, audioUrl: String, artist: String?, title: String?, albumTitle: String?, sourceType: SourceType, artwork: UIImage?) {
        pitchAlgorithmType = AVAudioTimePitchAlgorithm.timeDomain
        super.init(id: id, audioUrl: audioUrl, artist: artist, title: title, albumTitle: albumTitle, sourceType: sourceType, artwork: artwork)
    }
    
    public init(id: String?, audioUrl: String, artist: String?, title: String?, albumTitle: String?, sourceType: SourceType, artwork: UIImage?, audioTimePitchAlgorithm: AVAudioTimePitchAlgorithm) {
        pitchAlgorithmType = audioTimePitchAlgorithm
        super.init(id: id, audioUrl: audioUrl, artist: artist, title: title, albumTitle: albumTitle, sourceType: sourceType, artwork: artwork)
    }
    
    public func getPitchAlgorithmType() -> AVAudioTimePitchAlgorithm {
        pitchAlgorithmType
    }
}

/// An AudioItem that also conforms to the `InitialTiming`-protocol
public class DefaultAudioItemInitialTime: DefaultAudioItem, InitialTiming {
    
    public var initialTime: TimeInterval
    
    public override init(id: String?, audioUrl: String, artist: String?, title: String?, albumTitle: String?, sourceType: SourceType, artwork: UIImage?) {
        initialTime = 0.0
        super.init(id: id, audioUrl: audioUrl, artist: artist, title: title, albumTitle: albumTitle, sourceType: sourceType, artwork: artwork)
    }
    
    public init(id: String?, audioUrl: String, artist: String?, title: String?, albumTitle: String?, sourceType: SourceType, artwork: UIImage?, initialTime: TimeInterval) {
        self.initialTime = initialTime
        super.init(id: id, audioUrl: audioUrl, artist: artist, title: title, albumTitle: albumTitle, sourceType: sourceType, artwork: artwork)
    }
    
    public func getInitialTime() -> TimeInterval {
        initialTime
    }
    
}

/// An AudioItem that also conforms to the `AssetOptionsProviding`-protocol
public class DefaultAudioItemAssetOptionsProviding: DefaultAudioItem, AssetOptionsProviding {
    
    public var options: [String: Any]
    
    public override init(id: String?, audioUrl: String, artist: String?, title: String?, albumTitle: String?, sourceType: SourceType, artwork: UIImage?) {
        options = [:]
        super.init(id: id, audioUrl: audioUrl, artist: artist, title: title, albumTitle: albumTitle, sourceType: sourceType, artwork: artwork)
    }
    
    public init(id: String?, audioUrl: String, artist: String?, title: String?, albumTitle: String?, sourceType: SourceType, artwork: UIImage?, options: [String: Any]) {
        self.options = options
        super.init(id: id, audioUrl: audioUrl, artist: artist, title: title, albumTitle: albumTitle, sourceType: sourceType, artwork: artwork)
    }
    
    public func getAssetOptions() -> [String: Any] {
        options
    }
}
