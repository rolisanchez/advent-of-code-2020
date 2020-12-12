import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

func rotate(val: Int, currentAngle: Int) -> Int {
    var newAngle = currentAngle + val
    if newAngle >= 360 {
        newAngle = newAngle - 360
    } else if newAngle < 0 {
        newAngle = 360 + newAngle
    }
    return newAngle
}

func moveForward(val: Int, currentAngle: Int, northSouthPos: Int, eastWestPos: Int) -> (nsPos: Int, ewPost: Int){
    var nsPos = northSouthPos
    var ewPos = eastWestPos

    // East
    if currentAngle == 0 {
        ewPos += val
    } else if currentAngle == 90 { // South
        nsPos -= val
    } else if currentAngle == 180 { // West
        ewPos -= val
    } else if currentAngle == 270 { // 270 - North
        nsPos += val
    } else {
        print(currentAngle)
        fatalError("Weird angke")
    }

    return (nsPos, ewPos)
}
do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")

        var currentAngle = 0 // East
        var northSouthPos = 0
        var eastWestPos = 0

        for line in lines {
            let command = String(line[line.startIndex..<line.index(line.startIndex, offsetBy: 1)])
            let value = Int(line[line.index(line.startIndex, offsetBy: 1)..<line.endIndex])!

            
            
            
            
            
            // Action F means to move forward by the given value in the direction the ship is currently facing.
            if command == "F" {
                (northSouthPos, eastWestPos) = moveForward(val: value, currentAngle: currentAngle, northSouthPos: northSouthPos, eastWestPos: eastWestPos)
            } else if command == "N" {
                // Action N means to move north by the given value.
                northSouthPos += value
            } else if command == "S" {
                // Action S means to move south by the given value.
                northSouthPos -= value
            } else if command == "E" {
                // Action E means to move east by the given value.
                eastWestPos += value
            } else if command == "W" {
                // Action W means to move west by the given value.
                eastWestPos -= value
            } else if command == "R" {
                // Action R means to turn right the given number of degrees.
                currentAngle = rotate(val: value, currentAngle: currentAngle)
            } else if command == "L" {
                // Action L means to turn left the given number of degrees.
                currentAngle = rotate(val: -value, currentAngle: currentAngle)
            }
        }

        print(northSouthPos)
        print(eastWestPos)
        print("Manhattan Distance: ", abs(northSouthPos)+abs(eastWestPos))
        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }


}