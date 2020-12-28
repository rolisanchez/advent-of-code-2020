import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")
        let cardKey = Int(lines[0])!
        let doorKey = Int(lines[1])!

        var value = 1
        var loopSizeCard = 0
        while value != cardKey {
            value = getNewVal(value: value)
            loopSizeCard += 1
        }

        var encryptionKey = 1
        for _ in 0..<loopSizeCard {
            encryptionKey = getNewVal(value: encryptionKey, subject: doorKey)
        }
        print("Result Part 1: ", encryptionKey)

        var loopSizeDoor = 0
        value = 1
        while value != doorKey {
            value = getNewVal(value: value)
            loopSizeDoor += 1
        }
        var encryptionDoor = 1
        for _ in 0..<loopSizeDoor {
            encryptionDoor = getNewVal(value: encryptionDoor, subject: cardKey)
        }
        print("Result Part 1 (Double Check): ", encryptionDoor)

        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}

func getNewVal(value: Int, subject: Int = 7) -> Int {
    return (value * subject)%20201227
}