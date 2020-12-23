import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

do {
    // let testInput = "389125467"
    // crabCupsPart1(input: testInput)
    // crabCupsPart1LL(input: testInput)
    
    let input = "712643589"
    // crabCupsPart1(input: input)
    crabCupsPart1LL(input: input)

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

func crabCupsPart1(input: String) {
    func calculateDestination(pickedCards: [Int]) -> Int{
        var dest = currentCup - 1
        while pickedCards.contains(dest) || dest < 1 {
            dest = dest < 1 ? totalCups : dest - 1 
        }
        return dest
    }

    let startingCups = input.map { Int(String($0))! }
    let totalCups = startingCups.count

    var nextCup = Array(repeating: 0, count: totalCups + 1)
    // Array[1] -> The value on position 1 indicates which number is next (clockwise) to it
    for (i, cup) in startingCups.enumerated() {
        nextCup[cup] = startingCups[(i + 1) % startingCups.count]
    }

    var currentCup = startingCups[0]

    for _ in 0..<100 {
        let pickedCards = [
            nextCup[currentCup],
            nextCup[nextCup[currentCup]],
            nextCup[nextCup[nextCup[currentCup]]],
        ]
        let dest = calculateDestination(pickedCards: pickedCards)

        // print("Dest: ", dest)
        nextCup[currentCup] = nextCup[pickedCards[2]]
        nextCup[pickedCards[2]] = nextCup[dest]
        nextCup[dest] = pickedCards[0]

        currentCup = nextCup[currentCup]
    }

    var i = 1
    var ans = ""
    while nextCup[i] != 1 {
        i = nextCup[i]
        ans += String(i)
    }
    print("Ans Part 1: ", ans)
}

class Cup {
    let val: Int
    var next: Cup! = nil

    init(val: Int, next: Cup? = nil){
        self.val = val
        self.next = next
    }
}