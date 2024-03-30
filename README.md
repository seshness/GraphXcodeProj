# GraphXcodeProj

Status: ⚠️ Incomplete

Parses an xcodeproj directory using [XcodeProj](https://github.com/tuist/XcodeProj) and generates a graph of the internal data structures.

Apple does not document the internal format of Xcode projects. This tool may help understand the underlying structure.

## Usage

One-liner:
```
swift run xcodeproj-to-graph MySpecialProject.xcodeproj | dot -T png | open -a Preview -f
```
where `MySpecialProject.xcodeproj` is the path to your xcodeproj.
