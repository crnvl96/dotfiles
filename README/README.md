1. To install stow:

yay -Sy stow

2. To stow changes:

stow -t ~ --ignore=^/README.* --adopt *

3. To restore changes:

git restore .

4. Tools to be installed after stow and "mise install":

```go
var UV_TOOLS = []string{
	"pyright@latest",
}

var BUN_TOOLS = []string{
	"vscode-langservers-extracted@latest",
	"typescript-language-server@latest",
}

var GO_TOOLS = []string{
	"golang.org/x/tools/gopls@latest",
	"github.com/crnvl96/dirt@latest",
}
```
