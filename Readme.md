# Hooks

[Kitchen Hooks](http://git.bluejeansnet.com/kitchen-hooks) provide a GitLab
WebHoook for automated Chef Server uploads following Kitchen standards.


## Installation

Clone the repo and `rake build`.


## Usage

After installing the gem, the `kitchen_hooks` executable should be available:

    $ kitchen_hooks help
    Commands:
    kitchen_hooks art             # Show application art
    kitchen_hooks help [COMMAND]  # Describe available commands or one specific command
    kitchen_hooks server          # Start application web server
    kitchen_hooks version         # Show application version

Use the `server` command to start the WebHook receiver:

    $ kitchen_hooks server -c etc/config.json -p 80 -e production
    == Sinatra/1.4.5 has taken the stage on 80 for production with backup from Thin
    Thin web server (v1.6.3 codename Protein Powder)
    Maximum connections set to 1024
    Listening on 0.0.0.0:80, CTRL+C to stop
    ...


## TODO

* Use Ridley for data bag, role, and environment uploads to remove Chef dependency


## Changelog

### 1.2

* Added `berks upload` functionality when tagging realm releases

### 1.1

* Moved `examples` to `etc`
* Started checking in `Gemfile.lock` for future reference
* Added `port` and `environment` options to `kitchen_hooks server`
* Move `rake fpm` `.deb` artifacts under `pkg` alongside `.gem` files
* Commits to the Kitchen trigger data bag, role, and environment uploads
* Tagging a cookbook with a version triggers a cookbook upload (frozen)
* Tagging a realm with the name of an environment applies version constraints

### 1.0

* Initial release. Gem structure in place, but lacking functionaily