import Foundation

class Board {
    var dimension: Int
    var pieces: [[Piece]]

    static var sharedInstance = {
        return Board(dimension: 19)
    }()

    init(dimension: Int) {
        self.dimension = dimension
        pieces = [[Piece]](repeating: Array(repeatElement(Piece.none, count: dimension)), count: dimension)
    }
}