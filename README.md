# event-app

## iOS Final Project Proposal

### Edit: 5/03; These are the parts I have implemented as of now:
1. People using the app will be able to make accounts with usernames and passwords
2. After creating an account, users will be able to log in and come to a screen displaying events that have been posted publicly to the application
3. Users will also be allowed to change account information (username, password, etc.)
4. Upon selecting an event, the app will show a new screen displaying the details of the event (event name, title, description, time, cost, people going) and the user will be allowed to RSVP for the event by pressing a button
5. The event detail screen also has a segue to another screen which will display all the users that have RSVP’d to that event
6. If you select a user’s name on the RSVP’d list, a screen will appear displaying that user’s (public) information.
7. Upon pressing the RSVP button, the current user’s name will be added to the people who have RSVP’d 
8. There will be another screen that will allow users to post comments to the event. All previous comments from all other users will be displayed as well.
9. Users will be able to create their own events as well by specifying the necessary details about their event
10. Users will be able to delete their events so long as they are the user that has posted the event
11.Users will also be able to keep track of all the events they have RSVP’d to

I am missing some things like displaying all of other users' events from the user detail screen and editing owned events. As I am pretty short on time due to other commitments I need to make, I may or may not be able to implement these features before the deadline.

### Use instructions
1. If you want to login using a premade account, here are some accounts you can use:
    - username: dev, password: password
    - username: chriszhang, password: eventapp
2. Otherwise, click on the sign in button on the bottom of the first screen, and fill out all of the required fields to create a new account. Afterwards, log in using the username and password you created.
3a. After logging in, you will be greeted with a landing page with all the events that users have created. If you tap one of the events, you will be greeted with the details of that event, including the ability to view comments, RSVP, and view people who have RSVP'd and their accounts. Otherwise there is a bar button that takes you to the user dashboard (really just options). 
3b. Note that you will only allowed to delete an event if you own it. If you own the event, the delete button changes colors from gray to red.
4. If you are on the screen and can view the people who have RSVP'd, you can also tap their name and their account info will be displayed.
5. You can add comments if you're on the comments table view by tapping the plus button.
6. If you go to the user dashboard from the main landing page, you'll see buttons to create an event, display events you own, display events you've RSVP'd to, and change your account info. I think these are pretty intuitive to figure out, since their views work pretty similarly to the other stuff in the app.

### My Model
Since I didn't realize there was an institutional developer team for Case while creating my data model, and you can't access my Apple account, I've posted screenshots of my Cloudkit dashboard within my submission for your convenience. Please contact me if you need me to show you more. They are in a folder titled "Cloudkit screenshots".
