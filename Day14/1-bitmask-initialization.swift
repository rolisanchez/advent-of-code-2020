import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

func pad(binary : String, toSize: Int) -> String {
  var padded = binary
  for _ in 0..<(toSize - binary.count) {
    padded = "0" + padded
  }
    return padded
}

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")

        var currentMask = ""
        var memoryContents = [Int:Int]() // ex: memoryContents[8] = 101

        for line in lines {
            let lineComponents = line.components(separatedBy: "=")
            let command = lineComponents[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let value = lineComponents[1].trimmingCharacters(in: .whitespacesAndNewlines)

            if command == "mask" {
                currentMask = value
            } else { // ex: mem[5201]
                let memAddress = Int(command.components(separatedBy: "[")[1].components(separatedBy: "]")[0])!
                var binaryVal = String(Int(value)!, radix: 2)
                binaryVal = pad(binary: binaryVal, toSize: 36)
                
                // Rules: 
                // The current bitmask is applied to values immediately before they are written to memory: 
                // a 0 or 1 overwrites the corresponding bit in the value, while an X leaves the bit in the value unchanged.

                // var modifiedMask = currentMask
                var modifiedMask = ""
                for index in 0..<currentMask.count {
                    let charMask = currentMask[currentMask.index(currentMask.startIndex, offsetBy: index)]
                    let charVal = binaryVal[binaryVal.index(binaryVal.startIndex, offsetBy: index)]
                    if charMask == "X" { // X leaves value unchanged
                        // modifiedMask[modifiedMask.index(modifiedMask.startIndex, offsetBy: index)] = charVal
                        modifiedMask += String(charVal)
                    } else {
                        // modifiedMask[modifiedMask.index(modifiedMask.startIndex, offsetBy: index)] = charMask
                        modifiedMask += String(charMask)
                    }
                    
                }

                memoryContents[memAddress] = Int(modifiedMask, radix: 2)

            }
            
        }

        print("Result: ", memoryContents.values.reduce(0){$0 + $1})
        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}