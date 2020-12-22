import Foundation

let filepath = "./input.txt"
// let filepath = "./testinput.txt"

do {
    let start = DispatchTime.now().uptimeNanoseconds
    if let contents = try? String(contentsOfFile: filepath) {
        let decks = contents.components(separatedBy: "\n\n")

        var p1Deck: [Int] = decks[0].components(separatedBy: "\n").compactMap{Int($0)}
        var p2Deck: [Int] = decks[1].components(separatedBy: "\n").compactMap{Int($0)}

        var historyPlays = [String:Bool]()

        var winner: Player?
        mainloop: while p1Deck.count > 0 && p2Deck.count > 0 {
            let deckP1Value = p1Deck.map{String($0)}.joined(separator: "")
            let deckP2Value = p2Deck.map{String($0)}.joined(separator: "")

            if historyPlays[deckP1Value] == true || historyPlays[deckP2Value] == true {
                print("Existing deck - P1 wins")
                winner = .one
                break mainloop
            }
            historyPlays[deckP1Value] = true
            historyPlays[deckP2Value] = true

            let p1Play = p1Deck.removeFirst()
            let p2Play = p2Deck.removeFirst()

            if p1Deck.count >= p1Play && p2Deck.count >= p2Play {
                // Recursive combat
                let recP1Arr = Array(p1Deck[0..<p1Play])
                let recP2Arr = Array(p2Deck[0..<p2Play])
                let winnerRecursive = recursiveCombat(p1DeckOrig: recP1Arr, p2DeckOrig: recP2Arr)
                if winnerRecursive == .one {
                    // P1 Wins
                    p1Deck.append(p1Play)
                    p1Deck.append(p2Play)
                } else {
                    // P2 Wins
                    p2Deck.append(p2Play)
                    p2Deck.append(p1Play)
                }

            } else {
                if p1Play > p2Play {
                    // P1 Wins
                    p1Deck.append(p1Play)
                    p1Deck.append(p2Play)
                } else {
                    // P2 Wins
                    p2Deck.append(p2Play)
                    p2Deck.append(p1Play)
                }
            }
    
        }

        var winningDeck = [Int]()
        // Won by normal play
        if winner == nil {
            print("Win by normal play")
            if p2Deck.count == 0 {
                print("Winner: One")
                winningDeck = p1Deck
            } else if p1Deck.count == 0 {
                print("Winner: Two")
                winningDeck = p2Deck
            }
        }

        print("Final Deck 1: ", p1Deck)
        print("Final Deck 2: ", p2Deck)

        // if winner == .one {
        //     winningDeck = p1Deck
        // } else if winner == .two {
        //     winningDeck = p2Deck
        // }
        print("Result: ",  getWiningScore(finalDeck: winningDeck))

        let end = DispatchTime.now().uptimeNanoseconds
        print("Time elapsed: \((end-start)/1_000)μs")
    } else { 
        fatalError("Could not open file")
    }
}

enum Player {
    case one,two
}

func recursiveCombat(p1DeckOrig: [Int], p2DeckOrig: [Int]) -> Player {
    var p1Deck = p1DeckOrig
    var p2Deck = p2DeckOrig

    var historyPlays = [String:Bool]()

    mainloop: while p1Deck.count > 0 && p2Deck.count > 0 {
        let deckP1Value = p1Deck.map{String($0)}.joined(separator: "")
        let deckP2Value = p2Deck.map{String($0)}.joined(separator: "")

        if historyPlays[deckP1Value] == true || historyPlays[deckP2Value] == true {
            // print("Existing deck in recursive - P1 wins \(DispatchTime.now().uptimeNanoseconds/1000)")
            return .one
        }

        historyPlays[deckP1Value] = true
        historyPlays[deckP2Value] = true

        let p1Play = p1Deck.removeFirst()
        let p2Play = p2Deck.removeFirst()

        if p1Deck.count  >= p1Play && p2Deck.count >= p2Play {
            let recP1Arr = Array(p1Deck[0..<p1Play])
            let recP2Arr = Array(p2Deck[0..<p2Play])
            let winnerRecursive = recursiveCombat(p1DeckOrig: recP1Arr, p2DeckOrig: recP2Arr)
            if winnerRecursive == .one {
                // P1 Wins
                p1Deck.append(p1Play)
                p1Deck.append(p2Play)
            } else {
                // P2 Wins
                p2Deck.append(p2Play)
                p2Deck.append(p1Play)
            }

        } else {
            if p1Play > p2Play {
                // P1 Wins
                p1Deck.append(p1Play)
                p1Deck.append(p2Play)
            } else {
                // P2 Wins
                p2Deck.append(p2Play)
                p2Deck.append(p1Play)
            }
        }
    }
    if p2Deck.count == 0 {
        return .one
    } else {
        return .two
    }
}


func getWiningScore(finalDeck: [Int]) -> Int {
    var winningScore = 0
    for (index, num) in finalDeck.enumerated(){
        winningScore += (finalDeck.count - index)*num
    }
    return winningScore
}