//
//  ViewController.swift
//  swift-test
//
//  Created by Haldun  Fadillioglu on 27.01.2021.
//

import UIKit
import Storyly


struct PokemonSpecies: Codable {
    let name: String
    let url: URL
}

struct Pokemon: Codable {
    let entryNumber: Int
    let pokemonSpecies: PokemonSpecies
}

struct Pokemons: Codable {
    let pokemonEntries: [Pokemon]
}


class ViewController: UIViewController {
    var pokemons: [Pokemon] = [Pokemon]()
    
    @IBOutlet weak var pokemonCollectionView: UICollectionView!
    @IBOutlet weak var storylyView: StorylyView!
//    var storylyView: StorylyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonCollectionView.delegate = self
        pokemonCollectionView.dataSource = self
        pokemonCollectionView.register(PokemonCollectionViewCell.self,
                                        forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
        
//        self.storylyView = StorylyView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 120))
//        self.view.addSubview(storylyView)
        let TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NfaWQiOjQ3LCJhcHBfaWQiOjEyODcsImluc19pZCI6MTYzMX0.mjY5nZ5mPk0H6v5xiexJnpNzGGsn335Cm2mYlzCWo4A"
        
        self.storylyView.storylyInit = StorylyInit(storylyId: TOKEN)
        self.storylyView.rootViewController = self
        self.storylyView.delegate = self
        
        
        fetchPokemons()
    }
    
    func fetchPokemons() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokedex/kanto")!

        URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                print("nil data")
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let decoded: Pokemons = try? decoder.decode(Pokemons.self, from: data) {
                DispatchQueue.main.async {
                    self.pokemons.removeAll()
                    self.pokemons.append(contentsOf: decoded.pokemonEntries)
                    self.pokemonCollectionView.reloadData()
                }
            }
        }.resume()
    }
}

extension ViewController: StorylyDelegate {
    func storylyLoaded(_ storylyView: StorylyView,
                           storyGroupList: [StoryGroup]) {
        print("storylyLoaded")
    }
    
    func storylyLoadFailed(_ storylyView: StorylyView,
                           errorMessage: String) {
        print("storylyLoadFailed")
    }
    
    func storylyActionClicked(_ storylyView: Storyly.StorylyView,
                              rootViewController: UIViewController,
                              story: Storyly.Story) {
        print("storylyActionClicked")
        
        // Edit and use the following method to open an external custom view
        // self.showCustomExternalView(storylyView: storylyView, story: story)
    }
    
    func storylyStoryPresented(_ storylyView: StorylyView) {
        print("storylyStoryPresented")
    }
    
    func storylyStoryDismissed(_ storylyView: StorylyView) {
        print("storylyStoryDismissed")
    }
    
    func storylyUserInteracted(_ storylyView: StorylyView,
                               storyGroup: StoryGroup,
                               story: Story,
                               storyComponent: StoryComponent) {
        print("storylyUserInteracted")
        switch storyComponent.type {
            case .Quiz:
                if let quizComponent = storyComponent as? StoryQuizComponent {
                    // quizComponent actions
                    print("storylyUserInteracted:\(quizComponent.title)")
                }
            case .Poll:
                if let pollComponent = storyComponent as? StoryPollComponent {
                    // pollComponent actions
                    print("storylyUserInteracted:\(pollComponent.title)")
                }
            case .Emoji:
                if let emojiComponent = storyComponent as? StoryEmojiComponent {
                    // emojiComponent actions
                    print("storylyUserInteracted:\(emojiComponent.emojiCodes)")
                }
            case .Undefined: do {}
            default: do {}
        }
    }
    
    func storylyEvent(_ storylyView: StorylyView,
                      event: StorylyEvent,
                      storyGroup: StoryGroup?,
                      story: Story?,
                      storyComponent: StoryComponent?) {
        print("storylyEvent:\(event.rawValue)")
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath) as! PokemonCollectionViewCell
        cell.set(with: self.pokemons[indexPath.row].pokemonSpecies.name)
        return cell
    }
}
