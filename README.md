# event-app
EDIT 4/22 - There is a small bug with the login screen where you have to press the login button more than once in order to actually log in. I believe that this has something to do with the asynchronous completion handler for querying CloudKit not always loading the user data before pressing the button, but I am currently unable to fix it. If you're sure your username and password are correct, just keep pressing the login button and it should work eventually.

# iOS Final Project Proposal

# a) What you want to develop (i.e., the main goal of your app)? what are already available out there? If there are already apps for the same purpose, why you want to re-develop it (market analysis)? Will it be free or you want to sell it (business model)? How much is your cost (e.g. time), will you be able to recover the cost? What is your expected profit within one year of your release?

I will be developing an app that allows users to host, organize, and advertise their events, gatherings, etc. This is similar to apps out there like Facebook events, Eventbrite, etc. 
Since the functionality of my app will not differ too much from what is already out there, I will mostly be developing this for personal educational purposes (i.e. learn how to manage user data across networks/multiple devices, how to let users interact with each other through the app, etc.). The format is familiar to me, and I think that the skills I learn developing this app will be incredibly useful for developing future applications in industry/startup. 
This application will be free, and I expect it will take me roughly 2 to 3 weeks to develop the basic functionalities (or however long I have until this is due). I doubt I will be able to recover the monetary cost, since I do not expect to be making much profit within one year of the release.


# b) The main functionalities of your app. You can provide a list with brief explanation. You can discuss with me about the scope/effort to implement those functions if needed. 

Functionalities:
- People using the app will be able to make accounts with usernames and passwords
- After creating an account, users will be able to log in and come to a screen displaying events that have been posted publicly to the application
- Users will also be allowed to change account information (username, password, etc.)
- Upon selecting an event, the app will show a new screen displaying the details of the event (event name, title, description, time, cost, people going) and the user will be allowed to RSVP for the event by pressing a button
- The event detail screen also has a segue to another screen which will display all the users that have RSVP’d to that event
- If you select a user’s name on the RSVP’d list, a screen will appear displaying that user’s (public) information. This will also display any event listings that the user has posted.
- Upon pressing the RSVP button, the current user’s name will be added to the people who have RSVP’d 
- There will be another screen that will allow users to post comments to the event. All previous comments from all other users will be displayed as well.
- Users will be able to create their own events as well by specifying the necessary details about their event
- Users will be able to delete/edit their events so long as they are the user that has posted the event
- Users will also be able to keep track of all the events they have RSVP’d to


# Stretch Goals (these may or may not be implemented depending on time. I can move some of these to functionalities if you think the scope of my app isn’t large enough)
- Create an upvote/downvote system that allows users to vote on whether or not they like an event posting or not. The main screen showing all events will be a table view that can be sorted from most to least upvotes and vice versa.
- Integrate MapKit into the application. If the location of the event can be found using the map API, then display a map in the event detail screen with an annotation at the event location. Also, calculate distance between the user and the event, and add feature to sort events based on distance
- Automatically delete events which have expired based on time from the databases 
- Allow users to upload images of their event, since CloudKit databases support assets as well. Display these images somewhere in the event detail screen
- Allow users to private message each other users
