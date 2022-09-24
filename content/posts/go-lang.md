---
title: "Go Lang Adventure"
date: 2018-12-07T20:15:20Z
draft: false
---

This week I participated in a Hackathon organized by [bee42](https://bee42.com) at their location. It was focused on students of the FH Dortmund grad school, but me and a friend of me participated as well. We both know Docker and had experience working with git, wich, unfortunately, the other students didn't seem to have.

The goal was to make a better version of [https://github.com/dockersamples/example-voting-app](https://github.com/dockersamples/example-voting-app), to be mindful of the [12 factor rules](https://12factor.net) and just have fun, of course!

After we managed to improve both the voting as well as the result service, we had the keen idea to completly rewrite the worker in Go. 

You need to pop a Vote ```{id:vote}``` from a redis list and store it or update it into a SQL Database  (in this case a Postgres).

## Just jump right in

We never used Go, nor had it installed, so we just used it in a container 😎.

After getting a first look & feel on the language, printing out some 'helloWorlds' our first big issue occured. MODULES. 

I used a lot Nodejs recently just go ```npm install whatever-package``` and you're good. Maybe it seem so complicated because we were in a hurry but for me this was far from comfortable or easy.  

But with some help we managed to have our errors about other things than missing imports...

At the end we didn't have enough time to get it running properly, but I think i really learned a lot

## Lessons learned

Besides the fun diving into a completly new language (no matter wich one), Go showed me, that some languages are more difficult to pick up than others, C knowledge matters everywhere, or better knowledge on how a process works with allocations, pointers and so on, and that I should work on that for myself. 

Either way,  I had a ton of fun and will learn more about that language!

