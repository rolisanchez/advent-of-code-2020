import Foundation

// let filepath = "./input.txt"
let filepath = "./testinput2.txt"

struct Mask {
    // keep track of which 0/1/X are at which position (i.e. which bits they represent)
    var bits0 = [Int]()
    var bits1 = [Int]()
    var bitsX = [Int]()

    init(_ s: String) {
        let chars = Array(s).reversed()
        for (i, c) in chars.enumerated() {
            switch c {
            case "0": bits0 += [i]
            case "1": bits1 += [i]
            case "X": bitsX += [i]
            default: fatalError("invalid mask \(s)")
            }
        }
    }
}

func floatingAddresses(fromNumber number: Int, usingMask mask: Mask, xIndex: Int = 0) -> [Int] {
    var r = [Int]()
    var n = number

    guard xIndex < mask.bitsX.count else { return [n] }

    let bit = mask.bitsX[xIndex]
    clearBit(bit, inNumber: &n)
    r += floatingAddresses(fromNumber: n, usingMask: mask, xIndex: xIndex + 1)

    setBit(bit, inNumber: &n)
    r += floatingAddresses(fromNumber: n, usingMask: mask, xIndex: xIndex + 1)

    return r
}

func clearBit(_ bit: Int, inNumber n: inout Int) {
    n &= (((1 << 36) - 1) ^ (1 << bit))
}

func setBit(_ bit: Int, inNumber n: inout Int) {
    n |= (1 << bit)
}

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
                        modifiedMask += String(charVal)
                    } else {
                        modifiedMask += String(charMask)
                    }
                    
                }

                var memAddressBinary = String(memAddress, radix: 2)
                memAddressBinary = pad(binary: memAddressBinary, toSize: 36)
                // If the bitmask bit is 0, the corresponding memory address bit is unchanged.
                // If the bitmask bit is 1, the corresponding memory address bit is overwritten with 1.
                // If the bitmask bit is X, the corresponding memory address bit is floating.
                var modifiedAddress = ""
                for index in 0..<currentMask.count {
                    let charMask = currentMask[currentMask.index(currentMask.startIndex, offsetBy: index)]
                    let charAddr = memAddressBinary[memAddressBinary.index(memAddressBinary.startIndex, offsetBy: index)]
                    if charMask == "0" { 
                        modifiedAddress += String(charAddr)
                    } else if charMask == "1" {
                        modifiedAddress += "1"
                    } else {
                        modifiedAddress += "X"
                    }
                }
                
                let maskStr = Mask(modifiedAddress)
                let allAddresses = floatingAddresses(fromNumber: memAddress, usingMask: maskStr)

                for addr in allAddresses {
                    memoryContents[addr] = Int(modifiedMask, radix: 2)
                }

            }
            
        }

        print("Result: ", memoryContents.values.reduce(0){$0 + $1})
        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")

    } else { 
        fatalError("Could not open file")
    }
}

