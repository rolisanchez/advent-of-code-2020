import Foundation

// let filepath = "./input.txt"
let filepath = "./testinput.txt"

// BRUTE FORCE - Only works for small inputs
do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")
        
        let busesWithNil = lines[1].components(separatedBy: ",").map{Int($0)}

        // Preprocess buses to get each needed offset
        var busIndexes = [Int:Int]()
        for (index, busNil) in busesWithNil.enumerated() {
            if let bus = busNil {
                busIndexes[bus] = index
            }
        }

        var busNotFound = true
        var currentTimeStamp = 100000000000000
        // > 100000000000000

        while busNotFound {
            var testBus = true
            for (bus, timeOffset) in busIndexes {
                if (currentTimeStamp + timeOffset) % bus != 0 {
                    testBus = false
                    break
                }
            }
            if testBus {
                busNotFound = false
            }
            if busNotFound {
                currentTimeStamp += 1
            }
        }

        print("Result: ", currentTimeStamp)

        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}