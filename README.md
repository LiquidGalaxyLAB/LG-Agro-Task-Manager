# LG Agro Task Manager

## About
Agro Task Manager for Liquid Galaxy application will let you simulate tasks that an Agro-Robot would perform and visualize them on Liquid Galaxy.
The user is also able to introduce many different crops to a Database and get reminded when they have to plant, transplant or harvest them.
The things that can be visualized on Google earth are:
- The current task that is being done, with the place of realization and the robot which is doing it
- The tasks that the user has to do in the season,

LG Agro Task Manager is an application created for Google Summer of Code 2024, featuring their Liquid Galaxy.
Developed by Davit Mas, mentored by Víctor Carreras and directed by Andreu Ibàñez.

## Requirements
- The application requires an SDK from 21 to 34.
- If you wish to use the app to its full potential, make sure to use it with a [Liquid Galaxy](https://github.com/LiquidGalaxyLAB/liquid-galaxy)!

## Setting up the app
To begin running this app, clone this repository into your computer. Then, you should get yourself a Google Maps API Key following these steps:
1. Visit [this site](https://developers.google.com/maps/documentation/android-sdk/get-api-key) for instructions
2. Go to android/app/main/AndroidManifest.xml
3. Inside the <meta-data/> section, paste the following code:
```
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY" />
```

## Running the app
Once you've done all the steps to set up the app, you only have a couple of steps left.
1. Go to your project directory on the terminal.
2. Use ``` flutter pub get ```
3. Make sure you've got a tablet device connected to your pc. 
4. Use ``` flutter run ```



