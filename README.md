# EVERYTHING YOU HAVE TO KNOW!

This tutorial will explain everything up to settings and important commands.

**I know that's hard because my executor, lacks WS (WebSocket) support. Which is pretty useful for real-time access with an interface and better communication between the bots. And I cannot afford Synapse, which has those abilities. **

Even if the script doesn't have the best abilities cuz a lack of features with executors, it still works and maybe can reach more people.

### Content

1. Tutorial
2. Warnings
3. How does it work?
4. FAQ

#### Tutorial

1. Before injecting it, you have to edit permissions. Go ahead and add yourself as an Owner. EX: `{"user1","user2,"user3"}`
2. Add all of your bots' names to the Bot_Nicknames.
3. **Only** inject it to the alt accounts.
4. That's all. Your bots should give a message together if it works.

#### Warnings

1. Never, but never inject this script to the manager (The account you will control from)

#### How does it work?

The communication between the bots and their manager is pretty hard because of the low choices of client communication. As we don't have WS or serverside, we use the chat system for communication.
For example, when the manager tells a command, all bots could take it individually and act like it, so It creates an effect of you controlling all of them.
For a follow command, you could just list all of them and give them a number and make them position based on their number (ex. 4 = globalMake*4). And they will take it individually as well.

#### FAQ

1. How to make alts?
   > Use alt manager
2. How can I inject them all?
   > Use an executor that supports multiple instances.
   
