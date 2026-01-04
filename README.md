# rpa-consumables

<div align="center">

![GitHub Release](https://img.shields.io/github/v/release/RP-Alpha/rpa-consumables?style=for-the-badge&logo=github&color=blue)
![GitHub commits](https://img.shields.io/github/commits-since/RP-Alpha/rpa-consumables/latest?style=for-the-badge&logo=git&color=green)
![License](https://img.shields.io/github/license/RP-Alpha/rpa-consumables?style=for-the-badge&color=orange)
![Downloads](https://img.shields.io/github/downloads/RP-Alpha/rpa-consumables/total?style=for-the-badge&logo=github&color=purple)

**Advanced Item Consumption Handler**

</div>

---

## ✨ Features

- 🍔 **Food & Drinks** - Hunger/thirst restoration
- 🍺 **Alcohol Effects** - Drunk walking, screen blur
- 🚬 **Smokeables** - Props, particles, stress relief
- 🎬 **Animations** - Item-specific usage animations

---

## � Dependencies

- `rpa-lib` (Required)

---

## 📥 Installation

1. Download the [latest release](https://github.com/RP-Alpha/rpa-consumables/releases/latest)
2. Extract to your `resources` folder
3. Add to `server.cfg`:
   ```cfg
   ensure rpa-lib
   ensure rpa-consumables
   ```

---

## ⚙️ Configuration

```lua
Config.Consumables = {
    ['sandwich'] = {
        type = 'food',
        hunger = 50,
        model = 'prop_sandwich_01',
        animation = 'eat'
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
```

### Item Types

| Type | Effects |
|------|--------|
| `food` | Restores hunger |
| `drink` | Restores thirst |
| `alcohol` | Thirst + stress relief + drunk effects |
| `smoke` | Stress relief + particles |

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

<div align="center">
  <sub>Built with ❤️ by <a href="https://github.com/RP-Alpha">RP-Alpha</a></sub>
</div>
