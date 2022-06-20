<img src="https://user-images.githubusercontent.com/43776784/170163009-244e2c84-585d-4e1a-a55f-8f7a820e8f5d.png" width="10%" alt="this was image">

# Asteroids+
> ** WWDC22 Student Challenge Accepted 🎉**

Endless Asteroids in Swift Playground App [Gameplay Demo](https://youtu.be/OffJ0KTX0mI)  

<img src="https://user-images.githubusercontent.com/43776784/174206305-e52d9933-b80c-4c70-92d5-b7a03f4f909c.gif" width=45%> <img src="https://user-images.githubusercontent.com/43776784/174208219-ca441c05-c3db-437e-86a8-a2d00ea1cae0.gif" width=45%>

</br>

## Feature
### 1. Asteroids
<img src="https://user-images.githubusercontent.com/43776784/174209282-1247b1f1-1fc5-4b0a-957e-f1f91e74bd2f.gif" width=300>

> ☄️ Asteroids are target to shoot. When you hit by Asteroids, you lose 1 life

#### Movement
Asteroids are spawned with **random position & movement direciton** every beginning of waves. If asteroids goes out of screen, it appears at opposite side of screen.  
_**i.e**. When asteroid goes off screen at `right-top point`, it appears at `left-bottom` of screen again_ 

#### Hit & Split 
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
> 
> You can get Power Ups when you beat wave (100%) or hit astroid (with low chance)

**Fire Faster** Once you shot bullet, you need to wait until gun is reloaded. Makes you to fire faster. This reduce delay between shoots.

**1 more Life** Getting hit by asteroids is inevitable. Recharge more life as much as you can and prepare for harder wave

</br>

### 4. HUD & Visual Effects

#### HUD  
<img src="https://user-images.githubusercontent.com/43776784/174225017-6ce40061-5b28-4d72-a26d-c868f6b2c819.gif" width=250> <img width="300" alt="left" src="https://user-images.githubusercontent.com/43776784/174225027-48d6fc8f-48ec-4c72-a64b-f4075d434f6c.png"> <img src="https://user-images.githubusercontent.com/43776784/174224782-3f1c602a-ee7c-46b6-8b3e-29fd76a3e91d.gif" width=180>

> Score & Life | Asteroids Left | Backlog
- **_Score & Life_** Display current Score & Life left
- **_Asteroids Left_** Display number of Asteroid left. Bacuse some asteroid split into 2 when get hit, usually number of asteroid increses
- **_Backlog_** Notice events to user `Wave Starts` `Get Power Ups`

#### Visual Effects  
<img src="https://user-images.githubusercontent.com/43776784/174225835-74d29374-2c95-4cbc-a8c4-1d5d696cb3c3.gif" width=200> <img src="https://user-images.githubusercontent.com/43776784/174225848-746ffcf7-5360-475b-b8d6-3210bfc4dc9a.gif" width=180>

> Loaded | Explosion
- **_Loaded_** Ship color represents bullet availability. `White`-> Can shoot / `Black` -> Need to wait
- **_Explosion_** Notice every Asteroid Collision (Hit by bullet, hit ship, Destroyed) using explosion effect

</br>

## Installation
Download playground app from [here](https://github.com/ChoiysApple/Asteroids-Plus/releases/tag/Release)

### 1. Using iPad Swift Playgrounds
1. **Download** `Asteroid.swiftpm`. If you are not downloded from iPad, **put this file into iPad**
2. Download Swift Playground from App Store and open.
3. Tap "Location" (It's on Top left of playground app)
4. Navigate and Select `Asteroid.swiftpm`
5. Tap **"Asteroid"** from main screen (aka my playgrounds)
6. Tap `▶︎` 

### 2. Using Xcode
1. **Download** `Asteroid.swiftpm`
2. Run project using `iPad` Device or Simulator 

</br>

## Coordinates for Sprite

Asteroids, Ship, Bullet, Explosion are all **Vector Image**

- [Asteroids](https://github.com/ChoiysApple/Asteroids-Plus/blob/1838daa20c68676b00bd9d148dcf7ff7588ab4cd/Asteroid.swiftpm/Data/AsteroidType.swift#L13) - 3 types of shapes
- [Ship](https://github.com/ChoiysApple/Asteroids-Plus/blob/1838daa20c68676b00bd9d148dcf7ff7588ab4cd/Asteroid.swiftpm/Data/Shapes.swift#L16)
- [Explosion](https://github.com/ChoiysApple/Asteroids-Plus/blob/1838daa20c68676b00bd9d148dcf7ff7588ab4cd/Asteroid.swiftpm/Helper/Animation.swift#L48) Animation destination coordinates

</br>

## Minimum Requirements  
This app is developed for `iPad`
- iPadOS 15
- MacOS 15

</br>

## Tech Stack
- SpriteKit
- Swift 5

</br>

## External Source
- Item Sprite: SF Symbols
- Sound Effect: Free Arcade Sound Effects from [mixkit](https://mixkit.co/free-sound-effects/arcade/)

</br>

</br>


# And...
If you get higher score, leave PR

<img src="https://user-images.githubusercontent.com/43776784/174228767-17aec793-922c-4fdd-bbd7-95a980f267b5.jpeg" width=500>

