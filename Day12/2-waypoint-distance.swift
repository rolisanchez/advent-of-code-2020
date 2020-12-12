import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

func rotate(angle: Int, ewWaypoint: Int, nsWaypoint: Int) -> (ewWay: Int, nsWay: Int){
    let degRad: Double = Double(angle) * (Double.pi / 180)
    let cs = cos(degRad);
    let sn = sin(degRad);

    let doubleEW = Double(ewWaypoint)
    let doubleNS = Double(nsWaypoint)

    let ewWay = (doubleEW * cs) - (doubleNS * sn)
    let nsWay = (doubleEW * sn) + (doubleNS * cs)

    return (Int(round(ewWay)), Int(round(nsWay)))
}
do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")

        var ewPos = 0
        var nsPos = 0

        var ewWaypoint = 10 // Starts 10 East
        var nsWaypoint = 1 // Starts 1 North

        for line in lines {
            let command = String(line[line.startIndex..<line.index(line.startIndex, offsetBy: 1)])
            let value = Int(line[line.index(line.startIndex, offsetBy: 1)..<line.endIndex])!

            if command == "F" {
                // Action F means to move forward to the waypoint a number of times equal to the given value.
                ewPos += (ewWaypoint*value)
                nsPos += (nsWaypoint*value)
            } else if command == "N" {
                // Action N means to move the waypoint north by the given value.
                nsWaypoint += value
            } else if command == "S" {
                // Action S means to move the waypoint south by the given value.
                nsWaypoint -= value
            } else if command == "E" {
                // Action E means to move the waypoint east by the given value.
                ewWaypoint += value
            } else if command == "W" {
                // Action W means to move the waypoint west by the given value.
                ewWaypoint -= value
            } else if command == "R" {
                // Action R means to rotate the waypoint around the ship right (clockwise) the given number of degrees.
                (ewWaypoint, nsWaypoint) = rotate(angle: -value, ewWaypoint: ewWaypoint, nsWaypoint: nsWaypoint)
            } else if command == "L" {
                // Action L means to rotate the waypoint around the ship left (counter-clockwise) the given number of degrees.
                (ewWaypoint, nsWaypoint) = rotate(angle: value, ewWaypoint: ewWaypoint, nsWaypoint: nsWaypoint)
            }

        }

        print(nsPos)
        print(ewPos)
        print("Manhattan Distance: ", abs(nsPos)+abs(ewPos))
        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }


}