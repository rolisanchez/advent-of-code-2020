import Foundation

do {
    let start = DispatchTime.now().uptimeNanoseconds
    // let testInput = "389125467"
    // crabCupsPart2LL(input: testInput)
    
    let input = "712643589"
    crabCupsPart2LL(input: input)
    let end = DispatchTime.now().uptimeNanoseconds
    print("Time elapsed: \((end-start)/1_000)μs")

}

func crabCupsPart2LL(input: String) {
    func calculateDest(nextThree: [Int]) -> Cup {
        var dest = currentCup.val - 1
        while nextThree.contains(dest) || dest == 0 {
            dest = dest == 0 ? countCups : dest - 1
        }
        return hash[dest]!
    }

    // Each Cup has its value and next Cup
    var cups = input.map { Cup(val: Int(String($0))!) }
    let maxCup = cups.max()!.val

    
    cups += Array((maxCup + 1)...(1_000_000)).map { Cup(val: Int(String($0))!) }

    let countCups = cups.count

    var hash = [Int: Cup]()
    // Now build the next Cups and circular on the final Cup
    for (index, cup) in cups.enumerated() {
        let nextClockwise = index + 1 < countCups ? index + 1 : 0
        cup.next = cups[nextClockwise]
        hash[cup.val] = cup
    }
    
    var currentCup = cups[0]

    // Play the game for 1_000_000 rounds
    for _ in 0..<10_000_000 {
        let nextThree = [currentCup.next.val, currentCup.next.next.val, currentCup.next.next.next.val]
        let destCup = calculateDest(nextThree: nextThree)

        currentCup.next = hash[nextThree[2]]!.next
        hash[nextThree[2]]?.next = destCup.next
        destCup.next = hash[nextThree[0]]!

        currentCup = currentCup.next
    }

    let nextTo1 = hash[1]!.next.val
    let nextNextTo1 = hash[1]!.next.next.val
    
    print("Ans Part 2 with LinkedList: ", (nextTo1*nextNextTo1))
}

class Cup: Equatable, Comparable {
    let val: Int
    var next: Cup! = nil

    init(val: Int, next: Cup? = nil){
        self.val = val
        self.next = next
    }

    static func <(lhs: Cup, rhs: Cup) -> Bool {
        return lhs.val < rhs.val
    }

    static func ==(lhs: Cup, rhs: Cup) -> Bool {
        return lhs.val == rhs.val
    }
}
