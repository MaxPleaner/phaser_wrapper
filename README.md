### phaser_wrapper

---

**intro**

This is a few projects I built to practice Phaser.js, a video game library.

This framework creates games that can run in WebGL (falling back to Canvas), making them
highly performant. 

Mainly because of the desire for custom hitboxes around sprites, the P2 physics engine is used. 
However not all of the Phaser API works with this - specifically, I still haven't found a good way to do scaling and
anchor offset.

---

**snood-pinball-mightyeditor**

This was my first Phaser project. It was made using the MightyEditor, which has a great 30-min tutorial for creating a game
[here](https://www.youtube.com/watch?v=gzGHMRx3yz0). This tool has a map editor which helps figure out the positioning
coordinates. It also ties in very nicely with Phaser's default physics system "Arcade", but not with P2, so as time went on
I gradually moved all my asset positioning from the map editor to the source code.

This folder contains the mightyeditor itself, which has a web UI and can be self-hosted.

_How to run_:

```sh
cd mightyeditor/mightyeditor
npm install
./startdev
# open localhost:8080, select first project, click 'open game'
```

The source code and map are visible in the web UI. Watch the mightyeditor youtube video first to understand what's going on.
Keep in mind that although sprites appear on the map, they are all located off of the playfield, and that's because they're 
manually positioned in the source code. I kind of forget why I did this, but anyway the map editor's configurations can
break the hitbox so it's not a super dependable tool when using P2. However, mightyeditor will only make assets available
to the source code after they have been placed on the map, hence all of the are located off the playing field. 

_note_

this game is absolute shit. It has kool-aid soaked pickles as flippers, the blue guy from Snood as the ball, 
and nothing else on the playfield.
Also I hadn't yet figured out alot of Phaser/P2 stuff by the time I moved on from this.

---

**8-ball-pool-coffee**

This was Phaser project number two. It was an attempt to set up a local Webpack/Coffeescript environment for Phaser development.
I did not write the actual logic of the game here. I bought the book
[Interphase](http://phaser.io/interphase/1)
and from the included code, found a pool game example.
It was a pretty rote process, just rewriting the codebase in Coffeescript and splitting up some of the files in a
`module.exports` fashion.

Nevertheless, this could potentially be a boilerplate for Webpack/Coffee/Phaser development. It has a few things going for it.
It's a fairly complex game including a lot P2 usage. And the source code is mainly in a few files - it's easy to delete most
of it and get a clean slate. I'm gonna let the source code there be self-explanatory, but for a complete walkthrough of this
pool game see the Interphase book (which was written by Phaser's creators).

There's a `webpack.config.js` here which sets up coffeescript and phaser (which requires some shims)
. It compiles all coffee files into an in-memory `bundle.js` that can be referenced from `index.html` (served by webpack
via the `npm start dev` command).

_to run_

```sh
cd 8-ball-pool-coffee
npm install
npm run dev
# visit http://localhost:8080
**

---

**snood-pinball-coffee**

The last Phaser project before I made myself get around to other things (such as writing this README).

# TODO cover this project
