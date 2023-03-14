//
//  RemoteCommand.swift
//  SwiftAudio
//
//  Created by Jørgen Henrichsen on 20/03/2018.
//

import Foundation
import MediaPlayer


public typealias RemoteCommandHandler = (MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus

public protocol RemoteCommandProtocol {
    associatedtype Command: MPRemoteCommand
    
    var id: String { get }
    var commandKeyPath: KeyPath<MPRemoteCommandCenter, Command> { get }
    var handlerKeyPath: KeyPath<RemoteCommandController, RemoteCommandHandler> { get }
}

public struct PlayBackCommand: RemoteCommandProtocol {
    
    public static let play = PlayBackCommand(id: "Play", commandKeyPath: \MPRemoteCommandCenter.playCommand, handlerKeyPath: \RemoteCommandController.handlePlayCommand)
    
    public static let pause = PlayBackCommand(id: "Pause", commandKeyPath: \MPRemoteCommandCenter.pauseCommand, handlerKeyPath: \RemoteCommandController.handlePauseCommand)
    
    public static let stop = PlayBackCommand(id: "Stop", commandKeyPath: \MPRemoteCommandCenter.stopCommand, handlerKeyPath: \RemoteCommandController.handleStopCommand)
    
    public static let togglePlayPause = PlayBackCommand(id: "TogglePlayPause", commandKeyPath: \MPRemoteCommandCenter.togglePlayPauseCommand, handlerKeyPath: \RemoteCommandController.handleTogglePlayPauseCommand)
    
    public static let nextTrack = PlayBackCommand(id: "NextTrackCommand", commandKeyPath: \MPRemoteCommandCenter.nextTrackCommand, handlerKeyPath: \RemoteCommandController.handleNextTrackCommand)
    
    public static let previousTrack = PlayBackCommand(id: "PreviousTrack", commandKeyPath: \MPRemoteCommandCenter.previousTrackCommand, handlerKeyPath: \RemoteCommandController.handlePreviousTrackCommand)
    
    
    public typealias Command = MPRemoteCommand
    
    public let id: String
    
    public var commandKeyPath: KeyPath<MPRemoteCommandCenter, MPRemoteCommand>
    
    public var handlerKeyPath: KeyPath<RemoteCommandController, RemoteCommandHandler>
    
}

public struct ChangePlaybackPositionCommand: RemoteCommandProtocol {
    
    public static let changePlaybackPosition = ChangePlaybackPositionCommand(id: "ChangePlaybackPosition", commandKeyPath: \MPRemoteCommandCenter.changePlaybackPositionCommand, handlerKeyPath: \RemoteCommandController.handleChangePlaybackPositionCommand)
    
    public typealias Command = MPChangePlaybackPositionCommand
    
    public let id: String
    
    public var commandKeyPath: KeyPath<MPRemoteCommandCenter, MPChangePlaybackPositionCommand>
    
    public var handlerKeyPath: KeyPath<RemoteCommandController, RemoteCommandHandler>
    
}

public struct SkipIntervalCommand: RemoteCommandProtocol {
    
    public static let skipForward = SkipIntervalCommand(id: "SkipForward", commandKeyPath: \MPRemoteCommandCenter.skipForwardCommand, handlerKeyPath: \RemoteCommandController.handleSkipForwardCommand)
    
    public static let skipBackward = SkipIntervalCommand(id: "SkipBackward", commandKeyPath: \MPRemoteCommandCenter.skipBackwardCommand, handlerKeyPath: \RemoteCommandController.handleSkipBackwardCommand)

    public typealias Command = MPSkipIntervalCommand
    
    public let id: String
    
    public var commandKeyPath: KeyPath<MPRemoteCommandCenter, MPSkipIntervalCommand>
    
    public var handlerKeyPath: KeyPath<RemoteCommandController, RemoteCommandHandler>
    
    func set(preferredIntervals: [NSNumber]) -> SkipIntervalCommand {
        MPRemoteCommandCenter.shared()[keyPath: commandKeyPath].preferredIntervals = preferredIntervals
        return self
    }
    
}

public struct FeedbackCommand: RemoteCommandProtocol {
    
    public static let like = FeedbackCommand(id: "Like", commandKeyPath: \MPRemoteCommandCenter.likeCommand, handlerKeyPath: \RemoteCommandController.handleLikeCommand)
    
    public static let dislike = FeedbackCommand(id: "Dislike", commandKeyPath: \MPRemoteCommandCenter.dislikeCommand, handlerKeyPath: \RemoteCommandController.handleDislikeCommand)
    
    public static let bookmark = FeedbackCommand(id: "Bookmark", commandKeyPath: \MPRemoteCommandCenter.bookmarkCommand, handlerKeyPath: \RemoteCommandController.handleBookmarkCommand)
    
    public typealias Command = MPFeedbackCommand
    
    public let id: String
    
    public var commandKeyPath: KeyPath<MPRemoteCommandCenter, MPFeedbackCommand>
    
    public var handlerKeyPath: KeyPath<RemoteCommandController, RemoteCommandHandler>
    
    func set(isActive: Bool, localizedTitle: String, localizedShortTitle: String) -> FeedbackCommand {
        MPRemoteCommandCenter.shared()[keyPath: commandKeyPath].isActive = isActive
        MPRemoteCommandCenter.shared()[keyPath: commandKeyPath].localizedTitle = localizedTitle
        MPRemoteCommandCenter.shared()[keyPath: commandKeyPath].localizedShortTitle = localizedShortTitle
        return self
    }
}

public struct ChangePlaybackRateCommand: RemoteCommandProtocol {
    public typealias Command = MPChangePlaybackRateCommand
    
    public var id: String
    public var commandKeyPath: KeyPath<MPRemoteCommandCenter, MPChangePlaybackRateCommand>
    public var handlerKeyPath: KeyPath<RemoteCommandController, RemoteCommandHandler>
    
    public static let `default` = ChangePlaybackRateCommand(
        id: "ChangePlaybackRate",
        commandKeyPath: \.changePlaybackRateCommand,
        handlerKeyPath: \.handleChangePlaybackRateCommand
    )
    
    @discardableResult
    func set(supportedPlaybackRates: [Float]) -> ChangePlaybackRateCommand {
        MPRemoteCommandCenter.shared()[keyPath: commandKeyPath].supportedPlaybackRates = supportedPlaybackRates.map { NSNumber(value: $0) }
        return self
    }
}

public struct ChangeRepeatModeCommand: RemoteCommandProtocol {
    public typealias Command = MPChangeRepeatModeCommand
    
    public var id: String
    public var commandKeyPath: KeyPath<MPRemoteCommandCenter, MPChangeRepeatModeCommand>
    public var handlerKeyPath: KeyPath<RemoteCommandController, RemoteCommandHandler>
    
    public static let `default` = ChangeRepeatModeCommand(
        id: "ChangeRepeatMode",
        commandKeyPath: \.changeRepeatModeCommand,
        handlerKeyPath: \.handleChangeRepeatModeCommand
    )
    
    @discardableResult
    public func set(repeatMode: RepeatMode) -> ChangeRepeatModeCommand {
        let repeatType: MPRepeatType
        switch repeatMode {
        case .off:
            repeatType = .off
        case .track:
            repeatType = .one
        case .queue:
            repeatType = .all
        }
        
        MPRemoteCommandCenter.shared()[keyPath: commandKeyPath].currentRepeatType = repeatType
        return self
    }
}

public struct SeekCommand: RemoteCommandProtocol {
    public typealias Command = MPRemoteCommand
    public var id: String
    public var commandKeyPath: KeyPath<MPRemoteCommandCenter, MPRemoteCommand>
    public var handlerKeyPath: KeyPath<RemoteCommandController, RemoteCommandHandler>
    
    public static let forward = SeekCommand(id: "SeekForward", commandKeyPath: \.seekForwardCommand, handlerKeyPath: \.handleSeekForwardCommand)
    public static let backward = SeekCommand(id: "SeekBackward", commandKeyPath: \.seekBackwardCommand, handlerKeyPath: \.handleSeekBackwardCommand)
}

public enum RemoteCommand: CustomStringConvertible {

    case play
    
    case pause
    
    case stop
    
    case togglePlayPause
    
    case next
    
    case previous
    
    case changePlaybackPosition
    
    case skipForward(preferredIntervals: [NSNumber])
    
    case skipBackward(preferredIntervals: [NSNumber])
    
    case like(isActive: Bool, localizedTitle: String, localizedShortTitle: String)
    
    case dislike(isActive: Bool, localizedTitle: String, localizedShortTitle: String)
    
    case bookmark(isActive: Bool, localizedTitle: String, localizedShortTitle: String)
    
    case changePlaybackRate(supportedRates: [Float])
    
    case changeRepeatMode
    
    case seekForward
    case seekBackward

    public var description: String {
        switch self {
        case .play: return "play"
        case .pause: return "pause"
        case .stop: return "stop"
        case .togglePlayPause: return "togglePlayPause"
        case .next: return "nextTrack"
        case .previous: return "previousTrack"
        case .changePlaybackPosition: return "changePlaybackPosition"
        case .skipForward(_): return "skipForward"
        case .skipBackward(_): return "skipBackward"
        case .like(_, _, _): return "like"
        case .dislike(_, _, _): return "dislike"
        case .bookmark(_, _, _): return "bookmark"
        case .changePlaybackRate: return "changePlaybackRate"
        case .changeRepeatMode: return "changeRepeatMode"
        case .seekForward: return "seekForward"
        case .seekBackward: return "seekBackward"
        }
    }
    
    /**
     All values in an array for convenience.
     Don't use for associated values.
     */
    static func all() -> [RemoteCommand] {
        return [
            .play,
            .pause,
            .stop,
            .togglePlayPause,
            .next,
            .previous,
            .changePlaybackPosition,
            .skipForward(preferredIntervals: []),
            .skipBackward(preferredIntervals: []),
            .like(isActive: false, localizedTitle: "", localizedShortTitle: ""),
            .dislike(isActive: false, localizedTitle: "", localizedShortTitle: ""),
            .bookmark(isActive: false, localizedTitle: "", localizedShortTitle: ""),
            .changePlaybackRate(supportedRates: [1, 2]),
            .changeRepeatMode,
            .seekForward,
            .seekBackward
        ]
    }
    
}
