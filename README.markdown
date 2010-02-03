A Ruby server for amalgamating World of Warcraft guild achievement feeds.

For what it's worth, there's a live version of this codebase running at <http://achievements.movieos.org> tracking the achievements of [my guild][1].

Some notes cribbed from [my blog entry](http://jerakeen.org/notes/2009/02/warcraft-guild-achievements-as-rss/):

The trick to scraping the [Armoury][3] is pretending to be Firefox. If you visit as a normal web browser, they serve you a traditional HTML page with some Ajax, and it's all quite normal and boring. If you visit the armoury in Firefox they return an XML document with an XSL stylesheet referenced in the header that transforms the XML into a web page. Why are they doing this? It must be a _huge_ amount of work compared to just serving HTML, I don't get it. Let's ignore that. Fake a firefox user agent, and you can fetch lovely XML documents that describe things!

There's no 'guild achievement' page, alas, so we start by fetching the page that lists the people in the guild. The rendered web page has pagination, but the underlying XML seems to have all characters in a single document, so no messing around fetching multiple pages here (I've tried this on a guild of 350ish people).

The next thing we have to do is loop over every character and fetch their achievements page. This is extremely unpleasant and slow, so the app does it in a cronjob.

My biggest annoyance here is that there's no timestamp on these things better than 'day', so you don't get very good ordering when you combine them later. I could solve this by storing some state myself, remembering the first time I see each new entry, etc, etc, but in practice this falls down very badly because the Armoury is a very unreliable resource. Sometimes you just can't fetch toons. You have to throttle requests. Just accept that the data isn't there.

Anyway, now I have a list of everyone in the guild, and their last 5 achievements (the code will also backfill for the initial load, so you can get everything). It's pretty trivial building a list of these and outputting Atom or something. I do it using 'print' statements, myself, because I'm inherently evil. You can't deep-link to the achievement itself on the Armoury, so I link to the [wowhead page][7] for individual achievements.

Because the Armoury is unreliable, and my script is slow, I don't use this thing to generate the data on demand. I have a crontab that fetches toons from the armoury every 3 hours. It's throttled, doens't try to hit everyone at once, and prioritises people we haven't fetched in the longest, so it does a reasonable job of keeping up. If it doesn't explode, it copies the result into the database, and the front end display it. If it _does_ explode, then meh, I'll try again in an hour. The feed isn't exactly timely, but we're not controlling nuclear power stations here, we're tracking a computer game. It'll do.

[1]: http://www.unassignedvariable.org/
[3]: http://eu.wowarmory.com/guild-info.xml?r=Nordrassil&n=unassigned+variable&p=1
[4]: http://www.aaronsw.com/2002/xmltramp/
[7]: http://www.wowhead.com/?achievement=1559