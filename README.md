# ODDS Boards

ODDS Boards is a Ruby on Rails application built with modern technologies like Bun for JavaScript bundling, Turbo, Stimulus, and PostgreSQL. It provides a fast, secure, and modern web application experience.

## Tech Stack

- **Ruby**: 3.4.2
- **Rails**: 8.0.2
- **Database**: PostgreSQL
- **Authentication**: Devise
- **Frontend**: Hotwire (Turbo + Stimulus)
- **JavaScript Bundler**: [Bun](https://bun.sh/)
- **CSS Bundler**: [cssbundling-rails](https://github.com/rails/cssbundling-rails)
- **Testing Framework**: RSpec + Capybara

## Setup Instructions

### Prerequisites

- Ruby 3.4.2
- PostgreSQL
- Bun (latest version)

Install Bun if you haven't:

```bash
curl -fsSL https://bun.sh/install | bash
```

### Setting Up the Project Locally

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/odds-boards.git
   cd odds-boards
   ```

2. Install Ruby dependencies:

   ```bash
   bundle install
   ```

3. Install JavaScript dependencies:

   ```bash
   bun install
   ```

4. Setup the database:

   ```bash
   rails db:setup
   ```

5. Start the development server:

   ```bash
   bin/dev
   ```

   > This runs both the Rails server and Bun watcher concurrently.

## Running Tests

To run the test suite:

```bash
bin/rspec
```

The project uses:

- [RSpec Rails](https://github.com/rspec/rspec-rails) for unit and request specs
- [Capybara](https://teamcapybara.github.io/capybara/) + [Selenium WebDriver](https://www.selenium.dev/) for system/browser tests

## Deployment on Render.com

This application is ready for deployment on [Render](https://render.com).

**Build Command**:

```bash
bundle install && bun install && bun run build
```

**Start Command**:

```bash
bundle exec puma -C config/puma.rb
```

**Environment Variables** you might need to configure:

- `DATABASE_URL`
- `RAILS_MASTER_KEY` (for decrypting credentials)

**Notes**:
- Make sure you enable a **PostgreSQL database** on Render and connect it to your app.
- Ensure **Bun** is available during build by installing it manually in a Render Build Script or using a [Bun Buildpack](https://github.com/render-examples/bun-on-render) if needed.
- `bun run build` should generate production-ready JS assets (like `app/assets/builds`).

## License

This project is licensed under the [MIT License](LICENSE).

## Contributing

Bug reports and pull requests are welcome!
