vim9script

#  ----------------------------------------------------------------------
#  Command line autocomplete

au CmdlineChanged [:/\?] call wildtrigger()
