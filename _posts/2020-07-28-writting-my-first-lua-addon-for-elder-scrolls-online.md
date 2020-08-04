---
template: post
title: Learning to write addons for Elder Scrolls Online
date: 2020-07-28
excerpt: >-
    I always use my hobbies to learn stuff, and I decided that I wanted to learn how Elder Scrolls Online designed 
    addons, API and UI, so I jumped straight into writing an addon for it. It's a simple one: it just lists online 
    guild members when login in.
toc: false
toc_sticky: true
categories:
  - Games
  - Software Engineering
tags:
  - lua
  - elder scrolls online
  - ESO
header:
    teaser:        /assets/images/elder-scrolls-online/xuotcrezenlz29neyaco.jpeg
    overlay_image: /assets/images/elder-scrolls-online/114ec4f0bcd0d8c60936e26c3644cfa6_the-elder-scrolls-online-greymoor_wallpaper-1920x1080.jpg
    overlay_filter: 0.25
classes: wide
---

I love vide games, and I love programming. Often, I tend to go down the rabbit hole modding or _upgrading_ a game to
better suit my needs. Since that usually involves doing two things that I love together, it proves to be the best way to
learn new stuff for me.

There's a big list of _learning experiences_ I had while I was modding games:
- I learned map-reduce by using [Vgaplanets](https://en.wikipedia.org/wiki/VGA_Planets) [Mess](http://home.snafu.de/spock/)
host util, whose developer and website is still online (wow!);
- memory hacking with "Game Wizard 32" (for DOS), as well as memory optimization with some hacking;
- macroing on [Dark Age of Camelot](https://darkageofcamelot.com/); 
- some 3d design stuff (reflections, sprites, animations...) by creating maps in counter-strike 0.5; 
- UI modding on [Everquest 2](https://www.everquest2.com/), which I continued on [Vanguard: Saga of Heroes](https://en.wikipedia.org/wiki/Vanguard:_Saga_of_Heroes), 
where my [Tarod's Shortcut Panel](http://www.vginterface.com/downloads/info37-TarodsShortCutPanel.html)
was well-known in the community;
- I did the same with [Lord of the Rings Online](http://www.lotro.com/en); 
- [customized](https://github.com/TarodBOFH/ThrustmasterTARGETScripting) my HOTAS for [Elite: Dangerous](https://www.elitedangerous.com/);
- learned [Unity](https://unity.com/) modding [Motor Sport Manager](http://www.motorsportmanager.com/);
- ... and many more.

Now it was time for [Elder Scrolls Online](https://www.elderscrollsonline.com/en-us/home).

Elder Scrolls Online (_ESO_) uses [Lua](https://www.lua.org/) as scripting language for UI interaction.
UI components are described in XML, but it's the scripting part that I was interested on.
I always like `cmd-line` so I wanted to write a script that reacted to some basic _slash commands_.

# Writing the Addon

This was going to be really fun as I had never written any Lua code before.

Let's write our user story: 
> I, as a \<gamer\> want to \<know who is online on each of my guilds when I log in\> to the game so that \<I can 
> interact with them\> without opening additional tools, menus or windows.

As a reference site I used [ESOUI Wiki](https://wiki.esoui.com/Main_Page) to get me started. Contrary to the 
recommendations I was not connecting to the TEST game server (mainly because I was short on disk space) so kids don't
try this at home.

I created my addon folder, my addon metadata file and registered my addon with the game UI engine.

```lua
TarodGuildInfo = {}
TarodGuildInfo.name = "Tarod's Guild Info"
TarodGuildInfo.id = "TarodGuildInfo"

function TarodGuildInfo:Initialize()
end

function TarodGuildInfo.OnAddOnLoaded(event, addontName) 
    if addontName == TarodGuildInfo.id then
        TarodGuildInfo:Initialize()
    end
end

EVENT_MANAGER:RegisterForEvent(TarodGuildInfo.id, EVENT_ADD_ON_LOADED, TarodGuildInfo.OnAddOnLoaded)
```   

I opened the game and enabled my addon... and the game didn't crash which was good.

In order to reload my addon without closing the game I could have some commands, but I wanted to be transparent with the
engine, so each time I changed my code I just did a `/redloadui` on the game to see the effect.

## Using the API to read data from the game

The game API for developers can be found at the developer forums or via [ESO UI Wiki](https://wiki.esoui.com/API). For
me, the best resource was [ESOUI's GitHub repo](https://github.com/esoui/esoui/). I opened [API Doc](https://github.com/esoui/esoui/blob/master/ESOUIDocumentation.txt)
and started my investigation.

I started to search for "guild" but there were too many results. I went for "getguild", and I got some
interesting hits, like [* GetGuildInfo(*integer* _guildId_)](https://github.com/esoui/esoui/blob/6eaa93d7d29b90d6af3cb9fcc2afdc1cba67e565/ESOUIDocumentation.txt#L8781)
and the surrounding functions (`isPlayerInGuild`, `GetNumGuilds()`, `GetGuildId(*luaindex* _guildIndex_)`, etc.).

The API is organized so that one can ask about the number of guilds the current player (our `<gamer>` persona in the 
user story) belongs to, and then ask the game about what's the internal guild id for a given guild index for the player.

Although this can leave some inconsistencies if between one call and the next one (some temporal coupling), specially 
if the player joins or leaves a guild between calls, this was not a problem for me as I want to do this only at game
start.

## Sending data back to the UI

I started to wonder how to write messages on the game chat (as result of my api calls), and I noticed there's a special
`d(*str message)` function to send messages to the `System` message channel. 

I did not want my mod to do anything 
special like using chat channels or other fancy stuff at the moment so It was fine for me. 
However, system messages are sent only to the first tab unless using [pChat](https://www.esoui.com/downloads/info93-pChat.html) 
or other chat mods.

After some hacking I got a first version working, listing the online members for my guilds, as well as the guild name:

```lua

function TarodGuildInfo:GuildInfo() 
    local guildCount = GetNumGuilds()
    for idx = 1, guildCount do
        local guildId = GetGuildId(idx)
        d(GetGuildName(guildId))
        local _, onlineMemberCount, _, _ = GetGuildInfo(guildId)
    
        d("There are " .. onlineMemberCount .. " members online")
        local guildMemberCount = GetNumGuildMembers(guildId)
            
        for idx=1, guildMemberCount do
            local _, _, _ , _,logoff = GetGuildMemberInfo(guildId, idx)
            local _, charName, _, _, _, _, _, _, _ = GetGuildMemberCharacterInfo(guildId, idx)
            
            if logoff == 0 then
                d(charName)
            end
        end
    end 
end
```

The code was ugly, but I was working. I found very challenging not being able to unit test my code (mainly because this
was my very first lua interaction) but at this time just manual testing was ok for me.

## Formatting messages

First thing I wanted was to use the full return values from the functions above (instead of `_`) to display more 
detailed information, like player name, zone, level or champion points, etc. I wanted to add colors and proper 
formatting, so I decided to start with the number of people online in a guild and using conditional formatting.

Most languages support conditional formatting, and in this case this was achieved not with the default lua stdlib but by
using Zenimax Online (the developer of ESO) string format function. 
There is an [article about it](https://wiki.esoui.com/How_to_format_strings_with_zo_strformat) so I'll jump right to the
first formatting. I took the chance to do some refactor to have easier to follow functions.

```lua
function TarodGuildInfo:Initialize()
    TarodGuildInfo.currentPlayer = GetUnitName("player")
    d(zo_strformat("Welcome Back |cB27BFF<<1>>|r!", TarodGuildInfo.currentPlayer))
    TarodGuildInfo:GuildInfo()
end

function TarodGuildInfo:GuildInfo() 
    local guildCount = GetNumGuilds()
    for idx = 1, guildCount do
        TarodGuildInfo:PrintGuildInfo(idx)
    end 
end

function TarodGuildInfo:PrintGuildInfo(idx)
    local guildId = GetGuildId(idx)
    d(zo_strformat("|cFFFFFF<<1>>|r: |cFFB5F4<<2>>|r", GetGuildName(guildId), GetGuildMotD(guildId)))
    local _, onlineMemberCount, _, _ = GetGuildInfo(guildId)
    local additionalMembers = onlineMemberCount - 1

    d(zo_strformat(" |cC3F0C2<<1[You are the only one online :(/There is only another member online:/There are $d members online:]>>|r", additionalMembers))

    TarodGuildInfo:PrintGuildMembers(guildId)
end

function TarodGuildInfo:PrintGuildMembers(guildId)
-- nothing to see here.
end
```

Here there are some things to highlight:
- `TarodGuildInfo.currentPlayer = GetUnitName("player")` is creating a global variable on my addon namespace.
- `zo_strformat("Welcome Back |cB27BFF<<1>>|r!", TarodGuildInfo.currentPlayer)` displays some text and then the current
character's name in purple color (or that's what I think since I am colorblind :smiley:)
- `"|cFFFFFF<<1>>|r: |cFFB5F4<<2>>|r", name, motd` was displaying the guild name in white and the Message of the Day
 in some shade of grey, on the same line
- `|cC3F0C2<<1[ a/b/There are $d members online:]>>|r, additionalMembers`: Displays `a` when `additionalMembers` is 
zero, `b` when it's 1 and `There are <additionalMembers> members online` when it's greater than 1

### Some bugs on the API...

When using this from `/reloadui` everything was working fine, but at first login my own character was not online yet so
the `-1` there was not making much sense.

This was really weird because the documentation said that the addons are invoked **after** character goes online, and 
not _before_. As usual, undocumented stuff happens...

After some trial and error trying to use global variables and locks, I decided that it was easier to have a function to
just iterate over the members and then perform the filtering myself:

```lua

TarodGuildInfo = {}

-- ...

function TarodGuildInfo:CountOtherGuildMembers(guildId)
    local guildMemberCount = GetNumGuildMembers(guildId)
    local onlineCount = 0
    for idx=1, guildMemberCount do
        local _,_,_,_,logoff = GetGuildMemberInfo(guildId, idx)
        local _, charName, _, _, _, _, _, _, _ = GetGuildMemberCharacterInfo(guildId, idx)
        -- Why GetUnitName returns formatted string while charName has the localization suffixes??
        if logoff == 0 and zo_strformat("<<1>>", charName) ~= TarodGuildInfo.currentPlayer then
            onlineCount = onlineCount + 1
        end
    end
    return onlineCount
end

-- ...
```

One weird thing happened was with the `GetUnitName` and `charName` returned by the `GetGuildMemberCharacterInfo`.
One of them gave the current character, but the other one had the `strformat` suffixes for the gender, and it was not 
possible compare directly.

## Almost done

I could now glue all together and have almost the final version of the script:

```lua

TarodGuildInfo = {}

TarodGuildInfo.name = "Tarod's Guild Info"
TarodGuildInfo.id = "TarodGuildInfo"
TarodGuildInfo.currentPlayer = nil
TarodGuildInfo.maxOnline = 15

function TarodGuildInfo:Initialize()
    TarodGuildInfo.currentPlayer = GetUnitName("player")
    d(zo_strformat("Welcome Back |cB27BFF<<1>>|r!", TarodGuildInfo.currentPlayer))
    TarodGuildInfo:GuildInfo()
end

function TarodGuildInfo:GuildInfo() 
    local guildCount = GetNumGuilds()
    for idx = 1, guildCount do
        TarodGuildInfo:PrintGuildInfo(idx)
    end 
end

function TarodGuildInfo:PrintGuildInfo(idx)
    local guildId = GetGuildId(idx)
    d(zo_strformat("|cFFFFFF<<1>>|r: |cFFB5F4<<2>>|r", GetGuildName(guildId), GetGuildMotD(guildId)))
    local onlineMemberCount = TarodGuildInfo:CountOtherGuildMembers(guildId)
    local additionalMembers = onlineMemberCount

    d(zo_strformat(" |cC3F0C2<<1[You are the only one online :(/There is only another member online:/There are $d members online:]>>|r", additionalMembers))
    if (onlineMemberCount < TarodGuildInfo.maxOnline ) then 
        TarodGuildInfo:PrintGuildMembers(guildId)
    end
end

function TarodGuildInfo:CountOtherGuildMembers(guildId)
    local guildMemberCount = GetNumGuildMembers(guildId)
    local onlineCount = 0
    for idx=1, guildMemberCount do
        local _,_,_,_,logoff = GetGuildMemberInfo(guildId, idx)
        local _, charName, _, _, _, _, _, _, _ = GetGuildMemberCharacterInfo(guildId, idx)
        if logoff == 0 and zo_strformat("<<1>>", charName) ~= TarodGuildInfo.currentPlayer then
            onlineCount = onlineCount + 1
        end
    end
    return onlineCount
end

function TarodGuildInfo:PrintGuildMembers(guildId)
    local guildMemberCount = GetNumGuildMembers(guildId)
        
    for idx=1, guildMemberCount do
        local _, _, _ , _,logoff = GetGuildMemberInfo(guildId, idx)
        local _, charName, _, _, _, _, _, _, _ = GetGuildMemberCharacterInfo(guildId, idx)
        
        if logoff == 0 then
            d(charName)
        end
    end
end

function TarodGuildInfo.OnAddOnLoaded(event, addontName) 
    if addontName == TarodGuildInfo.id then
        TarodGuildInfo:Initialize()
    end
end

EVENT_MANAGER:RegisterForEvent(TarodGuildInfo.id, EVENT_ADD_ON_LOADED, TarodGuildInfo.OnAddOnLoaded)

```

I added a global variable to not display online guild members if there were too many of them online, but the rest is
just almost gluing together the previous pieces.

## Adding clickable links to the client

Now it was time to improve how to add detailed info to each logged character info. Here, the main challenge was making
valid links in order to be able to interact with the players/characters by right clicking on them. As usual, there is
[an article about it](https://wiki.esoui.com/How_to_create_custom_links) on the wiki: 

```lua
function TarodGuildInfo:PrintGuildMembers(guildId)
    local guildMemberCount = GetNumGuildMembers(guildId)
    
    for idx=1, guildMemberCount do
        local pname,note,rank,status,logoff = GetGuildMemberInfo(guildId, idx)
        local hasChar, charName, zoneName, classType, alliance, level, cp, zoneId, consoleId = GetGuildMemberCharacterInfo(guildId, idx)
        
        -- Why GetUnitName returns formatted string while charName has the localization suffixes??
        if logoff == 0 and zo_strformat("<<1>>", charName) ~= TarodGuildInfo.currentPlayer then
            local gender = GetGenderFromNameDescriptor(charName)
            local className = GetClassName(gender, classType)
            if cp > 810 then cp = 810 end
            local text = zo_strformat("   |cB27BFF|H1:character:<<1>>|h<<1>>|h|r/|c6EABCA<<2>>|r |cC3F0C2<<3>> <<4>> <<5[/%dcp/%dcp]>> in <<6>>|r", pname, charName, className, level, cp, zoneName)
            d(text)
        end
    end
end
```

Interesting stuff about the special string format:
- `    `: I found no way to insert tabs, so I switched to spaces instead. After all, [who argues about tabs vs spaces?](https://youtu.be/SsoOG6ZeyUI)
(spoiler, 
[he](https://www.wired.com/2016/06/instagram-strikes-sizable-blow-silicon-valleys-tabs-vs-spaces-war/) 
[was](https://www.wired.com/2016/06/instagram-strikes-sizable-blow-silicon-valleys-tabs-vs-spaces-war/) 
[wrong](https://www.thewrap.com/silicon-valley-fact-check-why-richard-is-wrong-on-tabs-versus-spaces/))
- `cB27BFF|H1:character:<<1>>|h<<1>>|h|r/|c6EABCA<<2>>|r`: Color playerName with a link to interact, 
followed by current character name
- `<<5[/%dcp/%dcp]>>` displays the champion points only if they are present (conditional formatting as above: 
empty string for zero, same string for 1 and greater than 1)

## Extra: `/slash_commands`

Finally, I wanted to register some [`SLASH_COMMANDS`](https://wiki.esoui.com/How_to_add_a_slash_command) with the game 
UIEngine:

```lua
SLASH_COMMANDS["/guildinfo"] = function (extra)
    local guilds = GetNumGuilds()
    local index = tonumber(extra)
    if index == nill or guilds == 0 then 
        TarodGuildInfo:GuildInfo()
    elseif index >= 1 and index <= guilds then 
        TarodGuildInfo:PrintGuildInfo(index)
    else
        d(zo_strformat("Please use |cC3F0C2/guildinfo|r |cB27BFF#num_guild|r where |cB27BFF#num_guild|r is a valid guild number between 1 and <<1>>", guilds))
        d("You can also use plain |cC3F0C2/guildinfo|r to get the default welcome message.")
    end
end
```

Although the `/guildinfo` command is really out of the scope of the initial user story, I found it useful, specially
after adding the right click feature of the player names on the previous step. I could just write `/guildinfo #` on the 
chat and interact with my guild mates without opening the guild window.

## The Result

{% include figure image_path="/assets/images/elder-scrolls-online/chat-result.jpg" alt="Image showing in game chat with the members of two guilds online" caption="Final result of /guildinfo command" %}

The full sourcecode for the addon can be found in my Git Hub [repository](https://github.com/TarodBOFH/TarodGuildInfo).

Happy modding!
