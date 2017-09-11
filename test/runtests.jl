using TerminalMenus
using Base.Test

TerminalMenus.config(supress_output=true)

function simulateInput(menu::TerminalMenus.AbstractMenu, keys...)
    keydict =  Dict(:up => "\e[A",
                    :down => "\e[B",
                    :enter => "\r")
    for key in keys
        if isa(key, Symbol)
            write(STDIN.buffer, keydict[key])
        else
            write(STDIN.buffer, "$key")
        end
    end

    request(menu)
end

include("radio_menu.jl")
include("multiselect_menu.jl")

# Other test

# scroll must only accept symbols
@test_throws TypeError TerminalMenus.config(scroll=true)
# :foo is not a valid scroll option
@test_throws ErrorException TerminalMenus.config(scroll=:foo)
# Test scroll wrap
TerminalMenus.config(scroll=:wrap)
@test TerminalMenus.CONFIG[:scroll_wrap] == true
# Updating some params shouldn't change other ones
TerminalMenus.config(charset=:ascii)
@test TerminalMenus.CONFIG[:scroll_wrap] == true
TerminalMenus.config(scroll=:nowrap)
@test TerminalMenus.CONFIG[:scroll_wrap] == false
