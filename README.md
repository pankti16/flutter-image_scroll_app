# Picasa

A simple flutter application to display an infinite grid of images from an API.
This application also allows users to share and download images, in addition to opening the source URL in device's default browser.

- Application displays a grid view of images fetched from an API.
- Grid view has pull to refresh functionality and loads 10 images per request, loading additional images as user continues to scroll.
- A long press on image item will show three icons (left-to-right: Open source url in external browser, Download image, Share image)
- Application also detects when user is disconnected from internet and displays a no-internet widget. There is an internet availability check before the API call, failing which it will show the no-internet widget with a retry button. (For instances the users has connectivity but no data). The retry button will be hidden once internet is back, only for the time when there is no images loaded at all.
- The top-right corner has a button with a menu to change application theme. Light, dark or system settings.
- Just for now, image with id will by default show error, to demonstrate error widget. (open url will work, download and share will display an error message.)

## Packages

- google_fonts: ^6.2.1 -> to enable using google fonts without storing them locally. (For now fonts will be loaded only when connected to internet, there is a workaround to make them run offline as well.)
- provider: ^6.1.2 -> for state management throughout the application.
- shared_preferences: ^2.2.3 -> for saving some data in device's memory like selected theme or any other.
- http: ^1.2.1 -> to make API calls.
- cached_network_image: ^3.3.1 -> to show network images with cache support, with facility to show custom widget on error or as a placeholder.
- connectivity_plus: ^5.0.2 -> to check whether device is connected to wifi/mobile data or not. (The package does not really state whether there is internet or not, so for workaround we have our own internet pinging logic along with it, to avoid making API call when no internet.)
- fluttertoast: ^8.2.5 -> to display context free toast message 😅.
- url_launcher: ^6.3.0 -> to open url to an external browser.
- path_provider: ^2.1.3 -> to be able to get a manage path directory.
- permission_handler: ^11.3.1 -> to be able to manage permissions.
- share_plus: ^9.0.0 -> to be able to share image.
- open_file: ^3.3.2 -> to be able to open file when downloading is done, so user does not have to look it up in folder.
- image_gallery_saver: ^2.0.3 -> to refresh gallery/photo/file manager after download.

## Project structure
- components -> All common components for number of reasons (reuse, separate logic & UI, clear code).
  - image_item -> it is an individual item to show in grid view.
  - image_overlay -> to show open url, edit and share button on image long press.
  - infinite_scroll_grid_view -> to show grid of images with pull to refresh and load more.
  - network_child -> to wrap any child with no-internet widget.
  - overlay_container_on_long_press -> widget that uses Overlay and OverlayEntry to show open/edit/share button on long press with all required logic.
- constants -> To store any constants.
  - common_constants -> holds common constant value that can be used throughout the app.
- model -> Data models.
  - image_model -> Model for image item.
- service -> Any network related stuff.
  - image_service -> makes api call to get images.
  - connectivity_service -> using connectivity_plus detects whether user is connected to any network or not.
  - theme_service -> mock service to save and get selected theme from shared preferences.
- state -> All the state related code.
  - common_provider -> handles common state variables like download and share which will notify to show indicator during process.
  - connectivity_provider -> handles data variable that states when api ping fails. (means user is connected to wifi/mobile data, but internet is not available.)
  - pic_image_provider -> handles variables for pagination and list of images with their data.
  - theme_provider -> handles variable for selected app theme. (could be light/dark/system).
- utils -> Any common function/method that can be used anywhere in the app.
  - common_utils -> contains methods for checking internet availability, download logic, share logic.
  - permission_utils -> contains common permission handler method.
- main -> Main entry point of the application, that have base Material app widget and some init configuration.
- theme -> Contains ThemeData for light and dark themes.

## How to build and run app
**Step 1:**

Download or clone this repo by using the link below:

```
https://github.com/pankti16/flutter-image_scroll_app.git
```

**Step 2:**

Go to project root and execute the following command in console to get the required dependencies:

```
flutter pub get 
```

**Step 3:**

Check for any setup or environment relatted issues:
:wq:q

```
flutter doctor -v
```

**Step 4:**

Easier way to run is open it in either VisualStudioCode or AndroidStudio and run the ```main.dart``` file.
Else connect a device and run following command:

```
flutter run
```

**Step 5:**

For building app can either use VisualStudioCode/AndroidStudio or platform specific command:

```
//For Android
flutter build apk
//For iOS
flutter build ios
```
