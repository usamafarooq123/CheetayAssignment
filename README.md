# CheetayAssignment


# Cheetay Assignment - Movie App

This is a movie app that utilizes an API to provide various functionalities for users. It follows the Model-View-ViewModel (MVVM) architecture with a Router component for navigation.

### User Stories

The app includes the following required functionality:

- User can view a list of movies.
- User can like a movie.
- User can unlike a movie.
- User can search for a movie.
- User sees a dummy image while images are loading or if there is no image URL available.
- Scrolled posts are cached for offline viewing.
- Liked posts are cached.
- Search history is cached with valid searches.
- Users see an error message when there is any error coming from the API.
- When a user scrolls to the bottom of the list, new data is loaded from the server if available<b>(Pagination)</b>.
- When a user enters a movie name that doesn't exist, an error message is shown indicating that no movie was found.
- User can view the last 10 valid searches.
- User can view liked movies.
  ## Architecture

<b>The app follows the Model-View-ViewModel (MVVM) architecture with a Router component for navigation.</b>

### Model:
The Model represents the data and business logic of the application. It encapsulates the movie data, caching mechanisms, and API communication.
### View:
The View represents the user interface (UI) elements and their layout. It includes screens for displaying the movie list, movie details, search functionality, and error messages.
### ViewModel:
The ViewModel acts as an intermediary between the Model and the View. It retrieves movie data from the Model, formats it for the View, and provides methods for handling user actions such as liking a movie, searching, and fetching new data.
### Router:
The Router handles navigation within the app. It is responsible for transitioning between different screens and coordinating the flow of the app.

### Pods
- kingfisher

### Language
 - Swift 
### Code Documentation 

[CheetayAssignment.doccarchive.zip](https://github.com/usamafarooq123/CheetayAssignment/files/11995288/CheetayAssignment.doccarchive.zip)







