import Foundation

do {
    let start = DispatchTime.now().uptimeNanoseconds
    // let testInput = "389125467"
    // crabCupsPart1LL(input: testInput)
    
    let input = "712643589"
    crabCupsPart1LL(input: input)
    let end = DispatchTime.now().uptimeNanoseconds
    print("Time elapsed: \((end-start)/1_000)μs")

}

func crabCupsPart1LL(input: String) {
    func calculateDest(nextThree: [Int]) -> Cup {
        var dest = currentCup.val - 1
        while nextThree.contains(dest) || dest == 0 {
            dest = dest == 0 ? countCups : dest - 1
        }
        return hash[dest]!
    }

    // Each Cup has its value and next Cup
    let cups = input.map { Cup(val: Int(String($0))!) }
    let countCups = cups.count

    var hash = [Int: Cup]()
    // Now build the next Cups and circular on the final Cup
    for (index, cup) in cups.enumerated() {
        let nextClockwise = index + 1 < countCups ? index + 1 : 0
        cup.next = cups[nextClockwise]
        hash[cup.val] = cup
    }
    
    var currentCup = cups[0]

    // Play the game for 100 rounds
    for _ in 0..<100 {
        let nextThree = [currentCup.next.val, currentCup.next.next.val, currentCup.next.next.next.val]
        let destCup = calculateDest(nextThree: nextThree)

        currentCup.next = hash[nextThree[2]]!.next
        hash[nextThree[2]]?.next = destCup.next
        destCup.next = hash[nextThree[0]]!

        currentCup = currentCup.next
    }

    var i = 1
    var ans = ""
    while hash[i]!.next.val != 1 {
        i = hash[i]!.next.val
        ans += String(i)
    }

    print("Ans Part 1 with LinkedList: ", ans)
}

class Cup {
    let val: Int
    var next: Cup! = nil

    init(val: Int, next: Cup? = nil){
        self.val = val
        self.next = next
    }
}
