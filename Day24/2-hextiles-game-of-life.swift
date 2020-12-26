import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")
        // Implement "odd-r" horizontal layout, which shoves odd rows right
        // See https://www.redblobgames.com/grids/hexagons/


        let initialTiles = getInitialTiles(lines: lines)
        
        var needToCheckTiles =  initialTiles.filter { $0.value.color == .black }
        var currentBlackTiles: Int = needToCheckTiles.count
        print("Day 0 (Initial) black tiles: ", currentBlackTiles)
        // Start oop with filtered, repeat 100 times
        for i in 1...100 {
            // var copyTiles = [String:HexTile]()
            var copyTiles = needToCheckTiles
            for (key,tile) in needToCheckTiles {
                var blackNeighborsCount = 0
                // Get 6 neighbors: ne, nw, se, sw, e, w
                // Add 6 neighbors to needToCheck
                
                // e : col + 1
                var checkCol = tile.col + 1
                var checkRow = tile.row
                var checkHash = "\(checkCol),\(checkRow)"
                if needToCheckTiles[checkHash] == nil {
                    let addTile = HexTile(col: checkCol, row: checkRow)
                    needToCheckTiles[checkHash] = addTile
                } else if needToCheckTiles[checkHash]!.color == .black {
                    blackNeighborsCount += 1
                }
                // w : col - 1
                checkCol = tile.col - 1
                checkHash = "\(checkCol),\(checkRow)"
                if needToCheckTiles[checkHash] == nil {
                    let addTile = HexTile(col: checkCol, row: checkRow)
                    needToCheckTiles[checkHash] = addTile
                } else if needToCheckTiles[checkHash]!.color == .black {
                    blackNeighborsCount += 1
                }

                // ne: 
                checkCol = tile.row % 2 != 0 ? tile.col + 1 : tile.col
                checkRow = tile.row - 1
                checkHash = "\(checkCol),\(checkRow)"
                if needToCheckTiles[checkHash] == nil {
                    let addTile = HexTile(col: checkCol, row: checkRow)
                    needToCheckTiles[checkHash] = addTile
                } else if needToCheckTiles[checkHash]!.color == .black {
                    blackNeighborsCount += 1
                }

                // nw:
                checkCol = tile.row % 2 == 0 ? tile.col - 1 : tile.col
                checkHash = "\(checkCol),\(checkRow)"
                if needToCheckTiles[checkHash] == nil {
                    let addTile = HexTile(col: checkCol, row: checkRow)
                    needToCheckTiles[checkHash] = addTile
                } else if needToCheckTiles[checkHash]!.color == .black {
                    blackNeighborsCount += 1
                }

                // se:
                checkCol = tile.row % 2 != 0 ? tile.col + 1 : tile.col
                checkRow = tile.row + 1
                checkHash = "\(checkCol),\(checkRow)"
                if needToCheckTiles[checkHash] == nil {
                    let addTile = HexTile(col: checkCol, row: checkRow)
                    needToCheckTiles[checkHash] = addTile
                } else if needToCheckTiles[checkHash]!.color == .black {
                    blackNeighborsCount += 1
                }

                // sw:
                checkCol = tile.row % 2 == 0 ? tile.col - 1 : tile.col
                checkHash = "\(checkCol),\(checkRow)"
                if needToCheckTiles[checkHash] == nil {
                    let addTile = HexTile(col: checkCol, row: checkRow)
                    needToCheckTiles[checkHash] = addTile
                } else if needToCheckTiles[checkHash]!.color == .black {
                    blackNeighborsCount += 1
                }

                // copyTiles = needToCheckTiles
                // Any black tile with zero or more than 2 black tiles immediately adjacent to it is flipped to white.
                if blackNeighborsCount == 0 || blackNeighborsCount > 2 {
                    copyTiles[key]!.color = .white
                }
                
            }
            // print("Finished adding neighbors. Check: ", needToCheckTiles.count)
            // Only check the neighbors that are white now
            let whiteNeighbors = needToCheckTiles.filter { $0.value.color == .white } 
            for (key,tile) in whiteNeighbors {
                var blackNeighborsCount = 0
                // Get 6 neighbors: ne, nw, se, sw, e, w
                // Add 6 neighbors to needToCheck
                
                // e : col + 1
                var checkCol = tile.col + 1
                var checkRow = tile.row
                var checkHash = "\(checkCol),\(checkRow)"
                if needToCheckTiles[checkHash]?.color == .black {
                    blackNeighborsCount += 1
                }
                // w : col - 1
                checkCol = tile.col - 1
                checkHash = "\(checkCol),\(checkRow)"
                if needToCheckTiles[checkHash]?.color == .black {
                    blackNeighborsCount += 1
                }

                // ne: 
                checkCol = tile.row % 2 != 0 ? tile.col + 1 : tile.col
                checkRow = tile.row - 1
                checkHash = "\(checkCol),\(checkRow)"
                if needToCheckTiles[checkHash]?.color == .black {
                    blackNeighborsCount += 1
                }

                // nw:
                checkCol = tile.row % 2 == 0 ? tile.col - 1 : tile.col
                checkHash = "\(checkCol),\(checkRow)"
                if needToCheckTiles[checkHash]?.color == .black {
                    blackNeighborsCount += 1
                }

                
                // se:
                checkCol = tile.row % 2 != 0 ? tile.col + 1 : tile.col
                checkRow = tile.row + 1
                checkHash = "\(checkCol),\(checkRow)"
                if needToCheckTiles[checkHash]?.color == .black {
                    blackNeighborsCount += 1
                }

                // sw:
                checkCol = tile.row % 2 == 0 ? tile.col - 1 : tile.col
                checkHash = "\(checkCol),\(checkRow)"
                if needToCheckTiles[checkHash]?.color == .black {
                    blackNeighborsCount += 1
                }

                // Any white tile with exactly 2 black tiles immediately adjacent to it is flipped to black.
                if blackNeighborsCount == 2 {
                    copyTiles[key] = tile
                    copyTiles[key]!.color = .black
                }
                
            }
            needToCheckTiles = copyTiles.filter { $0.value.color == .black }
            
            currentBlackTiles = needToCheckTiles.count

            print("Day \(i) black tiles: ", currentBlackTiles)
        }

        print("Result Part 2: ", currentBlackTiles)
        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}

func getInitialTiles(lines: [String]) -> [String:HexTile]{
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

    return visitedTiles
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