import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

var numRows = 0
var numCols = 0

func countOccupiedAdjacent(row: Int, col: Int, grid: [[Character]]) -> Int {
    var adjOccCount = 0

    // Top
    if row - 1 >= 0 && grid[row-1][col] == "#" {
        adjOccCount += 1
    }

    // Down
    if row + 1 < numRows && grid[row+1][col] == "#" {
        adjOccCount += 1
    }

    // Left
    if col - 1 >= 0 && grid[row][col-1] == "#" {
        adjOccCount += 1
    }

    // Right
    if col + 1 < numCols && grid[row][col+1] == "#" {
        adjOccCount += 1
    }

    // Diagonal - Top Left
    if row - 1 >= 0 && col - 1 >= 0 &&  grid[row-1][col-1] == "#" {
        adjOccCount += 1
    }

    // Diagonal - Top Right
    if row - 1 >= 0 && col + 1 < numCols &&  grid[row-1][col+1] == "#" {
        adjOccCount += 1
    }

    // Diagonal - Bottom Left
    if row + 1 < numRows && col - 1 >= 0 && grid[row+1][col-1] == "#" {
        adjOccCount += 1
    }

    // Diagonal - Bottom Right
    if row + 1 < numRows && col + 1 < numCols && grid[row+1][col+1] == "#" {
        adjOccCount += 1
    }

    return adjOccCount
}
do {
    let start = DispatchTime.now().uptimeNanoseconds

    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")
        var grid = [[Character]]()
        
        lines.forEach { line in
            var row = [Character]()
            line.forEach {
                // Occupy seats on the first round
                if $0 == "L" {
                    row.append("#")
                } else {
                    row.append($0)
                }
                
            }
            grid.append(row)
        }

        numRows = grid.count
        numCols = grid[0].count
        // print(countOccupiedAdjacent(row: 0, col: 2, grid: grid))

        var didGridChange = true

        while didGridChange {
            didGridChange = false
            var newGrid = grid

            for (rowIndex, row) in grid.enumerated() {
                for (colIndex, _) in row.enumerated() {
                    // - If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
                    // - If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
                    // - Otherwise, the seat's state does not change.
                    if grid[rowIndex][colIndex] == "L" {
                        let countOccAdj = countOccupiedAdjacent(row: rowIndex, col: colIndex, grid: grid)
                        if countOccAdj == 0 {
                            newGrid[rowIndex][colIndex] = "#"
                            didGridChange = true
                        }
                    } else if grid[rowIndex][colIndex] == "#" {
                        let countOccAdj = countOccupiedAdjacent(row: rowIndex, col: colIndex, grid: grid)
                        if countOccAdj >= 4 {
                            newGrid[rowIndex][colIndex] = "L"
                            didGridChange = true
                        }
                    }
                }
            }
            grid = newGrid
        }

        var occupiedCount = 0
        for row in grid {
            for col in row {
                if col == "#" {
                    occupiedCount += 1
                }
            }
        }
        print("occupiedCount: ", occupiedCount)

        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")

    } else { 
        fatalError("Could not open file")
    }
}