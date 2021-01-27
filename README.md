# IoT Pet Feeder

This is a project created for a class called IoT. It is a simple automatic pet feeding device that connects to an application on your mobile device through a custom API. 
The mobile application was written in Swift for iOS, the API was written in C#/.NET Core, and the pet feeder device was written in C++ using the Arduino IDE. 
The pet feeding device is controlled by an ESP32.

# iOS Application

The application that allows the user to control the pet feeder was written in Swift for iOS.
The user may add a feeder by ID and can either manually feed or set a custom schedule for feeding.
The application talks to the custom API which then talks to the feeder device over the internet.

# C# .NET Core API

The backend for the project was written in C#.
This API would handle all data coming from the iOS application and the pet feeder device.
The API would keep track of all user set schedules and manual feeds, aswell as feeders and user accounts.
An authentication and authorization system was implemented through JSON web tokens to keep the backend secure.
The backend was deployed to Azure so it could be demonstrated to the class within the presentation.

# Pet Feeder Device

The device's microcontroller was the ESP32. This was programmed within the Arduino IDE.
Due to COVID-19, the maker space on campus was inaccessible and a device was never created.
However the code was developed for the ESP32 and displayed adequate functionality of the feeder working properly with the API and iOS app.

# Demo

A demonstration was created for the class presentation while the backend was temporarily deployed to Azure.
Here is a link to the video demonstration:
https://www.youtube.com/watch?v=q3t9_RaxsX0

# Credits

Jonathan Fletcher: Developed iOS application, developed API and helped develop feeder device code.
Tram Nguyen: Helped develop feeder device code.
Justin Luong: Designed pet feeder device and mechanisms.
