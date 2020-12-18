import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")
        
        let result = lines.map { line in
            checkBracketsOrCalculate(line: line)
        }.reduce(0,+)
        
        print("Result: ", result)

        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}

func checkBracketsOrCalculate(line: String) -> Int {
    if line.contains("(") {
        var levelCount = 0
        var startIndex: String.Index = line.startIndex
        var endIndex: String.Index = line.startIndex

        for i in line.indices {
            let char = line[i]
            if char == "(" {
                levelCount += 1
                if levelCount == 1 {
                    startIndex = line.index(after: i)
                }
            }
            
            if char == ")" {
                levelCount -= 1
                if levelCount == 0 {
                    endIndex = i
                }
            }
        }

        let betweenParentheses = line.replacingCharacters(in: line.index(before: startIndex)...endIndex, with: String(checkBracketsOrCalculate(line: String(line[startIndex..<endIndex]))))
        return checkBracketsOrCalculate(line: betweenParentheses)
    } else {
        return calculateResult(lineSpaced: line)
    }
}

func calculateResult(lineSpaced: String, rightSide: String? = nil) -> Int {
    let line = lineSpaced.replacingOccurrences(of: " ", with: "")

    let char = line[line.index(line.endIndex, offsetBy: -1)]
    if char == "+" {
        return calculateResult(lineSpaced: String(line[line.startIndex..<line.index(line.endIndex, offsetBy: -1)]), rightSide: nil) + Int(rightSide!)!
    } else if char == "*" {
        return calculateResult(lineSpaced: String(line[line.startIndex..<line.index(line.endIndex, offsetBy: -1)]), rightSide: nil) * Int(rightSide!)!
    } else {
        var charStr = String(char)

        if rightSide != nil {
            charStr = charStr+rightSide!
        } 

        if line.count == 1 {
            return Int(charStr)!
        } else {
            return calculateResult(lineSpaced: String(line[line.startIndex..<line.index(line.endIndex, offsetBy: -1)]), rightSide: charStr)
        }
    }
}