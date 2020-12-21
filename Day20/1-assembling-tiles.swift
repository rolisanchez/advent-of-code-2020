import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let tilesGroups = contents.components(separatedBy: "\n\n")
        
        
        let tiles = getTiles(tilesGroups)
        // print(tiles)
        var cornerTiles = [Tile]()
        for tile in tiles {
            if countBordersMatched(tile: tile, tiles: tiles) == 2 {
                cornerTiles.append(tile)
            }
        }
        // let tileMatches = processDetails(tileDetails)

        // There might not be a unique combination top-bot or left-right, so get the best matches
        // Ex:
        // 1951: { top: nil, bottom: 2729, right: 2311, left: nil}
        // Maybe don't need to get the best matches, only need to find which one doesn't have top and left match (top left corner)
        // doesn't have top and right (top right)
        // doesn't have bottom and left (bottom left)
        // doesn't have bottom and right (bottom right)
        // let topLeft = tileMatches.filter { $0.value["top"] == nil && $0.value["left"] == nil }
        
        // print(tileMatches)
        // print(topLeft)
        // print("Result: ", result)
        print(cornerTiles.count)
        print(cornerTiles.map { $0.id }.reduce(1, *))
        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}

func countBordersMatched(tile: Tile, tiles: [Tile]) -> Int {
    var matchingBorders = 0
    borders: for border in tile.borders {
        for j in 0..<tiles.count {
            let cTile = tiles[j]
            if cTile.id != tile.id {
                if cTile.allPossibleBorders.contains(border) {
                    matchingBorders += 1
                    continue borders
                }
            }
        }
    }
    return matchingBorders
}

// struct Borders {
//     var top: String
//     var bottom: String
//     var left: String
//     var right: String
// }

struct Tile {
    let id: Int
    var imageData: [String]
    // var borders: Borders {
    //     return Borders(top: imageData.first!, bottom: imageData.last!, left: String(imageData.map { $0.first! }), right: String(imageData.map { $0.last! }))
    // }
    var borders: [String] {
        var list = [String]()
        list.append(imageData.first!)
        list.append(imageData.last!)
        list.append(String(imageData.map { $0.first! }))
        list.append(String(imageData.map { $0.last! }))
        return list
    }
    var allPossibleBorders: [String] {
        var list = [String]()
        list.append(contentsOf: borders)
        list.append(contentsOf: borders.map{String($0.reversed())})
        return list
    }
    // mutating func rotateRight {
    //     let tempTop = borders.top
    //     borders.top = String(borders.left.reversed())
    //     borders.left = borders.bottom
    //     borders.left = String(borders.right.reversed())
    //     borders.right = tempTop
    // }

}
func getTiles(_ tiles: [String]) -> [Tile]{
    var tilesStructs = [Tile]()
    // For each tile, get top, left, right and bottom 
    for tile in tiles {
        let tileWithTitle = tile.components(separatedBy: "\n")
        let title = tileWithTitle[0].components(separatedBy: " ")[1]
        let titleInt = Int(title[title.startIndex..<title.index(title.endIndex, offsetBy: -1)])!
        let imageData = Array(tileWithTitle[1..<tileWithTitle.count])
        let tileStruct = Tile(id: titleInt, imageData: imageData)
        tilesStructs.append(tileStruct)
    }
    return tilesStructs

}
