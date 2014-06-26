Webkit2png in Docker
====================

Story
-----
We had to recently use `webkit2png` in conjunction with a nodejs project..
We also found that `webkit2png` is best run on Debian-based distribution. We primarily use CentOS..

What
----
This image should get you started on using webkit2png in no time!
Spend less time configuring, installing X server, fonts, etc etc.

How to
------
1. run `./build.sh` or just `docker build -t castawaylabs/webkit2png-docker`.
2. Docker builds the image..
3. Run `docker run -d -p 127.0.0.1:2222:22 castawaylabs/webkit2png-docker`

You now have an isolated container listening to port :2222 (bound to localhost).

What next
---------

We used [`fabric`](http://www.fabfile.org/) in conjunction with `node.js` to make screenshots.

Here's how: Node.js invokes fabric, fabric uses ssh to connect to the container and executes some webkit2png commands.

`node -> (exec) -> fabric -> (ssh) -> webkit2png`

Example fabfile
---------------

_note: This may not be strictly functional.. Just an example. Remove the id if not being used.._

Command: `fab -f scripts/create_card.py --password webkit2png -H root@127.0.0.1:2222 getCard:id="cardid"`

`scripts/create_card.py`
```python
from fabric.api import run
from fabric.operations import put, get
import os

def getCard(id):
    # Get CWD
    path = os.path.dirname(os.path.realpath(__file__))
    # Upload .html file from the user
    put(path+'/'+id+'.html', '~/'+id+'.html')
    # Take a screenshot of the card
    run("DISPLAY=:99.0 webkit2png -o ~/" + id + ".png -x 500 250 "+id+".html")
    # Retrieve the card .png
    get(id+'.png', path+'/'+id+'.png')
    # cleanup: delete the .html and .png
    run("rm -f "+id+".png "+id+".html")
```