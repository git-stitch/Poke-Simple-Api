<div align="center">
<a href="https://fontmeme.com/pokemon-font/"><img src="https://fontmeme.com/permalink/201024/cdab2002df4484712c0683cab7f9f6bf.png" alt="pokemon-font" border=""></a>
</div>


**Description**: Welcome to Poke Simple API! This is a dual purpose training project for students, coding newbies, and professional devs that want to dip their toes into Open Source or need a simple API with multiple avenues of data to play with. JSON responses are curated to have the most relevant information first. This takes the overwhelming clutter of data Pokemon has and puts what you want into focus. If your looking to jump into Open Source this project will have issues that range from "New Adventurer" to "Champion". Common beginner issues will include typosss in the documentation and some Pokemon have data that needs to be fixed or added.

**Professor Stein Says**: Let's start your adventure already!

<div>
<img src="https://cdn.bulbagarden.net/upload/thumb/0/04/VSPsychic_PE.png/300px-VSPsychic_PE.png" alt="professor-stein" border="0"> 
</div>

**The Tech stack**:
    
- App: Poke Simple API is written primarily in **Ruby on Rails**. Rails offers a rigid eco-system that makes sure you don't shoot yourself in the foot unknowingly. This can be seen as hand holding but as I've seen dev's usually forget best practices.

- Database: **PostgresDB** pairs well with Rails out of the gate and was essential for speeding up the development process.

- Cache: Pokemon has a lot of reocurring data and if you ask for all the Pokemon at once this call could take a very long time to populate. To combat this we are using **Redis** for our cache support.

- Environment: To take the hassle out of multiple development environments we have opted to use **Docker** for containerization. This could be seen as a barrier to development but, we will have a detailed installation setup to hopefully mitigate this issue. 

**Status**:  Version 1.0.0 and counting. [CHANGELOG](CHANGELOG.md).
  
**Site Coming Soon!**

<div>
<img src="https://cdn.bulbagarden.net/upload/3/35/Y-Comm_Profile_Worker_F.png" alt="y-comm-worker-female" border="0"> 
</div>

**Why Poke Simple API**:
-  Originally Poke API the largest open source Pokemon API didn't have the 8th generation of Pokemon for the last year. I intended to take what I liked from Poke API and fix the things I wish they did better. JSON responses that are easier to read and much less cluttered with information that's not truly necessary. If your trying to make your own Serebii.net then you will need a Pokemon Franchise API and that's what Poke API has become. If your looking for a lighter, dare I say "simpler" Poke API, Poke Simple API has your back. 

  **Example Projects**
    - A team builder with CRUD or 
    - Authorization for your team builder, 
    - Dynamic filtering of Pokemon by types, Gigantamax, abilities etc. 
    - Try your hand at responsive web designs showing 1 pokemon to 10 in a row based on screen size.
    - Build a Pokedex... duh 

## Dependencies

The only dependency in the project is Docker. The docker file will download the correct Ruby image and will also bundle install the gem file for you. The docker-compose file will run the Redis, and Postgres image instances with the correct settings.  

  **To Run Without Docker**
    -[Ruby v2.6.6](https://www.ruby-lang.org/en/downloads/)
    -[Postgres 12](https://www.postgresql.org/download/)
    -[Redis](https://redis.io/download)

## Installation

Installation Documentation Coming Soon...

## Getting involved

This project was made with contributions being one of the focal points. Come one! come all! Let's finish this Dex together. 

Please see the [issues on GitHub](https://github.com/VonStein7/Poke-Simple-Api/issues) before you submit a pull request or raise an issue, nothing new under the sun and all.

Getting Started:

- [Fork the project to your own GitHub profile](https://help.github.com/articles/fork-a-repo/)

- Download the forked project using git clone:

    ```sh
    git clone [your forked link]
    ```

- Create a new branch with a descriptive name:

    ```sh
    git checkout -b my_new_branch
    ```

- Jump into the code. Fix some things, break some things, tell us about it after.

- Commit your code and push it to GitHub

- [Open a new pull request](https://help.github.com/articles/creating-a-pull-request/) and describe the changes you have made.

- We'll accept your changes after review. **Pull Requests will only be accepted with sufficient testing. Unless it's for typos and grammar.**

Check out the full details in our [CONTRIBUTING](CONTRIBUTING.md) file.

<div>
<img src="https://www.serebii.net/Shiny/SWSH/143-gi.png" alt="gigantamax-snorlax" border="0"> 
</div>

----

## Open source licensing info
1. [TERMS](TERMS.md)
2. [LICENSE](LICENSE)
3. [CFPB Source Code Policy](https://github.com/cfpb/source-code-policy/)


----

## Credits and references

1. Poke API thanks for being a great jumping off point.
2. Serebii is a godsend. Where do you guys get your data from?
3. Most importantly the game we all know and love (you better) Pokemon.
