import Cocoa

@IBDesignable class BoardTextureView: NSView {

    @IBInspectable var image = NSImage(named: "board_dark")

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if self.inLiveResize {
            return
        }
        self.wantsLayer = true
        image?.draw(in: dirtyRect)
    }

    override func viewDidEndLiveResize() {
        setNeedsDisplay(bounds)
    }


}