import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")
        // Implement "odd-r" horizontal layout, which shoves odd rows right
        // See https://www.redblobgames.com/grids/hexagons/

        let referenceTile = HexTile(col: 0, row: 0)

        var visitedTiles = [String:HexTile]()
        visitedTiles["0,0"] = referenceTile

        for line in lines {
            // Parse directions 
            let (col, row) = getColRow(line: line)
            let hashColRow = "\(col),\(row)"
            if visitedTiles[hashColRow] == nil {
                let visitedTile = HexTile(col: col, row: row, color: .black, flippedTimes: 1)
                visitedTiles[hashColRow] = visitedTile
            } else {
                visitedTiles[hashColRow]!.color = visitedTiles[hashColRow]!.color == .white ? .black : .white
                visitedTiles[hashColRow]!.flippedTimes += 1
            }
            
        }

        var blackCount = 0
        for visitedTile in visitedTiles.values {
            if visitedTile.color == .black {
                blackCount += 1
            }
        }

        print("Result Part 1: ", blackCount)
        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}

func getColRow(line: String) -> (col: Int, row: Int) {
    var currentCol = 0
    var currentRow = 0
    // Keep position of char in current line
    var pos = 0
    while pos < line.count {
        let char = line[line.index(line.startIndex, offsetBy: pos)]
        var direction = ""
        // First check if next two chars are NE, NW, SE, SW. Last two to check are E and W. 
        if char == "n" || char == "s" {
            let secondChar = line[line.index(line.startIndex, offsetBy: pos+1)]
            direction = secondChar == "e" ? String(char)+"e" : String(char)+"w"
            pos += 2
        } else {
            direction = String(char)
            pos += 1
        }
        if direction == "e" {
            currentCol += 1
        } else if direction == "w" {
            currentCol -= 1
        } else if direction == "ne" {
            if currentRow % 2 != 0 {
                currentCol += 1
            }
            currentRow -= 1
        } else if direction == "nw" {
            if currentRow % 2 == 0 {
                currentCol -= 1
            }
            currentRow -= 1
        } else if direction == "se" {
            if currentRow % 2 != 0 {
                currentCol += 1
            }
            currentRow += 1
        } else if direction == "sw" {
            if currentRow % 2 == 0 {
                currentCol -= 1
            }
            currentRow += 1
        }
    }

    return (currentCol, currentRow)
}
enum TileColor {
    case white, black
}

struct HexTile {
    var col: Int
    var row: Int
    var color: TileColor = .white
    var flippedTimes: Int = 0

    mutating func flip(){
        color = color == .white ? .black : .white
        flippedTimes += 1
    }

}