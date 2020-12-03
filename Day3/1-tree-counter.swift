import Foundation

// Use Hash Table Data Structure to find sum

let filepath = "./input.txt"

do {
    if let contents = try? String(contentsOfFile: filepath) {
        var lines = contents.components(separatedBy: "\n")
        lines = Array(lines[1..<lines.count])

        var treeCount = 0
        let LINE_LENGTH = 31
        var currentIndex = 0

        for line in lines {
            guard !line.isEmpty else { continue }
            if (currentIndex + 3) >= LINE_LENGTH {
                currentIndex =  currentIndex + 3 - LINE_LENGTH
            } else {
                currentIndex += 3
            }

            let char = line[line.index(line.startIndex, offsetBy: currentIndex)]

            if char == "#" {
                treeCount += 1
            }

            
        }

        print("treeCount: ", treeCount)
    }
}