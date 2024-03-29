# Shopping App

This app enables multiple users to manage a shopping list and marks, which user added which product at a specific point of time. Therefore, each user can register himself using an email address and a password.

This app uses Dart and Flutter to run an app on iOS and Android. 
The backend works with Firebase. The products of the shopping list are stored in a Firebase Realtime Database. To fetch and update the products, the app communicates with Firebase through a REST API. The authentication is managed by Firebase Authentication. 


## Features:

### 1. Authentication:

| Functions  | UI  |
| ------------- | ------------- |
| 1.1 Registration for a user | ![](https://github.com/LarsDman/ShoppingAppFlutter/blob/main/Gifs/Registration.gif) |
| 1.2 Login & Authentication for a user  | ![](https://github.com/LarsDman/ShoppingAppFlutter/blob/main/Gifs/Login.gif)  |

### 2. Shopping list:
| Functions  | UI  |
| ------------- | ------------- |
| <ul><li>2.1 Add products to shopping list based on recommendations of already bought products</li><li>2.2 Reorder products in shopping list:</li><li>2.3 Remove unavailable products from shopping list:</li><li>2.4 Remove available products from shopping list:</li><li>2.5 Update products, if users use the list at the same time:</li></ul> | ![](https://github.com/LarsDman/ShoppingAppFlutter/blob/main/Gifs/Functions.gif)  |

### 3. Settings:

| Functions  | UI  |
| ------------- | ------------- |
|<ul><li>3.1 Option to enable auto login and skip the login step or disable it:</li><li>3.2 Delete recommendations:</li></ul>|![](https://github.com/LarsDman/ShoppingAppFlutter/blob/main/Gifs/Settings.gif)|
