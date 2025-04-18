# Night City Navigator

This is a fork of the [openstreetmap-website](https://openstreetmap/openstreetmap-website) project,
modified to support mapping the world of the game Cyberpunk 2077 instead of the real world.

# Everything below this line is the openstreetmap-webiste README:

[![Lint](https://github.com/openstreetmap/openstreetmap-website/workflows/Lint/badge.svg?branch=master&event=push)](https://github.com/openstreetmap/openstreetmap-website/actions?query=workflow%3ALint%20branch%3Amaster%20event%3Apush)
[![Tests](https://github.com/openstreetmap/openstreetmap-website/workflows/Tests/badge.svg?branch=master&event=push)](https://github.com/openstreetmap/openstreetmap-website/actions?query=workflow%3ATests%20branch%3Amaster%20event%3Apush)
[![Coverage Status](https://coveralls.io/repos/openstreetmap/openstreetmap-website/badge.svg?branch=master)](https://coveralls.io/r/openstreetmap/openstreetmap-website?branch=master)

This is `openstreetmap-website`, the [Ruby on Rails](https://rubyonrails.org/)
application that powers the [OpenStreetMap](https://www.openstreetmap.org) website and API.

This repository consists of:

* The web site, including user accounts, diary entries, user-to-user messaging.
* The XML- and JSON-based editing [API](https://wiki.openstreetmap.org/wiki/API_v0.6).
* The integrated version of the [iD](https://wiki.openstreetmap.org/wiki/ID) editor.
* The Browse pages - a web front-end to the OpenStreetMap data.
* The GPX uploads, browsing and API.

A fully-functional `openstreetmap-website` installation depends on other services, including map tile
servers and geocoding services, that are provided by other software. The default installation
uses publicly-available services to help with development and testing.

# License

This software is licensed under the [GNU General Public License 2.0](https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt),
a copy of which can be found in the [LICENSE](LICENSE) file.

# Installation

`openstreetmap-website` is a Ruby on Rails application that uses PostgreSQL as its database, and has a large
number of dependencies for installation. For full details please see [INSTALL.md](INSTALL.md).

# Development

We're always keen to have more developers! Pull requests are very welcome.

* Bugs are recorded in the [issue tracker](https://github.com/openstreetmap/openstreetmap-website/issues).
* Translation is managed by [Translatewiki](https://translatewiki.net/wiki/Translating:OpenStreetMap).
* Local Chapters shown on the Communities page, and their translations, come from [osm-community-index](https://github.com/osmlab/osm-community-index).
* There is a [rails-dev@openstreetmap.org](https://lists.openstreetmap.org/listinfo/rails-dev) mailing list for development discussion.
* IRC - there is the #osm-dev channel on irc.oftc.net.

More details on contributing to the code are in the [CONTRIBUTING.md](CONTRIBUTING.md) file.

# Maintainers

* Tom Hughes [@tomhughes](https://github.com/tomhughes/)
* Andy Allan [@gravitystorm](https://github.com/gravitystorm/)
* Anton Khorev [@AntonKhorev](https://github.com/AntonKhorev/)
