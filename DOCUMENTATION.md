# Table of contents

- [Disclaimer](#disclaimer)
- [Cards](#cards)
    - [Effects](#effects)
    - [Status](#status)
- [Entity](#entity)
- [Map](#map)
    - [Rooms](#rooms)
    - [Events](#events)
    - [Light mechanic](#light-mechanic)
- [Animation](#animation)

# Disclaimer

This documentation is not meant as an in-depth explanation of every function. It is meant as a general overview of the classes, their functions and how they interact. 

For more information, please refer to the source code.

# Cards

A card is a description, an art, and data to play the effects of the card

## Effects

Effects are the basis of the interactio, between the card and the game. Let's take an example right away:

Slap : Deal 1 damage to the target

This card has one effect, it is an `EffectDamage`, with a value of 1. The effects are held inside a wrapper, `EffectData`, which holds the effect, the value of the effect and other informations. The idea between the effect structure is that it is easy to stack as many effects as you want on your card. For example:

Vampire poison sting (card that doesn't exist btw): Deal 1 damage to all enemies, inflict 3 poison to the target and heal yourself for 2 HP.

All the `EffectData` (there are 3 here) are held inside the `card_effects_data` array of the card. The card will then loop through the array and play the effects one by one, ie an `EffectDamage`, an `EffectPoison` and an `EffectHeal` on the relevant targets.

## Targeting system

WiP

## Status

`Status` is the way we deal with conditions on a character that stays on them for multiple turns. For example, poison, weakness, strength... There are 2 catergories of `Status`, which are `Buff` and `Debuff`. The difference between effects and status is that effects do something when a card is played and status do something at a given time in the turn. The `EffectPoison` applies a `DebuffPoison` to the target.

Each `Entity` has an array of Status where we store said `Status`. At the start of the turn of each entity, the `Status` inside the array are applied (and the number of turns left is decreased by 1, if the status is not for the entire duration of the fight). Note that conditions that carry between fights (such as conditions provided by relics) do not qualify as `Status`, they are handled differently.

# Entity

# Map

## Rooms

## Events

## Light mechanic

# Animation
