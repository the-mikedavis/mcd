---
title: Use MongoDB in Express Middleware to Store Node.js Website Traffic
date: 2017-07-25
intro: Am I storing your traffic on my site? No. But could I? Yes, and quite easily.
---

MongoDB is an increasingly popular document-based database system. Its format is similar to JSON, which makes it a perfect match for the full-stack JavaScript developer.

I've set up my website to have a MongoDB store which keeps track of all traffic. N.B.: I'm actually not paranoid.

## Try it at Home!

Before I deploy anything to the server, I try to get it going on my Mac. The instructions for mac and linux are very similar. If you only have a Linux distro, skip down to Install. This should cover the install for mac.

I used [these](https://treehouse.github.io/installation-guides/mac/mongo-mac.html) instructions.

```shell
$ brew install mongodb

$ mkdir -p /data/db

$ sudo chown -R /data/db

$ mongod
```

In a new shell,

```shell
$ mongo
```

## Install

My computer runs Elementary OS, which draws heavily from Ubuntu. As long as you're running any Ubuntu derivative, this should work. For other distributions, the installation instructions may vary. The mongo tools should be the same. I got my instructions from the link above and from the wonderful people at Digital Ocean [here](https://www.digitalocean.com/community/tutorials/how-to-install-mongodb-on-ubuntu-16-04).

### MongoDB

```shell
$ sudo apt install mongodb-server

$ sudo mkdir -p /data/db

$ sudo chown -R `id -un` /data/db

$ sudo systemctl start mongodb

$ sudo systemctl status mongodb

$ sudo systemctl enable mongodb
```

Check your databases with `$ mongo`

### Mongoose

Mongoose takes a lot of the hassle out of MongoDB.

```shell
$ sudo npm install mongoose@4.10.8
```

There's an odd deprecation warning (which as far as I know is non-fatal) which you can avoid in this version.

### Node & Express

If you don't already have Nodejs and Express, check out my [home server]('http://mcarsondavis.com/projects/home-server') project. Most of the Mongoose.js scripting must be attributed to [the quick start page](http://mongoosejs.com/docs/index.html).

```js
const express = require('express'),
    mongoose = require('mongoose'),
    app = express();

//	Use the native Node.js V8 Promises
mongoose.Promise = global.Promise;
//	Connect to the database with name traffic
//	If the database isn't there, it will be created
mongoose.connect('mongodb://localhost/traffic');
//	Open up the connection
const db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error'));
db.once('open', function () {
    console.log('Traffic DB connected.');
});

//	Create a Schema to store the traffic. This is
//	some commonly logged traffic stuff.
const trafficSchema = mongoose.Schema({
    ip: String,
    date: String,
    method: String,
    url: String,
    httpVersion: Number,
    status: String,
    referrer: String,
    userAgent: String
}),
     //	Create an object to instantiate. Each log of traffic will
     // become a Traffic object. This is a "Model"
    Traffic = mongoose.model('Traffic', trafficSchema);

//  write the traffic to the database
//	this is the "middleware"
app.use(function (req, res, next) {
  //	because I run node through nginx, in order to get the
  //	actual address of the user, I need this big thing.
    const ip = req.headers['x-forwarded-for'] ||
        req.connection.remoteAddress ||
        req.socket.remoteAddress ||
        req.connection.socket.remoteAddress;


    //  methods to get values borrowed from morgan (the npm module)
    const t = new Traffic({
        ip: ip,
        date: (new Date()).toUTCString(),
        method: req.method,
        url: req.originalUrl || req.url,
        httpVersion: Number(req.httpVersionMajor + '.' + req.httpVersionMinor),
        status: res._header ? String(res.statusCode) : undefined,
        referrer: req.headers['referer'] || req.headers['referrer'],
        userAgent: req.headers['user-agent']
    });

    //save to the database
    t.save().catch(err => console.log('Failed to save to database'));

    next();
});

app.get('/', function (req, res) {
    res.send('Hello, World!');
});
```
