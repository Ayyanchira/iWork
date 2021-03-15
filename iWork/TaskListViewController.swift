//
//  TaskListViewController.swift
//  iWork
//
//  Created by Akshay Ayyanchira on 3/15/21.
//

import Cocoa

class TaskListViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

extension TaskListViewController {
  // MARK: Storyboard instantiation
  static func freshController() -> TaskListViewController {
    //1.
    let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    //2.
    let identifier = NSStoryboard.SceneIdentifier("TaskListViewController")
    //3.
    guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? TaskListViewController else {
      fatalError("Why cant i find TaskListViewController? - Check Main.storyboard")
    }
    return viewcontroller
  }
}
