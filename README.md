# MobilizeAmerica BE Assignment

A simple link shortener, implemented using Rails, MySQL, and Redis.


## Install

1. Install Ruby 2.4.0, Rails 5.2.3, MySQL 8.0.16, and Redis 5.0.5
2. Clone this repository.
3. `bundle install`
4. `bundle exec rails s`.

## API

This project exposes the following API:

| Route         | Method   | Parameters | Function  | Returns |
| ------------- |:-------------:| ------|-----|-----|
| `/links/new`   | POST          | `original_url`: The URL to be shortened. <br> `custom_url`: Optional custom short link. | Shortens a given link.| JSON object containing short link, or `500` if custom short link is taken. |
| `/:short_link`        | GET           | None | Redirects a given short link.| HTTP Redirect, or `404`. |
| `/stats/:short_link`  | GET           | None | Retrieve stats on a given short link.| JSON object containing stats pertaining to short link, or `404`. |