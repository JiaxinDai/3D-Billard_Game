import Cocoa

class BoardWindowController: NSWindowController, NSOpenSavePanelDelegate, ViewControllerDelegate {

    var board: Board {
        return viewController.board
    }

    var viewController: ViewController {
        return window!.contentViewController as! ViewController
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        // Establish communication with ViewController
        viewController.delegate = self
    }

    func save() {
        print("Saving...")
        let panel = NSSavePanel(contentRect: contentViewController!.view.bounds, styleMask: .fullSizeContentView, backing: .buffered, defer: true)
        panel.allowedFileTypes = ["gzero"]
        panel.delegate = self
        if let window = self.window {
            panel.beginSheetModal(for: window) { response in
                switch response {
                case .OK: window.title = "Zero + (Saved)"
                default: break
                }
            }
        }
    }

    func panel(_ sender: Any, validate url: URL) throws {
        do {
            print("Saving to \(url)")
            let game = board.serialize()
            try game.write(to: url, atomically: true, encoding: .utf8)
        } catch let err {
            print(err)
        }
    }
}
