# rpa-consumables

Advanced item consumption handler with visual effects and perks.

## Features
- **Items**: Food, Drink, Alcohol, Smokeables.
- **Effects**: Drunk walking styles, screen blur, particle effects (smoke), stress relief.
- **Props**: Attaches correct props (bottles, cigarettes) to ped during animation.

## Installation
1. Ensure `rpa-lib` is started.
2. Add `ensure rpa-consumables` to your `server.cfg`.

## Configuration
Add new items to `config.lua`:
```lua
['beer'] = {
    type = 'alcohol',
    thirst = 15,
    stress = -10,
    model = 'prop_amb_beer_bottle',
    animation = 'drink'
}
```

## Credits
- RP-Alpha Development Team

## License
MIT
