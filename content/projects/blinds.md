---
title: "Blinds for Homekit / Web"
date: 2018-11-14T22:08:47Z
draft: false
---
For a long time we already had an automation for our blinds at home in the livingroom but at least twice a year, when there's the change from summer to wintertime or the other way round, these things **suck**.

*Where's the manual? I already did this a dozen times, can't be so difficult...*

Turns out it is difficult. I believe these things are made to never be touched again.

So far so good.
Since the broadening of home automation solutions, especially HomeKit there was the need to add other devices without an official certification.
For this is [homebridge](https://github.com/nfarina/homebridge), but after a quick'n'dirty search for a plug and play solution i didn't find anything very useful. Next step, order a Raspberry Pi zero, a double relay, read somewhere about how easy it is to use gpio with Python.

## Update 2018-11-29 :
I just moved the Frontend into the main Repository so it's much more transparent to see, whats going on there for everyone.

### First Steps

So Python is an interpreted language, wich is very nice for hacking like this because, whenever you save a change to the file, your system gets restarted.

My first approach was a flask boilerplate with some routes so you get an understanding on how this works there.

```python
@app.route('/status')
def status()
	return "something"
```


So the second step is how to make things blink.

Nice thing about the common relays you get on ebay or amazon or somewhere else, they all have a LED for the activated relay.

```python
from gpiozero import LED
pinNumber = 27
roll = LED(pinNumber)
roll.on()
# is now on...
```

So if you're a Sherlock you can do things like this:

```python
@app.route('/turn-on')
def turnOn()
	roll.on()
    return "your LED is now on! aka something is moving!"
```

### Fine Tuning

Sometimes when is really hot outside or the sun is shining on your glossy screen, you don't want to close the blinds completely but rather just 50%.

So for this case, the only known method to me is to make this over a time factor. Movement should be pretty constant, so moving 20% should require double the time of 10% moving. But because there is some difference between the upward and downward movement, you need two factors to calculate the time.

So this is how i made it work:

1. ``` travel = int(abs(currentHeight - desiredHeight))```
2. ```sleep(travel * config.upFactor) ``` or ```config.downFactor```

But because this isn't the completly perfect method, i reset the ```currentHeight``` whenever I want it 0 or 100.


Lastly, Flask runs threaded on default, means for every new request it spins up a new thread. Since the HomeKit drag options makes a lot of calls when you move your finger slowly, i disabled this feature with ```app.run(debug=False, host='0.0.0.0', threaded=False)```. Flask also runs at localhost per default, so change that, too.


## Frontend

Because I already had the vue-cli installed, i started with the minimal boilerplate which ships with it, deleted everything unnecessary and hacked a mobile-optimized button layout together. I see there some potential to make it more usable but does the work for now..



## Recap: What I learned
My biggest gain with this little project is that python is really easy to pick up, build a prototype and play around with it. I definetly have no idea how Python performs in a production enviroment where it counts on speed and security. But as long as i treat my home network as a secure enviroment, this shouldn't become a problem.

Second, Flask is a nice framework, easy to understand when you'd like to do something real quick. So a recommendation for a project like this.

Because there are a lot of people who aren't using Apple's HomeKit I build my first [Vue.js](https://vuejs.org) Frontend for this case where you have two big buttons and a slider for the percental settings (Link below).

I played around with Vue for another project but it was a rather complex thing to start with it. I created a project with vue-cli and deleted everything i didn't need, maybe not the best approach for such a simple thing, but I really like the approach to have your HTML, JS and CSS all in just one file. You can split up your Frontend in different submodules wich is very neat in my opinion!

**The exported project embedded in the main repository, ready to use!**


## Links


[My repository](https://github.com/tillepille/rolladensteuerung)

[Flask](http://flask.pocoo.org)

[My Frontend](https://github.com/tillepille/rolladensteuerung-frontend)
