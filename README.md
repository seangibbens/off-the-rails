# Off the Rails

> A polished Rails application with a playful dashboard, passwordless authentication, and rich-text publishing.

[![CI](https://github.com/seangibbens/off-the-rails/actions/workflows/ci.yml/badge.svg?&style=for-the-badge)](https://github.com/seangibbens/off-the-rails/actions/workflows/ci.yml)
![Ruby 4.0.6](https://img.shields.io/badge/ruby-4.0.6-CC342D?logo=ruby&logoColor=white&color=003B57)
![Rails 8.1](https://img.shields.io/badge/rails-8.1-D30001?logo=rubyonrails&logoColor=white&color=003B57)
![SQLite](https://img.shields.io/badge/database-SQLite-003B57?logo=sqlite&logoColor=white)

## Why This Repo

Off the Rails is a focused Rails example built around an authenticated personal dashboard and a complete posts resource. It demonstrates passwordless sessions, conventional resource routing, server-rendered HTML, JSON responses, rich-text editing, responsive Tailwind CSS styling, and production-minded Rails defaults without burying the core implementation under unnecessary complexity.

## Highlights

- Responsive bento-grid home page linking to Posts, Notes, Games, and About
- Passwordless email sign-in with single-use links and 30-day sessions
- Full posts CRUD flow with Lexxy and Action Text rich-text editing
- Server-rendered HTML views with Turbo-enhanced navigation
- JSON representations for posts CRUD endpoints
- Responsive Tailwind CSS interface with light and dark themes
- Local email previews through Mailpit
- Rails health check at `/up`
- SQLite-backed application with database-backed Solid adapters

## Tech Stack

| Technology                                      | Role                                   |
| ----------------------------------------------- | -------------------------------------- |
| Ruby 4.0.6                                      | Application runtime                    |
| Rails 8.1.3.1                                   | Web framework                          |
| SQLite 2.9.6                                    | Application database                   |
| Puma 8.0.2                                      | Web server                             |
| Hotwire                                         | Turbo navigation and Stimulus behavior |
| Action Text and Lexxy                           | Rich-text post editing and rendering    |
| Importmap                                       | JavaScript dependency management       |
| Tailwind CSS 4.6                                | Utility-first styling                  |
| Mailpit                                         | Local passwordless sign-in email inbox  |
| Solid Cache, Queue, and Cable                   | Database-backed Rails adapters         |
| Active Storage, Image Processing, and ruby-vips | Image storage and transformations      |

## Quick Start

### Prerequisites

- Ruby 4.0.6
- Bundler
- libvips, required by `ruby-vips` and Active Storage image processing
- Mailpit, required to receive local sign-in links

Set up the dependencies and database with:

```sh
bin/setup
```

Start Mailpit in a separate terminal so sign-in emails can be delivered locally:

```sh
mailpit
```

Start the development server with:

```sh
bin/dev
```

Then open [http://localhost:3000](http://localhost:3000), enter an email address, and retrieve the one-time sign-in link from the Mailpit inbox at [http://localhost:8025](http://localhost:8025). After authentication, the home page presents the available sections in a responsive bento grid.

The setup script installs dependencies, prepares the database, clears old logs and temporary files, and starts the server unless `--skip-server` is provided. The seed file is currently empty, so the posts list starts without sample records.

## Useful Commands

```sh
# Run the Rails test suite
bin/rails test

# Check Ruby style
bin/rubocop

# Run security checks
bin/brakeman --no-pager
bin/bundler-audit
bin/importmap audit

# Prepare the database
bin/rails db:prepare
```

Run the full local CI suite with:

```sh
bin/ci
```

The CI workflow runs Ruby and JavaScript dependency audits, RuboCop, Brakeman, and the Rails tests.

## Project Structure

| Directory           | Purpose                                                       |
| ------------------- | ------------------------------------------------------------- |
| `app/controllers`   | Authentication, dashboard, static page, and posts requests     |
| `app/models`        | Active Record models                                          |
| `app/views`         | Dashboard, HTML, rich-text, email, and JSON presentation       |
| `config`            | Application, route, environment, and deployment configuration |
| `db`                | Migrations, schema, and seed data                             |
| `spec`              | RSpec support and configuration                               |
| `test`              | Rails test suite                                              |
| `.github/workflows` | Continuous integration workflow                               |

## Application Routes

The dashboard and placeholder sections are authenticated HTML pages. The posts resource supports both HTML and JSON representations; add `.json` to a posts URL to request JSON.

| Method           | Path         | Purpose                            |
| ---------------- | ------------ | ---------------------------------- |
| `GET`            | `/`          | Show the authenticated bento home  |
| `GET`            | `/notes`     | Show the Notes placeholder          |
| `GET`            | `/games`     | Show the Games placeholder          |
| `GET`            | `/about`     | Show the About placeholder          |
| `GET`            | `/posts`     | List posts                          |
| `GET`            | `/posts/:id` | Show one post                       |
| `POST`           | `/posts`     | Create a post                       |
| `PATCH` or `PUT` | `/posts/:id` | Update a post                       |
| `DELETE`         | `/posts/:id` | Delete a post                       |
| `GET`            | `/up`        | Application health check            |

## Deployment

The repository includes a production Dockerfile and Kamal configuration for container-oriented deployment. The Docker image installs SQLite and libvips, runs the application as a non-root user, and exposes port 80. `config/deploy.yml` configures persistent storage for SQLite and local Active Storage files.

These files provide deployment configuration, not a hosted deployment. Review `Dockerfile`, `config/deploy.yml`, and `.kamal/secrets` before deploying to your own infrastructure.
