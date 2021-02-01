import Foundation

class ZeroPlus {
    var delegate: ZeroPlusDelegate!

    func getMove(for player: Piece) {
        Thread.sleep(forTimeInterval: 1)
        delegate?.bestMoveExtrapolated(co: random()) // Placeholder for now
    }

    private func random() -> Coordinate {
        let row = CGFloat.random(min: 0, max: CGFloat(delegate.pieces.count))
        let col = CGFloat.random(min: 0, max: CGFloat(delegate.pieces.count))
        return (col: Int(col), row: Int(row))
    }
}

protocol ZeroPlusDelegate {
    var pieces: [[Piece]] {get}
    func bestMoveExtrapolated(co: Coordinate)
}
© 2021 GitHub, Inc.
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
