//
//  main.swift
//  Notify
//
//  Created by Charles Kenney on 12/13/17.
//  Copyright © 2017 Charles Kenney. All rights reserved.
//

import Foundation
import Cocoa


autoreleasepool {
  let app = NSApplication.shared
  let delegate = AppDelegate()
  app.delegate = delegate
  app.run()
}
