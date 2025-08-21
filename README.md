# Echowater
Echowater is a flutter application that helps you track the amount of water usage i.e. consumption based on the cycle run(Cycle run is a process of enfusing H2 molecules in the water inside flask) in the flask itself. Here the Flask is a BLE enabled water bottle which also has a button to start a cycle. Cycle can be run from the button in the flask or can be run by sending command from the Echowater Mobile application once the flask is paired in the app i.e. registered.

## Getting Started

1. Clone the project first. 
   
   To give a brief inromation about the folder structure of the project. The main root directory of the project wraps the actual app folder which contains the project. The reason for this is to create a standard on folder structure of the project itself where it contains the `.github` folder containing the github action files along with other files related to CD pipeline.

2. Install the dependencies:
   
    ```
    cd app
    flutter pub get
    cd ios pod install (in case you are using apple silicon macs)=> arch -x86_64 
    cd ..
    ```
    
3. We have .vscode folder which has necessary configurations to run/debug the project in all configurations.
    ```
    dev-debug
    dev-release
    uat-debug
    uat-release
    prod-debug
    prod-release
    ```
4. Configuring environment variables
   There exists environment variable example `.example.env` file inside the app folder of the project. Create 3 new env files such as:
    ```
    .dev.env
    .uat.env
    .prod.env
    ```
    Get the details of these from your project manager or the lead developer of the team.

5. Run the project in dev environment.

## Coding guidenlines and Branching Strategy:
The coding guidelines and branching strategy can be found here: 

https://outcodesoftware-my.sharepoint.com/:w:/p/ashwin_shrestha/EWq2GUm8k91Bi1ftShjzBSIBn8o98yM3F5YyInp1-g_8-A?e=EUCJjD

## Contribution and Release Tagging
1. Create a new branch from the current release.
   
   For example: `main` branch will always have the latest and updated codebase from last release. The releases are tagged as well in the form of semetic versioning. 

   Suppose version 0.0.1 are released in both ios and android. We merged everything from develop to main and create a new tag 0.0.1.
   Now if ios had some platform specific issue and we release v 0.0.2 in iOS, once it's sent to app store view and approved and release, we create a PR from develop to main, and then create new tag 'ios-0.0.2'

2. Before sending app to testflight and release review tag the release candidate accoringly i.e. `rc-andorid-0.0.3` or `rc-ios-0.0.3`
   



   



