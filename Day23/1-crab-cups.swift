import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

do {
    let testInput = "389125467"
    let input = "712643589"

    // crabCupsPart1(input: testInput)
    crabCupsPart1(input: input)

}

func crabCupsPart1(input: String) {
    func calculateDestination(pickedCards: [Int]) -> Int{
        var dest = currentCup - 1
        while pickedCards.contains(dest) || dest < 1 {
            dest = dest < 1 ? totalCups : dest - 1 
        }
        return dest
    }

    var startingCups = input.map { Int(String($0))! }
    let totalCups = 9

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