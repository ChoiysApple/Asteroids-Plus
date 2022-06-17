<img src="https://user-images.githubusercontent.com/43776784/170163009-244e2c84-585d-4e1a-a55f-8f7a820e8f5d.png" width="10%" alt="this was image">

# Asteroids+
> ** WWDC22 Student Challenge Accepted 🎉**

Endless Asteroids in Swift Playground App

Asteroids, Ship, Bullet, Explosion are all **Vector Image**


<img src="https://user-images.githubusercontent.com/43776784/174206305-e52d9933-b80c-4c70-92d5-b7a03f4f909c.gif" width=500> <img src="https://user-images.githubusercontent.com/43776784/174208219-ca441c05-c3db-437e-86a8-a2d00ea1cae0.gif" width=500>


## Feature
### 1. Asteroids
<img src="https://user-images.githubusercontent.com/43776784/174209282-1247b1f1-1fc5-4b0a-957e-f1f91e74bd2f.gif" width=300>

> ☄️ Asteroids are target to shoot. When you hit by Asteroids, you lose 1 life

There's 3 types of Asteroids: `Big` `Midium` `Small`. When asteroid get hit by bullet, it usually splits into two smaller types of asteroids and in case of `small` asteroid (which is smallest one), it vanished. 

<img src="https://user-images.githubusercontent.com/43776784/174210625-abda72af-bfc3-4a18-97f8-4520541f1efa.jpeg" width=200>

When Asteroid is splited, thier moving direction also changes randomly in 3 types: `Horizontal` `Right Up` `Right Down`
From graph above, `(a,b)` is direction of existing asteroid

</br>

### 2. Waves

<img src="https://user-images.githubusercontent.com/43776784/174211612-97a88e2e-47eb-41fb-bea2-1286cc0f4c91.gif" width=300>

> 🌊 When you destroys all asteroids, you will face harder tiral...

Wen player destroys all asteroids, next wave with **more and faster asteroids** is comming. Speed and number of asteroids are decided by internal formula. Thus, there are endless wave. 

</br>

### 3. Power Ups
<img src="https://user-images.githubusercontent.com/43776784/174212042-b6eb8e7a-0237-44d3-a998-7bd6d6892ec6.gif" width=300> <img src="https://user-images.githubusercontent.com/43776784/174212065-34286151-28b0-4303-9923-e27624354da4.gif" width=300>

> 🔋 The more waves you beat, the more difficult waves are comming. You should be stronger with these Power Ups 
> You can get Power Ups when you beat wave (100%) or hit astroid (with low chance)

**Fire Faster** Makes you to fire faster. This reduce delay between shoots.

**1 more Life** Getting hit by asteroids is inevitable. Recharge more life as much as you can and prepare for harder wave


</br>

## Tech Stack
- SpriteKit
- Swift 5

</br>

## External Source
- Item Sprite: SF Symbols
- Sound Effect: Free Arcade Sound Effects from [mixkit](https://mixkit.co/free-sound-effects/arcade/)
