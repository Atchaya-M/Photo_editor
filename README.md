This project is a Flutter application for a Photo Editor App.

Libraries Used:
- The code utilizes the `dart:html` library for working with HTML elements and Blob data.
- It also uses the `image` package for image processing tasks, including decoding, encoding, and applying filters to images.

Functions and Methods:
1. `_selectImage()`: This function allows the user to select an image from their device's storage. It uses the `FileReader` to read the selected image file and store its bytes in the `_imageBytes` variable.

2. `_applyFilter()`: This function is responsible for applying a grayscale filter to the selected image. It decodes the image bytes, applies the grayscale filter using the `image` package, and then encodes the modified image back to PNG format, storing the result in the `_editedImageBytes` variable.

3. `_saveImage()`: This function handles the process of saving the edited image. It creates a Blob from the edited image bytes, generates a download URL, creates an anchor element with the download attribute set to the image file name, and triggers a click event to download the image. After the download is initiated, the anchor element is removed, and the URL is revoked.

4. `_buildImage()`: This method returns a widget that displays the selected image and the edited image (if available) using the `Image.memory` widget. If no image is selected, it displays a placeholder.

5. `build(BuildContext context)`: This is the main build method of the app, which constructs the UI using a Scaffold with an AppBar and a body containing image display, buttons for image selection, filter application, and image saving, as well as a progress indicator when processing is ongoing.

Therfore, the app provides a simple user interface for selecting, editing, and saving images. It leverages the `image` package for image processing and the `dart:html` library for handling file operations and interactions with HTML elements.
