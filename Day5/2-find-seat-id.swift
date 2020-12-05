import Foundation

let filepath = "./input.txt"
// let filepath = "./testboarding.txt"

do {
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")

        var existingIds = [Int]()
        for line in lines {
            var rowChars = String(line[line.startIndex..<line.index(line.startIndex, offsetBy: 7)])
            rowChars = rowChars.replacingOccurrences(of: "F", with: "0").replacingOccurrences(of: "B", with: "1")
            
            let seatRow = Int(rowChars, radix: 2)!

            var colChars = String(line[line.index(line.startIndex, offsetBy: 7)..<line.endIndex])
            colChars = colChars.replacingOccurrences(of: "R", with: "1").replacingOccurrences(of: "L", with: "0")
            
            let seatCol = Int(colChars, radix: 2)!

            let seatId = (seatRow * 8) + seatCol

            existingIds.append(seatId)

        }

        print("existingIds count: ", existingIds.count)

        var missingIds = [Int]()

        for row in 0..<128 {
            for col in 0..<7 {
                let seatId = (row * 8) + col
                if !existingIds.contains(seatId) && existingIds.contains(seatId-1) && existingIds.contains(seatId+1){
                    missingIds.append(seatId)
                }
            }
        }

        print("missingIds.count: ", missingIds.count)
        print(missingIds)

    } else {
        fatalError("Could not open file")
    }
}