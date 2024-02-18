# Celebrated
A birthday reminder and card-sharing app for individuals, families and organizations. Built-in flutter with a modified MVC pattern and strong adherence to S.O.L.I.D principles. 
The app comes with another server application with cloud functions for sending reminders, check it out  [here](https://github.com/RodrickVy/celebrated_service).

## Contents
* [1 App Features](#1)
* [2 Project structure](#2)
* [3 Tech Stack](#3)
 


## <a name="1"></a>App Features
For a more detailed breakdown check out - [this doc here](https://docs.google.com/document/d/1QWqqVyUoniQAwhGb1toJ4gVX_i6NNbCs5eygzvI7uwA/edit?usp=sharing)

- Account: Sign up with verification, edit profile details, sign in, set app settings, and report issues via system or Google Forms.
- Home: Manage Birthday Wish List, view stats and testimonials, and engage with the app's community.
- Lists: Create, edit, and manage birthday lists; import contacts; share reminders and notifications.
- Cards:  Create, edit, and send virtual cards; select templates; invite others to sign; customize messages and send times.

## <a name="2"></a>Project structure
In this project, the naming convention aligns with the business case, following a screaming architecture approach where each feature is organized into its own directory. These feature directories are further categorized into controller, model, and view subdirectories. Additional components such as adapters, services, and requests are included as needed.

- **Controller**: Manages UI logic.
- **View**: Contains UI widgets.
- **Service**: Incorporates third-party services (e.g., repositories, authentication) and computationally intensive modules.
- **Model**: Defines data models.
- **Adapter**: Handles serialization to and from JSON.
- **Interface**: Establishes a layer between UI and Controller, implementing a command pattern.
- **Domain**: Located in the util folder, this includes domain-level use case agnostic models and interfaces that are fundamental to controllers and services, featuring validators and widget-controller interfaces.

## <a name="3"></a> Tech Stack 
- Firebase for authentication, Firestore, hosting, and functions.
- GetX for state management and navigation.

   

