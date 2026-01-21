from rassumfrassum.frassum import LspLogic, Server
from rassumfrassum.json import JSON
from rassumfrassum.util import dmerge, debug, info, event


class PythonLogic(LspLogic):
    async def on_client_request(
        self,
        method: str,
        params: JSON,
        servers: list[Server],
    ):
        info(f"Requesting method: {method!s}")

        if method == "initialize":
            params["initializationOptions"] = dmerge(
                params.get("initializationOptions") or {},
                {
                    # Ruff
                    "settings": {
                        "logLevel": "debug",
                        "fixAll": True,
                        "organizeImports": True,
                        "lint": {"enable": True},
                        "format": {"backend": "uv"},
                    },
                },
            )

        return await super().on_client_request(method, params, servers)

def servers():
    return [["pyright-langserver", "--stdio"], ["ruff", "server"]]


def logic_class():
    return PythonLogic
