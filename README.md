# Convert to BlueJ

A Ruby project to convert Eclipse and IntelliJ (not implemented) projects into BlueJ projects

### Backstory  

My Computer Science teacher loves BlueJ so to get around having to use BlueJ I created this so that I could still program in other IDEs  
  
### Usage

`ruby convert.rb SOURCE_PROJECT OUTPUT_PROJECT [options]`  
`-cIDE`, `--convert=IDE` - Specify what IDE the source project was from  
  
`OUTPUT_PROJECT` cannot be an existing directory.  
  
### To-Do  

* [x] Basic Eclipse support
* [x] Basic IntelliJ support
* [ ] Support for external dependencies
