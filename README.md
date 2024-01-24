# Animals List Application using TCA (The Composable Architecture)

Animals list Screen        |  Facts List Screen
:-------------------------:|:-------------------------:
![](https://i.imgur.com/xoPe4p5.png)  |  ![](https://i.imgur.com/389jJqt.png)

This is a simple iOS application that uses some API to display the animals list with different data. The application displays cells with the all animal data and it's payment status that can be changed. After tapping on cell user can see the different cools facts about provided animals!

## Features
- Main screen displays result of API call: Animals list
- Result cell contains title, subtitle, image and payment info.
- Cell selection action has different scenarios: if status is paid - there will be a confirmation alert that will navigate user to FactsScreen after confirmation, if status is free - user will be navigated to FactsView immediately
- If animal's category doesn't contain any fact about it - the cell is disabled
- On the FactsScreen user can share the fact about animal to different users in comfortable way
## Requirements
- Xcode 15 or later
- iOS 16 or later
## Getting Started
- Clone the repository or download the ZIP file.
- Open the project in Xcode.
- Build and run the project.
## Notes
- The application does not use any third-party libraries except TCA
