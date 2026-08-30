# Astro Pandit

This is a flutter app i made for finding zodiac sign (horoscope) from date of birth. Made this as practice project to learn Forms and TextEditingController in flutter.

## What it does

- Takes your Name and Date of Birth as input
- When you click Submit button it checks the date and tells your zodiac sign (like Leo, Aries etc)
- Shows the answer in a box below

## How to run

1. Open the project in Android Studio / VS Code
2. Run this command to get packages
```
flutter pub get
```
3. Then run
```
flutter run
```
(make sure emulator is running or phone connected)

## How to use the app

- Enter your name in first box
- Enter DOB in second box like this format: `15/8` (date/month)
- Click Submit
- Your zodiac sign will show in the last box

Note: if you dont fill the boxes it will show error "Please Enter Name" etc, that is the form validation part.

## Logic used

I used simple if conditions to check date and month and match with zodiac date ranges. Like if date is between 21-31 and month is 3 then its Aries. Did this for all 12 signs. Its a bit long code with many if statements but it works fine.

## Things I know are not perfect (need to fix later)

- If you enter wrong format date (like using - instead of /) app will crash, not handled that yet
- Should use a proper date picker instead of typing manually, will do that in next version
- The image on top is loaded from internet link, if no internet it might not show
- No submit confirmation snackbar (commented it out in code for testing)
- Add AI API so that is can further actually predict future based on zodiac calculations.
