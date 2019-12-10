# bashmarks_ripoff
Implementation of bashmarks, based on the original

Original bashmarks, by [Huy Nguyen](https://github.com/huyng), can be found [here](https://github.com/huyng/bashmarks).  The idea was to use this as a way to learn shell scripting.

#Installation
Clone this repo and then run ```source bashmarks.sh``` to get a feel for how it works.  To make these commands available in any bash sesion, add the command ```source path/to/bashmarks.sh``` to your bash profile or bash rc (TODO what's the difference between the two?  I know one gets executed every time and one only on login, but which is which?)  


Differences in implementations:
* In the original bashmarks, the bashmarks are stored as environmental variables of the form DIR_name.  In this implementation, we store the bashmarks in a bashmarks file, which gets checked every time a bashmark move is requested.
* The original features tab completion. I haven't implemented that yet here. 

