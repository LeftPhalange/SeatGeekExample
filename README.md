# SeatGeekExample

This iOS app was written in Swift and UIKit to deliver event information from the SeatGeek API.

## How to run it
Open the SeatGeekExample.xcodeproj in the root directory using Xcode (tested with 12.4, 12D4e). Before you can run it, take note of the Seatgeek.swift file in the directory. There are fields in there consisting of the API-specific client ID and client secret. Replace those placeholder strings with those that work with the API. After that, you can debug it with the emulator of your choice.

## What works?

- Searching based on event (token-based)
- Fetching and deserializing JSON data and presenting it in a pleasing way

## What can be improved

I have not made myself familiar with the ways of Core Data within iOS 14, as I've ran into a snag trying to bring the window variable from the AppDelegate into the root view controller. As of iOS 14 it seems like the variable is now in the SceneDelegate, so for now that is a to-do item in the future should this continue.

Another issue that arose is the like state of each cell, while they do pass over to the DetailViewController, the first cell always doesn't. Something to look at for another day.
