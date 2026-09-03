# Off the Rails

> A polished Rails CRUD example for creating, browsing, editing, and deleting posts.

[![CI](https://github.com/seangibbens/off-the-rails/actions/workflows/ci.yml/badge.svg)](https://github.com/seangibbens/off-the-rails/actions/workflows/ci.yml)
![Ruby 4.0.6](https://img.shields.io/badge/ruby-4.0.6-CC342D?logo=ruby&logoColor=white)
![Rails 8.1](https://img.shields.io/badge/rails-8.1-D30001?logo=rubyonrails&logoColor=white)
![SQLite](https://img.shields.io/badge/database-SQLite-003B57?logo=sqlite&logoColor=white)

## Why This Repo

Off the Rails is a focused Rails example built around one resource: posts. It demonstrates conventional resource routing, server-rendered HTML, JSON responses, responsive Tailwind CSS styling, and production-minded Rails defaults without burying the core implementation under unnecessary complexity.

## Highlights

- Full posts CRUD flow
- Server-rendered HTML views with Turbo-enhanced navigation
- JSON representations for posts CRUD endpoints
- Responsive Tailwind CSS interface
- Rails health check at `/up`
- SQLite-backed application with database-backed Solid adapters

## Tech Stack

| Technology | Role |
| --- | --- |
| Ruby 4.0.6 | Application runtime |
| Rails 8.1.3.1 | Web framework |
| SQLite 2.9.6 | Application database |
| Puma 8.0.2 | Web server |
| Hotwire | Turbo navigation and Stimulus behavior |
| Importmap | JavaScript dependency management |
| Tailwind CSS 4.6 | Utility-first styling |
| Solid Cache, Queue, and Cable | Database-backed Rails adapters |
| Active Storage, Image Processing, and ruby-vips | Image storage and transformations |

## Quick Start

### Prerequisites

- Ruby 4.0.6
- Bundler
- libvips, required by `ruby-vips` and Active Storage image processing

Set up the dependencies and database with:

```sh
bin/setup
```

Start the development server with:

```sh
bin/dev
```

Then open [http://localhost:3000/posts](http://localhost:3000/posts). The setup script installs dependencies, prepares the database, clears old logs and temporary files, and starts the server unless `--skip-server` is provided. The seed file is currently empty, so the posts list starts without sample records.

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

| Directory | Purpose |
| --- | --- |
| `app/controllers` | Request handling, including the posts CRUD controller |
| `app/models` | Active Record models |
| `app/views` | HTML and JSON presentation |
| `config` | Application, route, environment, and deployment configuration |
| `db` | Migrations, schema, and seed data |
| `spec` | RSpec support and configuration |
| `test` | Rails test suite |
| `.github/workflows` | Continuous integration workflow |

## API Surface

The posts resource supports both HTML and JSON representations. Add `.json` to a posts URL to request JSON.

| Method | Path | Purpose |
| --- | --- | --- |
| `GET` | `/posts` | List posts |
| `GET` | `/posts/:id` | Show one post |
| `POST` | `/posts` | Create a post |
| `PATCH` or `PUT` | `/posts/:id` | Update a post |
| `DELETE` | `/posts/:id` | Delete a post |
| `GET` | `/up` | Application health check |

## Deployment

The repository includes a production Dockerfile and Kamal configuration for container-oriented deployment. The Docker image installs SQLite and libvips, runs the application as a non-root user, and exposes port 80. `config/deploy.yml` configures persistent storage for SQLite and local Active Storage files.

These files provide deployment configuration, not a hosted deployment. Review `Dockerfile`, `config/deploy.yml`, and `.kamal/secrets` before deploying to your own infrastructure.
