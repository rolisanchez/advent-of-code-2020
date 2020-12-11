import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

var numRows = 0
var numCols = 0

func countOccupiedVisible(row: Int, col: Int, grid: [[Character]]) -> Int {
    var visibleOccCount = 0

    // Top
    var notFound = true
    var lookDistance = 1
    
    while notFound && row - lookDistance >= 0  {
        if grid[row-lookDistance][col] == "#" {
            visibleOccCount += 1
            notFound = false
        } else if grid[row-lookDistance][col] == "L" {
            notFound = false
        }
        lookDistance += 1
    }

    // Down
    notFound = true
    lookDistance = 1
    
    while notFound && row + lookDistance < numRows {
        if grid[row+lookDistance][col] == "#" {
            visibleOccCount += 1
            notFound = false
        } else if grid[row+lookDistance][col] == "L" {
            notFound = false
        }

        lookDistance += 1 
    }

    // Left
    notFound = true
    lookDistance = 1
    
    while notFound && col - lookDistance >= 0{
        if grid[row][col-lookDistance] == "#" {
            visibleOccCount += 1
            notFound = false
        } else if grid[row][col-lookDistance] == "L" {
            notFound = false
        }

        lookDistance += 1 
    }

    // Right
    notFound = true
    lookDistance = 1
    
    while notFound && col + lookDistance < numCols{
        if grid[row][col+lookDistance] == "#" {
            visibleOccCount += 1
            notFound = false
        } else if grid[row][col+lookDistance] == "L" {
            notFound = false
        }

        lookDistance += 1 
    }

    // Diagonal - Top Left
    notFound = true
    lookDistance = 1
    
    while notFound && row - lookDistance >= 0 && col - lookDistance >= 0 {
        if grid[row-lookDistance][col-lookDistance] == "#" {
            visibleOccCount += 1
            notFound = false
        } else if grid[row-lookDistance][col-lookDistance] == "L" {
            notFound = false
        }

        lookDistance += 1 
    }

    // Diagonal - Top Right
    notFound = true
    lookDistance = 1
    
    while notFound && row - lookDistance >= 0 && col + lookDistance < numCols {
        if grid[row-lookDistance][col+lookDistance] == "#" {
            visibleOccCount += 1
            notFound = false
        } else if grid[row-lookDistance][col+lookDistance] == "L" {
            notFound = false
        }

        lookDistance += 1 
    }

    // Diagonal - Bottom Left
    notFound = true
    lookDistance = 1
    
    while notFound && row + lookDistance < numRows && col - lookDistance >= 0 {
        if grid[row+lookDistance][col-lookDistance] == "#" {
            visibleOccCount += 1
            notFound = false
        } else if grid[row+lookDistance][col-lookDistance] == "L" {
            notFound = false
        }

        lookDistance += 1 
    }

    // Diagonal - Bottom Right
    notFound = true
    lookDistance = 1

    while notFound && row + lookDistance < numRows && col + lookDistance < numCols {
        // print("Bottom RIGHT VAL: ", grid[row+lookDistance][col+lookDistance])
        if grid[row+lookDistance][col+lookDistance] == "#" {
            visibleOccCount += 1
            notFound = false
        } else if grid[row+lookDistance][col+lookDistance] == "L" {
            notFound = false
        }

        lookDistance += 1 
    }

    return visibleOccCount
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
        // print(countOccupiedVisible(row: 0, col: 0, grid: grid))
        // print(countOccupiedVisible(row: 0, col: 2, grid: grid))

        var didGridChange = true

        while didGridChange {
            didGridChange = false
            var newGrid = grid

            for (rowIndex, row) in grid.enumerated() {
                for (colIndex, _) in row.enumerated() {
                    // - If a seat is empty (L) and there are no occupied seats visitble to it, the seat becomes occupied.
                    // - If a seat is occupied (#) and FIVE or more seats visitble to it are also occupied, the seat becomes empty.
                    // - Otherwise, the seat's state does not change.
                    if grid[rowIndex][colIndex] == "L" {
                        let countOccAdj = countOccupiedVisible(row: rowIndex, col: colIndex, grid: grid)
                        if countOccAdj == 0 {
                            newGrid[rowIndex][colIndex] = "#"
                            didGridChange = true
                        }
                    } else if grid[rowIndex][colIndex] == "#" {
                        let countOccAdj = countOccupiedVisible(row: rowIndex, col: colIndex, grid: grid)
                        if countOccAdj >= 5 {
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