---
title: "Speedtests"
date: 2018-11-13T21:30:15+01:00
draft: false
---

*about browsers und speedtests*

# Internet of Speeds

Since I got a Gigabit Connection at home over DOCSIS 3.1 (at least Downsteam, Upstream is 50MBit), i like too see how fast my internet is.
When your alone there aren‘t really many use cases where you need such a fast connection.  
But beside seeing the speeds on the interface of the router, eventually it was difficult to test the actual speeds.

## Disclaimer
All the tests were made on a 2017 iMac with Cat5e cable connection. I made several test over multiple days but that didn‘t vary a lot so I think these are represantable Screenshots. Also i didn‘t disconnect anything else in the House, this is just my Experience no scientific research...

### Reference
AVM newest Fritzbox 6591 shows a 1095,7 Mbit down- and 54,8MBit upstream. Also thats what the contract says.

____



The first thing i tried was the OOKLA Speedtest from the Mac App Store. It is the 'offline' version of speedtest.net. Test on same server as the web version. See the results here: Ouch, thats almost the same as on the old plan!

![local speed test](/speedtest/speedtest_local.png)

## [Speedof.me](speedOf.Me)
Okay, next try... I have this bookmark on my phone for the cases you‘re bored and check the speed without the need of an app or you're at some customers site and want to isolate sources of trouble.
It‘s called [speedof.me](speedof.me)

They claim to be very accurate because of the lack of plugins like flash or java.


### Safari
Whoops, thats also not what i expected... Roundabout a quarter of the expected result.

![speedofme-safari](/speedtest/speedof_safari.png)

### Firefox
So time for alternatives I heard about this Firefox wich got a big performance update some time ago, open it, update from version 40something, and whoaaa, almost double the speed!

![speedofme-firefox](/speedtest/speedof_firefox.png)

### Chrome
Only half of Firefox's measurement. This is nothing to boast about.

![speedofme-chrome](/speedtest/speedof_chrome.png)

## [Fast.com](fast.com)

Is powered by Netflix and is a pretty straight forward page as you see.

fast.com had the most varying results from 30MBit to 1.1GBit. At least in Safari I needed several attempts to get a realistic result.
The downside of this site is the lack of any other statistics than speed, for me as a geek: essential!

### Safari
Okay, here are the real speeds going!

![fast-safari](/speedtest/fast_safari.png)

### Firefox
I expected to be Firefox even as fast as Safari because of Speedof.me but Firefox couldn‘t hold it‘ first place.

![fast-firefox](/speedtest/fast_firefox.png)

### Chrome

Chrome is better here but also lacks on the same level as Firefox here.

![fast-chrome](/speedtest/fast_chrome.png)

## [Speedtest.net](speedtest.net)

I tested various endpoints but nothing got the full speed around here.

Generally I'm staggered, that the dedicated App is definetly worse than the web version.

### Safari

Again ahead of the race but slower than fast.com

![speedtest-safari](/speedtest/speedtest_safari.png)

### Firefox

Whohoo, it's becoming a head to head race here with Safari.

![speedtest-firefox](/speedtest/speedtest_firefox.png)

### Chrome

Again behind the other competitors.

![speedtest-chrome](/speedtest/speedtest_chrome.png)



## Speedtest from [local ISP](speedtest.unitymedia.de)

Here they are all on the same level, maybe its correlates with the fact that there is (theoretically) the least amount of interfering traffic.
Thats why I stopped taking screenshots, exept one:  

![unity-firefox](/speedtest/unity_firefox.png)

____

## Conclusion
In the first place i was suprised because i thought speed test are there to test the speed. So they should be capable of handling even the maddest of connections.

It was interesting to see how each of the browser performs and why there are so big differences even on the 'purest' test like speedof.me .

I think it is showing how the positions in the big browser game are. It's very close but I think it's wrong to say that Chrome is the fastest ( = best) and Safari the slowest (= worst) browser of the big three.  

Also I have to mention that in real world usage I see relatively constant rates between 96MB/s up to 116MB/s depending on where you consume. So in max this equals 928MBit which is about 10% less from the maximum rates.



And yes, I hear your whining about your lame 16MBit connection with 1MBit upstream. And guess what? You still can read this! Isn't that great?

It is incredible on what a high level I can complain about things like this ( ^^ )...


## Comparison chart

![comparison](/speedtest/comp.png)
