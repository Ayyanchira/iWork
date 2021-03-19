//
//  AppDelegate.swift
//  iWork
//
//  Created by Akshay Ayyanchira on 3/15/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let popover = NSPopover()
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
      if let button = statusItem.button {
        button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        button.action = #selector(togglePopover(_:))
      }
        popover.behavior = .transient
        popover.contentViewController = TaskListViewController.initiateViewController()
    }
    
    //PRAGMA MARK:- POP OVER METHODS
    
    @objc func togglePopover(_ sender: Any?) {
      if popover.isShown {
        closePopover(sender: sender)
      } else {
        showPopover(sender: sender)
      }
    }

    func showPopover(sender: Any?) {
      if let button = statusItem.button {
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
      }
    }

    func closePopover(sender: Any?) {
      popover.performClose(sender)
    }

}

