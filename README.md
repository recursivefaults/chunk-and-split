# Splitting vs Chunking Code

This repository contains two small projects that show the same code with the same functionality organized in two very
different ways. The `split` directory organizes the code into very small methods and classes. The `chunk` directory,
by contrast, favors larger chunks of code and avoiding the use of private methods.

## What should you do with this?

Well, look through the code and tests. See what you like and don't. Try making equivalent changes to each one. See what
style suits you, what trade-offs you make, and form some conclusions about how you prefer to shape code. These two
examples try to create very polar opposites, so there is a lot of mixing-and-matching in-between.

## How-to set up the project

After cloning the repo you'll need Ruby installed. This repository doesn't make use of any specific ruby features that
you need to work around. Any version after 3.0 should work fine.

In each directory you can run the following commands:

1. `bundle install`
2. `rspec` or `bundle exec rspec`

