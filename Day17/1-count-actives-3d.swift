import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let lines = contents.components(separatedBy: "\n")
        
        let dim = Dimension(lines: lines)
        dim.printGrid()

        dim.processCycles(num: 6)
        
        print(dim.totalActive())

        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}

struct Coord: Hashable {
    let x: Int
    let y: Int
    let z: Int
}

class Dimension {
    private var cells: [Coord: Bool] = [:]

    private(set) var rangeX: ClosedRange<Int> = 0...0
    private(set) var rangeY: ClosedRange<Int> = 0...0
    private(set) var rangeZ: ClosedRange<Int> = 0...0

    init(lines: [String]){
        for (y, line) in lines.enumerated() {
            for (x, ch) in line.enumerated() {
                // Initially we only have Z:0, the initial flat region
                self.set(coord: Coord(x: x, y: y, z: 0), to: ch == "#")
            }
        }
    }

    func set(coord: Coord, to value: Bool) {
        cells[coord] = value

        if !rangeX.contains(coord.x) {
            rangeX = rangeX.expandingTo(value: coord.x)
        }
        if !rangeY.contains(coord.y) {
            rangeY = rangeY.expandingTo(value: coord.y)
        }
        if !rangeZ.contains(coord.z) {
            rangeZ = rangeZ.expandingTo(value: coord.z)
        }
    }

    func isActive(coord: Coord) -> Bool {
        return cells[coord] ?? false
    }

    func getNeighborCoordOffsets() -> [Coord] {
        var offsets: [Coord] = []
        for x in -1...1 {
            for y in -1...1 {
                for z in -1...1 {
                    offsets.append(Coord(x: x, y: y, z: z))
                }
            }
        }
        return offsets.filter { $0 != Coord(x: 0, y: 0, z: 0) }
    }

    func processToNextCycle(toOffsets: [Coord]? = nil) {
        // Offsets are the 26 neighbors that need to be checked by default. Parameter is optional in case we want to check different neighbors
        var offsets = [Coord]()
        if toOffsets == nil {
            offsets = getNeighborCoordOffsets()
        }
        var changes: [Coord: Bool] = [:]

        for x in rangeX.expandedBy(value: 1) {
            for y in rangeY.expandedBy(value: 1) {
                for z in rangeZ.expandedBy(value: 1) {
                    var count = 0
                    let cellCoord = Coord(x: x, y: y, z: z)
                    for neighborCoordOffset in offsets {
                        let neighborCoord = Coord(
                                            x: x + neighborCoordOffset.x,
                                            y: y + neighborCoordOffset.y,
                                            z: z + neighborCoordOffset.z
                                        )
                        if isActive(coord: neighborCoord) {
                            count += 1
                        }
                    }


                    let cellActive = isActive(coord: cellCoord)
                    
                    if cellActive {
                        if count == 2 || count == 3 {
                            // Stay active
                        } else {
                            changes[cellCoord] = false
                        }
                    }
                    if !cellActive && count == 3 {
                        changes[cellCoord] = true
                    }
                }
            }
        }

        for change in changes {
            set(coord: change.key, to: change.value)
        }
    }

    func processCycles(num: Int){
        for _ in 0..<num {
            processToNextCycle()
        }
    }

    func printGrid(withDetails: Bool = false) {
        for z in rangeZ {
            print("z: \(z)")
            for y in rangeY {
                for x in rangeX {
                    let terminator = withDetails ? "(\(x),\(y),\(z))" : ""
                    print(isActive(coord: Coord(x: x, y: y, z: z)) ? "#" : ".", terminator: terminator)
                }
                print()
            }
            print()
        }
        print()
    }

    func totalActive() -> Int {
        return cells.values.filter({ $0 == true }).count
    }
}

extension ClosedRange {
    func expandingTo(value: Bound) -> Self {
        return (Swift.min(self.lowerBound, value))...(Swift.max(value, self.upperBound))
    }
}

extension ClosedRange where Bound == Int {
    func expandedBy(value: Bound) -> Self {
        return (self.lowerBound - value)...(self.upperBound + value)
    }
}

///
