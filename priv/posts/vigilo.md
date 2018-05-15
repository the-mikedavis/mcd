---
title: Vigilo - the Dorm Room Watcher
date: 2018-05-14
intro: Splitting a room can be awkward. Vigilo makes it easier.
---

### The Story

If you've ever shared a room with a roommate, you've probably said this a
thousand times: _I wonder if \<insert name here\> is in the room right now._
Well, at least I know I did. Whether it's to take a nap, change clothes, or
just run in and grab a book, entering a shared room can quickly become an
ordeal especially when your roommate has a girlfriend. To make it all much
simpler, I came up with Vigilo.

The idea for the interface was simple and immediate: a yes or no. Is the
roommate in the room? The only thing I needed was a way to test it. I
remembered someone telling me about a system they had in their house that
would play a _ding_ anytime someone connected their phone to the WiFi. Of
course, it's not a bullet-proof security system (just shut off your WiFi and
you're invisible), but that's not the point. It's just supposed to be a
convenient way to know.

My initial look into the campus WiFi made it clear. WiFi was not an option.
I thought about tracking the radio signals or something like that, but then it
hit me: what's exactly like WiFi but way less regulated by the campus?
Bluetooth.

I did some searching around and found
[this](https://raspberrypi.stackexchange.com/a/42544). It's the perfect
answer. All you have to do is link the phone to a computer and then you can
use `hcitool` to scan around and initiate a "handshake" with known devices.
It doesn't cost too much battery and doesn't disrupt the phone. In fact, I
didn't notice any mal-effects in an entire semester of use. I had a raspberry
pi laying around, so I decided to give it a shot.

I wanted to create a simple web interface. Open the web app anywhere and you
get a list of who's in the room. I fired up a new Phoenix project and threw
it in.

It took a while and the requests kept timing out. `hcitool` can be really
slow. I took what I had and added a GenServer to keep track thanks to
[Jose Valim's answer](https://stackoverflow.com/a/32097971/7242773). The
trade-off is small. Instead of having a very functional web app, as Elixir
projects usually are, I have a state-based app that keeps track of what
it last saw. On a regular interval, it'll scan for devices and then remember
what it saw. Then when a user queries the website, it will respond with what's
in the memory. And if you scan often enough, it pretty much answers the
question "who's in the room?"

So I set it up for a while. It worked okay, but it was hard to reach the
raspberry pi's IP. I couldn't reach it across campus and I was pretty sure
I knew why. The IP addresses worked great when two computers were right next to
each other. The problem was being on different routers. So at was the solution?
A public website.

Right on this very website, for over two months, I posted the JSON from
Vigilo and put it on an unlinked page: `/vigilo`. Then all I had to do was
pull it up on my phone and anywhere and everywhere I could see who was in
the room.

(N.B.: now that page is gone because I no longer share a room.)

### On Your Own

Want to build this yourself? It's not too hard. Go to the
[Vigilo GitHub](https://github.com/the-mikedavis/vigilo) and clone it and
follow the instructions there. Then you can make a small edit to your
server. All you need is a JSON POST API to get the names. To see what I
did for my phoenix server, check out
[this commit](https://github.com/the-mikedavis/website-phoenix-version/commit/f21faed66a654f7203226e4c136aee4303be4871)
where I disabled it. And
[the controller](https://github.com/the-mikedavis/website-phoenix-version/blob/master/lib/mcd_web/controllers/vigilo_controller.ex)
that accepts the JSON and servers the pages.
