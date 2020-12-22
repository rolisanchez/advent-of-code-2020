import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let decks = contents.components(separatedBy: "\n\n")

        var p1Deck: [Int] = decks[0].components(separatedBy: "\n").compactMap{Int($0)}
        var p2Deck: [Int] = decks[1].components(separatedBy: "\n").compactMap{Int($0)}

        while p1Deck.count > 0 && p2Deck.count > 0 {
            let p1Play = p1Deck.removeFirst()
            let p2Play = p2Deck.removeFirst()

            // P1 Wins
            if p1Play > p2Play {
                p1Deck.append(p1Play)
                p1Deck.append(p2Play)
            } else {
            // P2 Wins
                p2Deck.append(p2Play)
                p2Deck.append(p1Play)
            }
        }

        let finalArr = (p1Deck+p2Deck)
        var winningScore = 0
        for (index, num) in finalArr.enumerated(){
            winningScore += (finalArr.count - index)*num
        }
        
        print("Result: ", winningScore)

        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}