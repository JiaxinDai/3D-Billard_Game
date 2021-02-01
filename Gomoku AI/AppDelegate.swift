import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var boardTextureMenuItem: NSMenuItem!

    @IBOutlet weak var darkTextureMenuItem: NSMenuItem!
    @IBOutlet weak var normalTextureMenuItem: NSMenuItem!
    @IBOutlet weak var lightTextureMenuItem: NSMenuItem!

    var textureMenuItems: [NSMenuItem?] {
        return [
            darkTextureMenuItem,
            normalTextureMenuItem,
            lightTextureMenuItem
        ]
    }

    var activeBoard: Board? {
        return activeController?.board
    }

    var activeController: ViewController? {
        return NSApplication.shared.mainWindow?.windowController?.contentViewController as? ViewController
    }

    var activeWindowController: BoardWindowController? {
        return NSApplication.shared.mainWindow?.windowController as? BoardWindowController
    }

    var windowControllers: [BoardWindowController] {
        return NSApplication.shared.windows.map{$0.windowController as? BoardWindowController}
                .filter{$0 != nil}
                .map{$0!}
    }

    var viewControllers: [ViewController] {
        return windowControllers.map{$0.viewController}
    }

    @IBAction func zeroPlus(_ sender: NSMenuItem) {
        switch sender.title {
        case "Black": activeBoard?.zeroAi = .black
            activeBoard?.requestZeroBrainStorm()
        case "White": activeBoard?.zeroAi = .white
            activeBoard?.requestZeroBrainStorm()
        case "Off": activeBoard?.zeroAi = .none
        default: activeBoard?.triggerZeroBrainstorm()
        }
    }

    @IBAction func textureSelected(_ sender: NSMenuItem) {
        var texture: NSImage! = nil
        for item in textureMenuItems {
            item?.state = .off
        }
        switch sender.title {
        case "Dark":
            texture = NSImage(named: "board_dark")
            darkTextureMenuItem.state = .on
        case "Light":
            texture = NSImage(named: "board_light")
            lightTextureMenuItem.state = .on
        case "Normal":
            texture = NSImage(named: "board")
            normalTextureMenuItem.state = .on
        default: break
        }
        viewControllers.forEach{$0.boardTextureView.image = texture}
    }

    @IBAction func restart(_ sender: NSMenuItem) {
        activeBoard?.restart()
    }

    @IBAction func undo(_ sender: NSMenuItem) {
        activeBoard?.undo()
    }

    @IBAction func redo(_ sender: NSMenuItem) {
        activeBoard?.redo()
    }

    @IBAction func save(_ sender: NSMenuItem) {
        activeWindowController?.save()
    }

    @IBAction func open(_ sender: NSMenuItem) {
        let panel = NSOpenPanel(contentRect: NSRect.zero,
                styleMask: .fullSizeContentView,
                backing: .buffered,
                defer: true)
        panel.canChooseDirectories = false
        panel.allowedFileTypes = ["gzero"]
        panel.canChooseFiles = true
        panel.allowsMultipleSelection = true

        panel.begin() { response in
            switch response {
            case .OK:
                var curFrame = NSApplication.shared.mainWindow?.frame ?? CGRect.zero
                for url in panel.urls {
                    curFrame.origin = CGPoint(x: curFrame.minX + 10, y: curFrame.minY - 10)
                    let boardWindowController = NSStoryboard(name: "Main", bundle: nil)
                            .instantiateController(withIdentifier: "board-window") as! BoardWindowController
                    do {
                        let game = try String(contentsOf: url, encoding: .utf8)
                        let fileName = url.lastPathComponent
                        let idx = fileName.firstIndex(of: ".")!
                        boardWindowController.fileName = String(fileName[..<idx]) // Update the name of the window
                        boardWindowController.board.load(game)
                        boardWindowController.showWindow(self)
                        if curFrame.size == .zero {
                            curFrame = boardWindowController.window!.frame
                        } else {
                            boardWindowController.window?.setFrame(curFrame, display: true, animate: true)
                        }
                    } catch let err {
                        print(err)
                    }
                }
            default: break
            }
        }
    }

    @IBAction func new(_ sender: NSMenuItem) {
        let dim = newGameDialogue()
        if dim != -1 {
            let boardWindowController = NSStoryboard(name: "Main", bundle: nil)
                    .instantiateController(withIdentifier: "board-window") as! BoardWindowController
            boardWindowController.board.dimension = dim
            boardWindowController.fileName = boardWindowController.fileName + "" // Trigger window title update
            boardWindowController.showWindow(self)
            if let frame = activeWindowController?.window?.frame { // There's an insignificant bug here...
                let newFrame = CGRect(x: frame.minX + 10, y: frame.minY - 10, width: frame.width, height: frame.height)
                boardWindowController.window?.setFrame(newFrame, display: true, animate: true)
            }
        }
    }


    func newGameDialogue() -> Int {
        let msg = NSAlert()
        msg.addButton(withTitle: "Create")
        msg.addButton(withTitle: "Cancel")
        msg.alertStyle = .informational
        msg.messageText = "Please enter board dimension"
        msg.window.title = "Create New Game"
        msg.informativeText = "* board dimension must be between between 10 and 19"

        let box = NSComboBox(frame: NSRect(x: 0, y: 0, width: 300, height: 24))
        box.addItems(withObjectValues: ["15 x 15","19 x 19"])
        box.placeholderString = "19 x 19"

        msg.accessoryView = box
        let response = msg.runModal()

        if (response == .alertFirstButtonReturn) {
            let dimStr = box.stringValue
            if dimStr == "" { return 19 } else {
                let idx = box.stringValue.firstIndex(of: "x")
                if idx == nil {
                    return Int(dimStr) ?? -1
                }
                var num = String(dimStr[..<idx!])
                num.removeAll{$0 == " "} // Remove spaces
                return Int(num) ?? -1
            }
        } else {
            return -1
        }
    }


    @IBAction func boardTexture(_ sender: NSMenuItem) {
        if let controller = activeController {
            let bool = controller.boardTextureView.isHidden
            viewControllers.forEach{$0.boardTextureView.isHidden = !bool}
            boardTextureMenuItem.title = bool ? "Hide Board Texture" : "Show Board Texture"
        }
    }


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let controller = activeController {
            boardTextureMenuItem.title = controller.boardTextureView.isHidden ?
                    "Show Board Texture" : "Hide Board Texture"
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Gomoku_AI")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving and Undo support
    @IBAction func saveAction(_ sender: AnyObject?) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
        let context = persistentContainer.viewContext

        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                NSApplication.shared.presentError(nserror)
            }
        }
    }

    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return persistentContainer.viewContext.undoManager
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        let context = persistentContainer.viewContext

        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }

        if !context.hasChanges {
            return .terminateNow
        }

        do {
            try context.save()
        } catch {
            let nserror = error as NSError

            // Customize this code block to include application-specific recovery steps.
            let result = sender.presentError(nserror)
            if (result) {
                return .terminateCancel
            }

            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)

            let answer = alert.runModal()
            if answer == .alertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }

}
