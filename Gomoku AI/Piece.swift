import Foundation

enum Piece {
    case black, white, none

    static func random() -> Piece {
        switch Int(CGFloat.random(min: 0, max: 3)) {
        case 0: return Piece.black
        case 1: return Piece.white
        case 2: return Piece.none
        default: assert(false)
        }
    }

    func next() -> Piece {
        assert(self != .none)
        return self == .black ? .white : .black
    }
}