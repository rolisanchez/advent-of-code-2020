import Foundation



func elvesGame(_ startingNumbers: [Int]) -> Int {
    let start = DispatchTime.now().uptimeNanoseconds

    var currentTurn = 0
    var lastReads = [Int:[Int]]()

    // First read the starting numbers
    for num in startingNumbers {
        lastReads[num] = [currentTurn]
        currentTurn += 1
    }

    var lastSpoken = startingNumbers.last!

    print("Just checked starting numbers. Now starting..")
    while currentTurn < 2020 {
        if lastReads[lastSpoken]!.count == 1 {
            lastSpoken = 0
        } else {
            let lastTwo = Array(lastReads[lastSpoken]!.suffix(2))
            lastSpoken = lastTwo[1] - lastTwo[0]
        }

        if lastReads[lastSpoken] != nil {
            lastReads[lastSpoken]!.append(currentTurn)
        } else {
            lastReads[lastSpoken] = [currentTurn]
        }
        currentTurn += 1
    }

    print("FINISHED")
    print("Turn[\(currentTurn)] = ", lastSpoken)

    let end = DispatchTime.now().uptimeNanoseconds
    print("Time elapsed: \((end-start)/1_000)μs")

    return lastSpoken
}

// assert(elvesGame([0,3,6])==436)
// assert(elvesGame([1,3,2])==1)
// assert(elvesGame([2,1,3])==10)
// assert(elvesGame([1,2,3])==27)
// assert(elvesGame([2,3,1])==78)
// assert(elvesGame([3,2,1])==438)
// assert(elvesGame([3,1,2])==1836)

print(elvesGame([0,6,1,7,2,19,20]))