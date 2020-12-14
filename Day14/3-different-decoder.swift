
import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput2.txt"

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

func applyMask(_ mask: Mask, toNumber number: inout Int, ignoringZero: Bool) {
    mask.bits1.forEach { setBit($0, inNumber: &number) }
    if !ignoringZero {
        mask.bits0.forEach { clearBit($0, inNumber: &number) }
    }
}

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")

        var mask = Mask("")
        var writes = 0
        var memory = [Int:Int]() // [MemoryAddress:Value]
        let junkChars = CharacterSet(charactersIn: " =[]")

        for line in lines {
            let components = line
                .components(separatedBy: junkChars)
                .filter { !$0.isEmpty }

            guard components[0] != "mask" else {
                mask = Mask(components[1])
                continue
            }

            var address = Int(components[1])!
            let value = Int(components[2])!
            var allAddresses: [Int]

            
            applyMask(mask, toNumber: &address, ignoringZero: true)
            allAddresses = floatingAddresses(fromNumber: address, usingMask: mask)
            

            for a in allAddresses {
                writes += 1
                memory[a] = value
            }
        }

        let result = memory.values.reduce(0, +)

        print("Result: ", result)
        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
        
    } else { 
        fatalError("Could not open file")
    }
}