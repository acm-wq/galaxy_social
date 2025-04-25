# 🌌 Galaxy Social

> _"In a realm of stars and signals, we connect the galaxies within us."_

Galaxy Social is an experimental, minimalist **social platform** built with **Ruby on Rails** and **Next.js**, using **Redis as the sole database**. A journey into ephemeral data, real-time interactions, and the blending of monolith and frontend freedom.

---

## 🦉 Philosophy

Born from the frozen silence of Siberia, **Galaxy Social** explores the concept of lightweight, real-time connection — where data is transient, interfaces are fast, and complexity is intentionally tamed. It’s a playground for creative backend logic and modern reactive UIs.

---

## 🧩 Stack

### 🔭 Frontend (Next.js)
- File-based routing with `app/` directory
- TailwindCSS for design
- Minimal dependencies for performance and clarity

### 🌌 Backend (Ruby on Rails)
- Rails API-only mode
- Sidekiq for background jobs
- Redis as the single source of truth

---

## 🗺️ Project Structure

```txt
.
├── client/          # Next.js frontend
│   ├── app/         # Application routes
│   ├── lib/         # Shared libraries
│   └── ...          # Standard Next.js files
│
├── server/          # Ruby on Rails API
│   ├── app/         # Models, controllers, jobs
│   ├── config/      # Environment and routes
│   └── ...          # RSpec, Rubocop, Rake tasks
│
├── .editorconfig    # Consistent code style
├── .gitignore
├── LICENSE
└── README.md
```

## 🚀 Getting Started

### 📦 Requirements

- Ruby 3.x
- Node.js 18+
- Redis
- Yarn or npm

### ⚙️ Setup

```bash
# Clone repo
git clone https://github.com/acm-wq/galaxy_social.git

# Check redis
systemctl is-active --quiet redis || {
  sudo systemctl start redis
}

# Backend
cd server
bundle install
rails server

# Frontend
cd ../client
npm install
npm run dev
```

## 🧪 Testing

- **Rails**: `rspec`
- **Next.js**: Coming soon
- **Integration Tests**: Planned

---

## 📚 Inspirations

- [Pixel Planet Generator](https://deep-fold.itch.io/pixel-planet-generator)
- [Redis in 100 Seconds](https://www.youtube.com/watch?v=G1rOthIU-uo&t=8s)
- Love the exp (❤‍🔥🧪)

---

## 💝 Thanks to

- [Deep-Fold](https://deep-fold.itch.io/)
- Everyone wandering through the stars of open source

---

> _"The code we write today will echo in the systems of tomorrow."_
> — **Camil**

-- --