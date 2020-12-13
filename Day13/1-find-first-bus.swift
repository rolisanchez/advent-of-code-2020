import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"


do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")
        let earliestTimeStamp = Int(lines[0])!
        var currentTimeStamp = earliestTimeStamp
        let buses = lines[1].components(separatedBy: ",").compactMap{Int($0)}

        var busNotFound = true
        var busSelected = 0

        while busNotFound {
            for bus in buses {
                if currentTimeStamp % bus == 0 {
                    busSelected = bus
                    busNotFound = false
                }
            }
            if busNotFound {
                currentTimeStamp += 1
            }
        }

        let needToWait = currentTimeStamp - earliestTimeStamp

        print("Bus selected: ", busSelected)
        print("earliestTimeStamp: ", earliestTimeStamp)
        print("currentTimeStamp: ", currentTimeStamp)
        print("needToWait: ", needToWait)
        print("Result: ", busSelected*needToWait)

        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}