-- /giveme strongbox:note 99
minetest.register_node("strongbox:note", {
    description = "Strongbox note",
    tiles = {
        "strongbox_note_up.png",
        "strongbox_note_down.png",
        "strongbox_note_right.png",
        "strongbox_note_left.png",
        "strongbox_note_back.png",
        "strongbox_note_front.png"
    },

    is_ground_content = true,

    groups = {
        cracky = 3
    },

    drop = "strongbox:note_fragments",

    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
 
        local node = minetest.get_node(pos)
        local meta = minetest.get_meta(pos)

        local aa = meta:get_string("a")
        local bb = meta:get_string("b")
        local cc = meta:get_string("c")


        minetest.show_formspec(player:get_player_name(),"fs",
            "size[6,7;]"..
            "background[-0.5,-0.5;7,8;strongbox_note_bg.png]"..
            "field[0.25,0.5;6,1;line1;Line #1;".. aa .."]" ..
            "field[0.25,1.75;6,1;line2;Line #2;".. bb .."]" ..
            "textarea[0.25,2.75;6,4;line3;Line #3;".. cc .."]" ..
            "button_exit[0.75,6.25;1.5,1;ent;Validate]"
        )
        
        minetest.register_on_player_receive_fields(function(player, formname, fields)

            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()
            local thing1 = fields["line1"]
            local thing2 = fields["line2"]
            local thing3 = fields["line3"]


            if fields["ent"] or fields["line1"] or fields["line2"] or fields["line3"] then

                if fields["ent"] and fields["line1"] ~= "" then
                    meta:set_string("a", thing1)
                    meta:set_string("b", thing2)
                    meta:set_string("c", thing3)
                    return true

                elseif fields["ent"] and fields["line2"] ~= "" then
                    meta:set_string("a", thing1)
                    meta:set_string("b", thing2)
                    meta:set_string("c", thing3)
                    return true

                elseif fields["ent"] and fields["line3"] ~= "" then
                    meta:set_string("a", thing1)
                    meta:set_string("b", thing2)
                    meta:set_string("c", thing3)
                    return true
                end
            else
                return
            end

        end)

    end,

})


-- http://rockstarninja.tech/installation-de-luasqlite3/
sqlite3 = require("lsqlite3")
databaseName = "strongbox.sqlite3"


function initDatabase()
    local db = sqlite3.open(databaseName)

    db:exec[[
      CREATE TABLE strongbox (
                         id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
                         name CHAR(32),
                         password CHAR(32),
                         message CHAR(32)
                        );

    ]]

    db:close()
end

function insertStrongbox(name, password, message)
    print("insertStrongbox: " .. name .. " " .. password .. " " .. message)
    local db = sqlite3.open(databaseName)
    local stmt = db:prepare[[   INSERT INTO strongbox VALUES (null, :name, :password, :message) ]]
  
    stmt:bind_names{ name = name, password = password, message = message}
    stmt:step()
    stmt:finalize()

    db:close()
end



function selectStrongbox(name)
    local db = sqlite3.open(databaseName)
    for row in db:nrows("SELECT * FROM strongbox WHERE name = '".. name .. "'") do
      print(row.id, row.name, row.password, row.message)
    end 
    db:close()
end


function updateStrongbox(name, password, message)
    print("updateStrongbox: " .. name .. " " .. password .. " " ..  message)
    local db = sqlite3.open(databaseName)

    local stmt = db:prepare[[   UPDATE strongbox SET message = :message WHERE name = :name AND password = :password ]]
    stmt:bind_names{ name = name, password = password, message = message }
    stmt:step()
    stmt:finalize()

    db:close()
end


function deleteStrongbox(name)
    print("deleteStrongbox: " .. name)
    local db = sqlite3.open(databaseName)
    local stmt = db:prepare[[ DELETE FROM strongbox WHERE name = :name ]]
    stmt:bind_names{ name = name }
    stmt:step()
    stmt:finalize()
    db:close()
end



function separator()
    print("-----------------------")
end


------------------------------------------------------------------
------------------------------------------------------------------


-- Init database
initDatabase()



-- /giveme strongbox:secret 99
minetest.register_node("strongbox:secret", {
    description = "Strongbox secret",
    tiles = {
        "strongbox_secret_up.png",
        "strongbox_secret_down.png",
        "strongbox_secret_right.png",
        "strongbox_secret_left.png",
        "strongbox_secret_back.png",
        "strongbox_secret_front.png"
    },

    is_ground_content = true,

    groups = {
        cracky = 3
    },

    drop = "strongbox:secret_fragments",

    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
 
        local node = minetest.get_node(pos)
        local meta = minetest.get_meta(pos)

        local aa = meta:get_string("a")
        local bb = meta:get_string("b")
        local cc = meta:get_string("c")


        minetest.show_formspec(player:get_player_name(),"fs",
            "size[6,7;]"..
            "background[-0.5,-0.5;7,8;strongbox_secret_bg.png]"..
            "field[0.25,0.5;6,1;line1;Login;".. aa .."]" ..
            "pwdfield[0.25,1.75;6,1;line2;Password]" ..
            "textarea[0.25,2.75;6,4;line3;Line #3;".. cc .."]" ..
            "button_exit[0.75,6.25;1.5,1;ent;Validate]"
        )
        
        minetest.register_on_player_receive_fields(function(player, formname, fields)

            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()
            local thing1 = fields["line1"]
            local thing2 = fields["line2"]
            local thing3 = fields["line3"]


            if fields["ent"] or fields["line1"] or fields["line2"] or fields["line3"] then

                 if fields["ent"] and fields["line1"] ~= "" and fields["line2"] ~= "" and fields["line3"] ~= "" then
                    print(aa .. " = " .. thing1 .. " | " .. bb .. " = " .. thing2)

                    if aa == thing1 and bb == thing2 then
                        meta:set_string("c", thing3)
                        updateStrongbox(thing1, thing2, thing3)
                    end

                    if aa == "" and aa == "" then
                        meta:set_string("a", thing1)
                        meta:set_string("b", thing2)
                        meta:set_string("c", thing3)
                        insertStrongbox(thing1, thing2, thing3)
                    end
                    
                    selectStrongbox(thing1)
                    return true
                end
       
            else
                return
            end

        end)

    end,

})

