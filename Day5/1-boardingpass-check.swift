import Foundation

let filepath = "./input.txt"
// let filepath = "./testboarding.txt"

do {
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")

        var maxId = Int.min

        for line in lines {

            // STUPID APPROACH: Iterate through characters and do divisions half by half..
            // First 7 chars = Rows (Total of 128 Rows)
            
            // var rangeRowBottom = 1
            // var rangeRowTop = 128 // Work with 128 first to make it easier for divisions

            // Ex: FBFBBFFRLR:

            // Start by considering the whole range, rows 0 through 127. (1 to 128 to make the division result an integer)
            // F means to take the lower half, keeping rows 0 through 63. (1 to 64)
            // B means to take the upper half, keeping rows 32 through 63. (33 to 64)
            // F means to take the lower half, keeping rows 32 through 47. (33 to 48)
            // B means to take the upper half, keeping rows 40 through 47. (41 to 48)
            // B keeps rows 44 through 47. (45 to 48)
            // F keeps rows 44 through 45. (45 to 46)
            // The final F keeps the lower of the two, row 44. (45)

            // var seatRow = Int.max

            // for rowHalfIndex in 0..<7 {
            //     let rowChar = line[line.index(line.startIndex, offsetBy: rowHalfIndex)]
                
            //     if rowHalfIndex == 6 {
            //         if rowChar == "F" {
            //             seatRow = rangeRowBottom - 1 // Rows are from 0 to 127
            //         } else {
            //             seatRow = rangeRowTop - 1
            //         }
            //         break
            //     }
                
            //     let diff = rangeRowTop - rangeRowBottom + 1 // Include the bottom
            //     let half = diff / 2
            //     if rowChar == "F" {
            //         rangeRowTop -= half
            //     } else {
            //         rangeRowBottom += half
            //     }
            // }
            
            // STUPID Approach Above /|\

            // Better Approach Below: Binary Approach
            // FBFBBFF = 44
            // 0101100 = 44
            var rowChars = String(line[line.startIndex..<line.index(line.startIndex, offsetBy: 7)])
            rowChars = rowChars.replacingOccurrences(of: "F", with: "0").replacingOccurrences(of: "B", with: "1")
            
            let seatRow = Int(rowChars, radix: 2)!
            // Last 3 chars = Column (Total of 8 Columns)
            // Ex: FBFBBFFRLR:

            // RLR = 5 
            // 101 = 5 

            var colChars = String(line[line.index(line.startIndex, offsetBy: 7)..<line.endIndex])
            colChars = colChars.replacingOccurrences(of: "R", with: "1").replacingOccurrences(of: "L", with: "0")
            
            let seatCol = Int(colChars, radix: 2)!

            // print("Seat Row: ", seatRow)
            // print("Seat Col: ", seatCol)

            // seat ID: multiply the row by 8, then add the column. In this example, the seat has ID 44 * 8 + 5 = 357.

            let seatId = (seatRow * 8) + seatCol

            if seatId > maxId {
                maxId = seatId
            }
        }

        print("Max Seat Id: ", maxId)

    } else {
        fatalError("Could not open file")
    }
}