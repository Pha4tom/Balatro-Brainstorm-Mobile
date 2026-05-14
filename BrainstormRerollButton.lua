--- STEAMODDED HEADER
--- MOD_NAME: Brainstorm Reroll Button
--- MOD_ID: BrainstormRerollButton
--- MOD_AUTHOR: [Pha4tom]
--- MOD_DESCRIPTION: Direct Seed Search Trigger
----------------------------------------------

function G.FUNCS.brainstorm_reroll_button(arg_736_0)
    G.SETTINGS.paused = false

    if not Brainstorm or not Brainstorm.SETTINGS then
        G:delete_run()
        G:start_run({ stake = G.GAME.stake or 1 })
        return
    end

    local target_tag = Brainstorm.SETTINGS.autoreroll.searchTag or ''
    local search_soul = Brainstorm.SETTINGS.autoreroll.searchForSoul
    local MAX_ATTEMPTS = 50000
    local chars = "123456789ABCDEFGHJKLMNPQRSTUVWXYZ"

    local no_tag = (target_tag == '' or target_tag == 'None')
    local no_soul = not search_soul
    local target_pack = Brainstorm.SETTINGS.autoreroll.searchPack
    local has_pack = type(target_pack) == 'table' and #target_pack > 0

    if no_tag and no_soul and not has_pack then
        G:delete_run()
        G:start_run({ stake = G.GAME.stake or 1 })
        return
    end

    print("HUNTING tag=" .. tostring(target_tag) .. " soul=" .. tostring(search_soul) .. " pack=" .. tostring(has_pack))

    for i = 1, MAX_ATTEMPTS do
        local seed = ""
        for j = 1, 8 do
            local idx = math.random(1, #chars)
            seed = seed .. chars:sub(idx, idx)
        end

        Brainstorm.random_state = { hashed_seed = pseudohash(seed) }

        -- Check tag
        local tag_ok = no_tag
        if not tag_ok then
            local tag = pseudorandom_element(
                G.P_CENTER_POOLS["Tag"],
                Brainstorm.pseudoseed("Tag1" .. seed)
            )
            tag_ok = (tag and tag.key == target_tag)
        end

        if not tag_ok then goto continue end

        -- Check soul
        local soul_ok = no_soul
        if not soul_ok then
            for s = 1, search_soul do
                local found = false
                for p = 1, 5 do
                    if pseudorandom(Brainstorm.pseudoseed("soul_Tarot1" .. seed)) > 0.997 then
                        found = true
                    end
                end
                if not found then
                    soul_ok = false
                    goto continue
                end
            end
            soul_ok = true
        end

        -- Check pack
        local pack_ok = not has_pack
        if not pack_ok then
            local cume, it, center = 0, 0, nil
            for k, v in ipairs(G.P_CENTER_POOLS['Booster']) do
                cume = cume + (v.weight or 1)
            end
            local poll = pseudorandom(
                Brainstorm.pseudoseed("shop_pack1" .. seed)
            ) * cume
            for k, v in ipairs(G.P_CENTER_POOLS['Booster']) do
                it = it + (v.weight or 1)
                if it >= poll and it - (v.weight or 1) <= poll then
                    center = v
                    break
                end
            end
            if center then
                for p = 1, #target_pack do
                    if target_pack[p] == center.key then
                        pack_ok = true
                        break
                    end
                end
            end
        end

        if tag_ok and soul_ok and pack_ok then
            print("MATCH: " .. seed .. " after " .. i .. " attempts")
            G:delete_run()
            G:start_run({ stake = G.GAME.stake or 1, seed = seed })
            G.GAME.seeded = true
            return
        end

        ::continue::
    end

    print("NO SEED FOUND in " .. MAX_ATTEMPTS .. " attempts")
    attention_text({
        text = "NO SEED FOUND",
        scale = 0.4, hold = 2,
        backdrop_colour = G.C.RED,
        align = 'cm'
    })
end

local createOptionsRef = create_UIBox_options
function create_UIBox_options()
    local contents = createOptionsRef()
    if not (G.STATE == G.STATES.MENU) then
        local btn = UIBox_button({minw = 5, button = "brainstorm_reroll_button", label = {"Auto Reroll"}, colour = HEX('4c6be5')})
        table.insert(contents.nodes[1].nodes[1].nodes[1].nodes, 2, btn)
    end
    return contents
end

local createGameOverRef = create_UIBox_game_over
function create_UIBox_game_over()
    local contents = createGameOverRef()
    if not (G.STATE == G.STATES.MENU) then
        local btn = {n=G.UIT.R, config={align="cm", minw=5, padding=0.1, r=0.1, hover=true, colour=HEX('00A000'), button="brainstorm_reroll_button", shadow=true}, nodes={{n=G.UIT.R, config={align="cm", padding=0, no_fill=true, maxw=4.8}, nodes={{n=G.UIT.T, config={text="Auto Reroll", scale=0.5, colour=G.C.UI.TEXT_LIGHT}}}}}}
        pcall(function()
            table.insert(contents.nodes[1].nodes[2].nodes[1].nodes[1].nodes[1].nodes[2].nodes[1].nodes[2].nodes, 1, btn)
        end)
    end
    return contents
end