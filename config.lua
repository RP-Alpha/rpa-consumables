Config = {}

Config.Consumables = {
    ['sandwich'] = {
        type = 'food',
        hunger = 50,
        model = 'prop_sandwich_01',
        animation = 'eat'
    },
    ['water'] = {
        type = 'drink',
        thirst = 50,
        model = 'prop_ld_flow_bottle',
        animation = 'drink'
    },
    ['whiskey'] = {
        type = 'alcohol',
        thirst = 20,
        stress = -15,
        model = 'prop_drink_whisky',
        animation = 'drink'
    },
    ['beer'] = {
        type = 'alcohol',
        thirst = 15,
        stress = -10,
        model = 'prop_amb_beer_bottle',
        animation = 'drink'
    },
    ['joint'] = {
        type = 'smoke',
        stress = -25,
        model = 'prop_sh_joint_01',
        animation = 'smoke'
    }
}
