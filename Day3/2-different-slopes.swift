import Foundation

// Use Hash Table Data Structure to find sum

let filepath = "./input.txt"

do {
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")

        let LINE_LENGTH = 31

        // Right 1, down 1. -> 77
        // Right 3, down 1. (This is the slope you already checked.) -> 280
        // Right 5, down 1.
        // Right 7, down 1.
        // Right 1, down 2.

        let increments = [[1,1], [3,1], [5,1], [7,1], [1,2]]
        var treesCount = [Int]()
   
        for increment in increments {
            let rightIncrement = increment[0]
            let downIncrement = increment[1]

            var lineIndex = 0
            var currentIndex = 0
            var treeCount = 0

            while (lineIndex < lines.count - 1){
                if lineIndex == 0 { 
                    lineIndex += downIncrement
                }

                let line = lines[lineIndex]
                
                if (currentIndex + rightIncrement) >= LINE_LENGTH {
                    currentIndex =  currentIndex + rightIncrement - LINE_LENGTH
                } else {
                    currentIndex += rightIncrement
                }

                let char = line[line.index(line.startIndex, offsetBy: currentIndex)]

                if char == "#" {
                    treeCount += 1
                }
                
                lineIndex += downIncrement
            }
            print("treeCount: ", treeCount)
            treesCount.append(treeCount)
        }
        print("multiplication: ", treesCount.reduce(1) {$0 * $1})
    }
}