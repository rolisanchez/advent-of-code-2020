import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"
// let filepath = "./testinputcorrected.txt"

func runProgram(_ lines: [String]) -> (ended: Bool, acc: Int) {
    var index = 0
    var accVal = 0
    var visited = [Int:Bool]()

    while index < lines.count {
        if visited[index] == true {
            return (false, accVal) 
        }
        visited[index] = true
        let line = lines[index].components(separatedBy: " ")
        let command = line[0]
        let value = Int(line[1])!

        if command == "jmp" {
            index += value
        } else {
            index += 1
        }

        if command == "acc" {
            accVal += value
        }
    }

    return (true, accVal)
}

func canSwap(_ line: String) -> Bool {
    let lineComps = line.components(separatedBy: " ")
    let command = lineComps[0]

    if command == "jmp" || command == "nop" {
        return true
    }
    return false
}

func swap(_ line: String) -> String {
    let lineComps = line.components(separatedBy: " ")
    var command = lineComps[0]

    command = command == "jmp" ? "nop" : "jmp"
    
    return command + " " + lineComps[1]
}

do {
    if let contents = try? String(contentsOfFile: filepath) {
        var lines = contents.components(separatedBy: "\n")

        for (index, line) in lines.enumerated() where canSwap(line) {
            lines[index] = swap(lines[index])

            let (ended, accVal) = runProgram(lines)

            if ended {
                print("*ended: ", ended)
                print("*accVal: ", accVal)

                break
            }
            lines[index] = swap(lines[index])
        }

    } else { 
        fatalError("Could not open file")
    }
}