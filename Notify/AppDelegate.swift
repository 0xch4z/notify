//
//  AppDelegate.swift
//  Notify
//
//  Created by Charles Kenney on 12/13/17.
//  Copyright © 2017 Charles Kenney. All rights reserved.
//

import Cocoa
import ScriptingBridge
import Alamofire
import AlamofireImage

class AppDelegate: NSObject, NSApplicationDelegate {
  
  private var spotify: SpotifyApplication!
  
  private var previousTrackId: String?

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    bootstrapApplication()
    guard let spotify = SBApplication(bundleIdentifier: Spotify.bundleIdentifier) else {
      fatalError("Fatal Error: Spotify is not available!")
    }
    
    DistributedNotificationCenter.default().addObserver(self,
      selector: #selector(playerStateDidChange), name: Spotify.playerStateNotification, object: nil)
    
    spotify.delegate = self
    self.spotify = spotify
  }

}


// MARK: - SBApplication Delegate

extension AppDelegate: SBApplicationDelegate {
  
  func eventDidFail(_ event: UnsafePointer<AppleEvent>, withError error: Error) -> Any? {
    print("error => \(error.localizedDescription)")
    print("erroneous event => \(event.debugDescription)")
    return nil
  }
  
}


// MARK: - Actions

@objc extension AppDelegate {
  
  func playerStateDidChange() {
    guard let track = spotify.currentTrack,
      let name = track.name,
      let album = track.album,
      let artist = track.artist else {
      return print("Track is not available!")
    }
    
    if let prev = previousTrackId, prev == track.id!() {
      return print("Track was not changed!")
    }
    
    let notification = NSUserNotification()
    
    notification.title = name
    notification.informativeText = "\(artist) — \(album)"
      
    request(track.secureArtworkUrl, method: .get).responseImage { res in
      notification.setValue(res.result.value ?? NSImage(), forKey: "_identityImage")
      NSUserNotificationCenter.default.deliver(notification)
    }
    
    previousTrackId = track.id!()
  }
  
  func bootstrapApplication() {
    if (UserDefaults.standard.value(forKey: "hasBootstrapped") as? Bool ?? false) {
      return print("Notify has already been bootstrapped")
    }
    
    LoginItemUtility.addToLoginItems()
    
    UserDefaults.standard.setValue(true, forKey: "hasBootstrapped")
  }
  
}
