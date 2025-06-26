
# Tag Snooper

Tag Snooper is a lightweight Dockerized tool designed to monitor GitHub repositories for new tags and send email notifications when updates are detected. It uses a combination of cron jobs and file watchers to ensure timely detection of changes.

## 📦 Overview

This project monitors a list of GitHub repositories for new tags. If a new tag is published in any of the monitored repositories, it sends an email alert to a configured recipient. It operates in two modes:

- **Cron job**: Performs checks twice a day (default: 08:00 and 20:00).
- **File watcher**: Reacts immediately when `repositories.txt` is modified.

## 🛠 How It Works

1. `check_tags.sh` parses a list of repositories with their last known tags and queries GitHub for updates.
2. If a new tag is found, it updates the list and sends an email using `mutt`.
3. `watch_file.sh` monitors `repositories.txt` for changes and reruns `check_tags.sh` as needed.
4. `crontabfile` triggers periodic checks via cron.

## ⚙️ Requirements

- Docker and Docker Compose installed.
- Internet connection to access GitHub and SMTP server.
- A valid SMTP account (e.g., Gmail relay) for sending emails.

## 📄 Configuration

### 1. `repositories.txt`

Each line should define a repository and its last known tag, separated by a space:

```
octocat/Hello-World v1.0.0
nodejs/node v18.0.0
```

- Lines starting with `#` are treated as comments.
- Tags must exactly match those published on GitHub.

### 2. `muttrc`

Create a `.muttrc` file in `conf/muttrc` with SMTP credentials:

```
set smtp_url = "smtp://account@gmail.comt@smtp-relay.gmail.com:587/"
set smtp_pass = "your_password_here"
set from = "tag-snooper@gmail.com"
set realname = "Tag Snooper"
set ssl_starttls = no
set ssl_force_tls = yes
```

> ⚠️ **Security Tip**: Avoid committing `.muttrc` with real credentials to version control. Use environment variables or Docker secrets instead.

## 🚀 Usage

### Configuration
Configure the recipient mail in the docker-compose file:
```yml
    environment:
      - RECIPIENT=recipient@gmail.com
```

### Build and Run

```bash
docker-compose build
docker-compose up -d
```

## 🛠️ Troubleshooting

```bash
docker-compose logs -f
```

## 🧪 Example

Your `repositories.txt`:

```
vercel/next.js v13.4.0
facebook/react v18.2.0
```

You'll receive an email if any of these repositories release a new tag.


## ✅ Improvements & Recommendations

- ✅ **Resilience**:
  - Add error handling to `check_tags.sh` for `curl` failures or GitHub rate limits.

- 🔒 **Security**:
  - Move SMTP credentials to environment variables or Docker secrets.
  - Avoid storing passwords in plain text (`muttrc`).

- 📦 **Better File Handling**:
  - Add file locking during tag updates to prevent race conditions.
  - Maintain a log file to trace all updates and errors.

- 🚧 **Future Enhancements**:
  - Add webhook support for real-time GitHub integration.
  - Add a simple web UI for managing repositories.

---

### 📄 License

This project is licensed under the [MIT License](LICENSE).

You are free to use, modify, and distribute this software, as long as the original copyright and license notice are included.


© Lorenzo Mirabella - Tag Snooper