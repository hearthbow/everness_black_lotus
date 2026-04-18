local function register_black_lotus()

    local base_def = {
        drawtype = 'mesh',
        mesh = 'everness_lotus_flower.obj',
        paramtype = 'light',
        paramtype2 = 'meshoptions',
        place_param2 = 8,
        sunlight_propagates = true,
        walkable = true,
        buildable_to = true,
        groups = {snappy=3, flower=1, flammable=1},
        sounds = default.node_sound_leaves_defaults(),
        light_source = 3,
        use_texture_alpha = 'blend'
    }

    -- NORMAL
    local def = table.copy(base_def)

    def.description = "Black Lotus"
    def.tiles = {
        { name = "black_lotus_mesh.png" },
        { name = "everness_lotus_flower_mesh_not_animated.png" }
    }
    def.inventory_image = "black_lotus_item.png"
    def.wield_image = "black_lotus_item.png"
    
    def.on_construct = function(pos)
    minetest.get_node_timer(pos):start(1)

    minetest.after(0.1, function()
        local timer = minetest.get_node_timer(pos)
        if not timer:is_started() then
            timer:start(1)
        end
    end)
end

    def.on_timer = function(pos)
        if minetest.get_node_light(pos) <= 11 then
            minetest.set_node(pos, { name = "everness_black_lotus:black_lotus_animated" })
        end
        minetest.get_node_timer(pos):start(math.random(25,35))
    end

    minetest.register_node("everness_black_lotus:black_lotus", def)

    -- ANIMATED
    local def_anim = table.copy(def)

    def_anim.description = "Black Lotus (Glowing)"
    def_anim.tiles = {
        { name = "black_lotus_mesh.png" },
        {
            name = "black_lotus_mesh_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 64,
                aspect_h = 32,
                length = 2
            }
        }
    }
    def_anim.light_source = 6
    def_anim.drop = "everness_black_lotus:black_lotus"
    def_anim.groups.not_in_creative_inventory = 1
    
    def_anim.on_construct = function(pos)
    minetest.get_node_timer(pos):start(1)

    minetest.after(0.1, function()
        local timer = minetest.get_node_timer(pos)
        if not timer:is_started() then
            timer:start(1)
        end
    end)
end

    def_anim.on_timer = function(pos)
        if minetest.get_node_light(pos) > 11 then
            minetest.set_node(pos, { name = "everness_black_lotus:black_lotus" })
        end
        minetest.get_node_timer(pos):start(math.random(25,35))
    end

    minetest.register_node("everness_black_lotus:black_lotus_animated", def_anim)

end

register_black_lotus()

minetest.register_lbm({
    name = "everness_black_lotus:start_timer",
    nodenames = {
        "everness_black_lotus:black_lotus",
        "everness_black_lotus:black_lotus_animated"
    },
    run_at_every_load = true,
    action = function(pos)
        local timer = minetest.get_node_timer(pos)
        if not timer:is_started() then
            timer:start(1)
        end
    end
})



minetest.register_abm({
    label = "Corrupt White Lotus",
    nodenames = {"everness:lotus_flower_white"},
    neighbors = {"everness:cursed_dirt"}, -- adjust if needed
    interval = 10,
    chance = 4,

    action = function(pos)
        minetest.set_node(pos, {
            name = "everness_black_lotus:black_lotus"
        })
    end
})


