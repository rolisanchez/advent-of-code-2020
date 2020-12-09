import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

do {
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")

        var index = 0
        var accVal = 0

        var visited = [Int:Bool]()
        while index < lines.count {
            if visited[index] == true {
                break
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

        print("accVal: ", accVal)
    } else { 
        fatalError("Could not open file")
    }
}