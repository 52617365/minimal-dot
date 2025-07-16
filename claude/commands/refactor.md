# Code Refactoring Prompt: Logical Organization

You are tasked with refactoring programming files to organize code elements in a logical, hierarchical order. Your goal is to improve code readability and maintainability by restructuring the file contents according to the principles below.

## Core Principles

1. **Hierarchical Organization**: Related code elements should be grouped together and organized in a logical hierarchy
2. **Dependency Order**: Dependencies should be defined before they are used
3. **Nested Structure Placement**: Inner/nested structures should be defined immediately after or within their parent structures
4. **Logical Flow**: Code should read in a natural, top-to-bottom flow

## Refactoring Rules

### General Structure Order:
1. **Imports/Includes** - External dependencies first
2. **Constants/Global Variables** - Module-level constants
3. **Type Definitions** - Enums, type aliases, interfaces
4. **Data Structures** - Classes, structs, records 5. **Functions/Methods** - Utility functions, then main logic
6. **Main/Entry Point** - Program entry point (if applicable)

### Nested Structure Rules:
- **Structs within Structs**: Define nested structs immediately after their parent struct definition
- **Inner Classes**: Place inner classes directly after their containing class
- **Nested Enums**: Define enums used by a struct/class right after that struct/class
- **Helper Types**: Place helper types immediately before or after the structures that use them

## Refactoring Process

1. **Analyze Dependencies**: Identify which structures depend on others
2. **Group Related Elements**: Collect related types, functions, and structures
3. **Order by Hierarchy**: Place parent structures before their children, but nested structures immediately after their parents
4. **Maintain Functionality**: Ensure all refactoring preserves original functionality
5. **Add Logical Separators**: Use comments to separate logical sections

## Instructions for Claude

When refactoring a file:

1. **Preserve All Functionality**: Do not modify the logic or behavior of the code
2. **Maintain Original Names**: Keep all variable, function, and type names unchanged
3. **Add Organizational Comments**: Include section headers to clearly separate logical groups
4. **Follow Language Conventions**: Respect the specific language's best practices
5. **Handle Complex Nesting**: For deeply nested structures, consider whether to keep them inline or extract them based on complexity and reusability
6. **Exportation**: If a type, variable or function is not being used by other packages, it should not be exported. Everything should be unexported by default.

## Example Transformation

**Before (Disorganized):**
```go
package main

func (c *Connection) Disconnect() {
    c.Active = false
}

type UserInfo struct {
    ID   int
    Name string
}

func NewServer(name string) *Server {
    return &Server{Name: name}
}

const DefaultPort = 8080

type AuthConfig struct {
    Token   string
    Enabled bool
}

func (s *Server) Start() error {
    fmt.Printf("Starting server %s\n", s.Name)
    return nil
}

type Connection struct {
    UserInfo UserInfo
    Active   bool
    Config   AuthConfig
}

import (
    "fmt"
    "net"
)

type Server struct {
    Name        string
    Port        int
    Connections []Connection
}

func main() {
    server := NewServer("MyServer")
    server.Start()
}

var MaxConnections = 100
```

After (Organized):
```go
package main

// Imports
import (
    "fmt"
    "net"
)

// Constants and Variables
const DefaultPort = 8080
var MaxConnections = 100

// Main Server Structure
type Server struct {
    Name        string
    Port        int
    Connections []Connection
}

// Connection Structure with nested components
type Connection struct {
    Active bool
    
    // Nested user information - defined inline for tight coupling
    UserInfo struct {
        ID   int
        Name string
    }
    
    // Authentication config - defined inline as it's Connection-specific
    Config struct {
        Token   string
        Enabled bool
    }
}

// Server Methods
func NewServer(name string) *Server {
    return &Server{Name: name}
}

func (s *Server) Start() error {
    fmt.Printf("Starting server %s\n", s.Name)
    return nil
}

// Connection Methods
func (c *Connection) Disconnect() {
    c.Active = false
}

// Entry Point
func main() {
    server := NewServer("MyServer")
    server.Start()
}
```

Note that this example is in the Go programming language but you will be prompted to make similar changes to all kinds of different programming languages.

## Output Format

When refactoring, provide:
1. The refactored code with clear organizational structure
2. A brief explanation of the changes made
3. Confirmation that functionality is preserved
4. Any recommendations for further improvements
5. If you need to replace x with y in a Go project, you should use the following command to do so: `gofmt -r -w 'original_string => new_string .` Example: gofmt -r -w 'bytes.Compare(a, b) == 0 -> bytes.Equal(a, b)' .`

Refactor the provided code according to these guidelines, ensuring logical organization while maintaining all original functionality.
