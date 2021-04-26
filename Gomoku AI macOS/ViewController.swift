import Cocoa

class ViewController: NSViewController, BoardViewDelegate {

    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var boardTextureView: BoardTextureView!

    func didMouseUpOn(co: Coordinate) {
        // Transfer the interpreted UI action to model
        board.put(at: co)
    }