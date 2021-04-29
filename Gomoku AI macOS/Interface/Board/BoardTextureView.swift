import Cocoa

@IBDesignable class BoardTextureView: NSView {

    var image: NSImage = NSImage(named: "board_d")! {
        didSet {
            setNeedsDisplay(bounds)
        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if self.inLiveResize {
            return
        }
        self.wantsLayer = true
        image.draw(in: dirtyRect)
    }

    override func viewDidEndLiveResize() {
        setNeedsDisplay(bounds)
    }

}
