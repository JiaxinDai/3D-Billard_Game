import Cocoa

class ViewController: NSViewController, BoardViewDelegate {

    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var boardTextureView: BoardTextureView!

    func didMouseUpOn(co: Coordinate) {
        // Transfer the interpreted UI action to model
        board.put(at: co)
    }





    var delegate: ViewControllerDelegate?
    var board: Board = Board(dimension: 19)
    var zeroPlus: ZeroPlus {
        return board.zeroPlus
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print()
        // Establish delegation with board (Model)
        board.delegate = self
        zeroPlus.visDelegate = self // Set this to nil to disable visualization

        // Establish delegation with board view (View)
        boardView.delegate = self

    }

    func updateVisPref(_ name: String) {
        switch name {
        case "Toggle Animation":
            let state = boardView.zeroPlusVisualization
            boardView.zeroPlusVisualization = !state
            zeroPlus.visDelegate = state ? nil : self
        case "Toggle Active Map": boardView.activeMapVisible = !boardView.activeMapVisible
        case "Toggle History Stack": boardView.zeroPlusHistoryVisible  = !boardView.zeroPlusHistoryVisible
        default: break
        }
    }

    override func mouseUp(with event: NSEvent) {
        print(event)
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

}

protocol ViewControllerDelegate {
    var board: Board {get}
}

extension ViewController: BoardDelegate {
    func gameHasEnded(winner: Piece, coordinates: [Coordinate]) {
        DispatchQueue.main.async {
            self.boardView.winningCoordinates = coordinates
            let msg = winner == .black ? "Black wins!" : "White wins!"
            let _  = dialogue(msg: msg, infoTxt: "Hit Shift + Command + R (⇧⌘R) to restart the game.")
        }
    }

    func boardDidUpdate(pieces: [[Piece]]) {
        // Transfer the current arrangement of pieces to board view for display
        boardView.pieces = pieces
    }

}

extension ViewController: ZeroPlusVisualizationDelegate {
    func activeMapUpdated(activeMap: [[Bool]]?) {
        DispatchQueue.main.async {
            self.boardView.activeMap = activeMap
        }
    }

    func historyDidUpdate(history: History?) {
        DispatchQueue.main.async {
            self.boardView.zeroPlusHistory = history
        }
    }

    func zeroPlus(isThinking: Bool) {
        boardView.userInteractionDisabled = isThinking
    }
}
