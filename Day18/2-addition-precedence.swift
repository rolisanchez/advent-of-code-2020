import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput2.txt"

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
    let lineStrs = lineSpaced.replacingOccurrences(of: " ", with: "").components(separatedBy: "*")
    var line = [Int]()
    for str in lineStrs {
        if str.contains("+") {
            line.append(str.components(separatedBy: "+").map{Int($0)!}.reduce(0,+))
        } else {
            line.append(Int(str)!)
        }
        
    }
    return line.reduce(1,*)
}