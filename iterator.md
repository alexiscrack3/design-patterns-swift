# Iterator

The iterator pattern is used to provide a standard interface for traversing a collection of items in an aggregate object without the need to understand its underlying structure.

## Example

```swift
struct Song {
    let title: String
}

protocol MusicLibrary: Sequence {
    var songs: [Song] { get }
}

class MusicLibraryIterator: IteratorProtocol {
    private var current = 0
    private let songs: [Song]

    init(songs: [Song]) {
        self.songs = songs
    }

    func next() -> Song? {
        defer { current += 1 }
        return songs.count > current ? songs[current] : nil
    }
}

class PandoraIterator: MusicLibraryIterator {
}

class SpotifyIterator: MusicLibraryIterator {
}

class Pandora: MusicLibrary {
    var songs: [Song]

    init(songs: [Song]) {
        self.songs = songs
    }

    func makeIterator() -> MusicLibraryIterator {
        return PandoraIterator(songs: songs)
    }
}

class Spotify: MusicLibrary {
    var songs: [Song]

    init(songs: [Song]) {
        self.songs = songs
    }

    func makeIterator() -> MusicLibraryIterator {
        return SpotifyIterator(songs: songs)
    }
}
```

## Usage

```swift
let spotify = Spotify(songs: [Song(title: "Foo"), Song(title: "Bar")] )

for song in spotify {
    print("I've read: \(song)")
}
```
